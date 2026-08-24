//
//  PasteboardManager.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2024/10/3.
//  Copyright © 2024 izual. All rights reserved.
//

import AppKit
import KeySender

/// Manager class for pasteboard-related operations
@objc(STKPasteboardManager)
public final class PasteboardManager: NSObject {

    @objc
    public static let shared = PasteboardManager()
    
    /// Polling timeout profile used when waiting for pasteboard updates after copy-like actions.
    /// Most applications usually return success/failure within ~0.1s.
    /// Safari is an observed outlier and often needs more time before pasteboard content stabilizes.
    private enum PollingTimeout {
        static let `default`: TimeInterval = 0.2
        static let safari: TimeInterval = 0.4
    }
    
    private let safariBundleID = "com.apple.Safari"

    /// Get selected text after performing an action that triggers a pasteboard change
    ///
    /// - Parameter afterPerform: The action that triggers the pasteboard change
    /// - Returns: Selected text or nil if failed
    @MainActor
    public func getSelectedText(afterPerform action: @escaping () throws -> Void) async -> String? {
        await fetchPasteboardText(afterPerform: action)
    }

    /// Get the next pasteboard content after executing an action
    ///
    /// - Parameters:
    ///   - restoreOriginal: Whether to preserve the original pasteboard content
    ///   - restoreInterval: Delay before restoring original content
    ///   - afterPerform: The action that triggers the pasteboard change
    /// - Returns: The new pasteboard content if changed, nil if failed or timeout
    @MainActor
    public func fetchPasteboardText(
        restoreOriginal: Bool = true,
        restoreInterval: TimeInterval = 0.0,
        afterPerform action: @escaping () throws -> Void
    ) async -> String? {
        logInfo("Getting next pasteboard content")

        let pasteboard = NSPasteboard.general
        let initialChangeCount = pasteboard.changeCount
        var newContent: String?
        // The last change count accepted as the result of `action`. Used to
        // detect writes made by others before restoring the backup.
        var lastObservedChangeCount = initialChangeCount

        let executeAction = { [self] in
            do {
                logInfo("Executing trigger action")
                try action()
            } catch {
                logError("Failed to execute trigger action: \(error)")
                return
            }

            await pollTask({
                // Check if the pasteboard content has changed
                if pasteboard.changeCount != initialChangeCount {
                    // !!!: The pasteboard content may be nil or other strange content(such as old content) if the pasteboard is changing by other applications in the same time, like PopClip.
                    newContent = pasteboard.string
                    if let newContent, !newContent.isEmpty {
                        lastObservedChangeCount = pasteboard.changeCount
                        logInfo("New Pasteboard content: \(newContent)")
                        return true
                    }

                    logError("Pasteboard changed but no valid text content found")
                    return false
                }
                return false
            }, timeout: currentPollingTimeout())
        }

        if restoreOriginal {
            await pasteboard.performTemporaryTask(
                restoreInterval: restoreInterval,
                shouldRestore: {
                    // Restore only when the pasteboard was last written by our
                    // own action. Restoring over a newer write (e.g. the user
                    // pressing ⌘C inside the backup→restore window) would
                    // silently revert that copy, and restoring when nothing
                    // changed is pure changeCount churn.
                    let shouldRestore = lastObservedChangeCount != initialChangeCount
                        && pasteboard.changeCount == lastObservedChangeCount
                    if !shouldRestore {
                        logInfo(
                            "Skip restoring pasteboard: unchanged or changed by others")
                    }
                    return shouldRestore
                },
                task: executeAction)
        } else {
            await executeAction()
        }

        return newContent
    }

    // MARK: - Paste Methods

    /// Paste text by menu action first, if failed, fallback to keyboard shortcut paste.
    ///
    /// - Parameters:
    ///   - text: Text to copy and paste
    ///   - restorePasteboard: Whether to restore original pasteboard content
    ///   - restoreInterval: Delay after restoring pasteboard
    @MainActor
    @objc public func pasteText(
        _ text: String,
        restorePasteboard: Bool = true,
        restoreInterval: TimeInterval = 0.05
    ) async {
        let success = await performPasteOperation(
            text: text,
            type: .menuAction,
            restorePasteboard: restorePasteboard,
            restoreInterval: restoreInterval
        )

        if !success {
            logInfo("Falling back to keyboard shortcut paste")
            _ = await performPasteOperation(
                text: text,
                type: .keyboardShortcut,
                restorePasteboard: restorePasteboard,
                restoreInterval: restoreInterval
            )
        }
    }

    /// Common paste operation logic
    /// - Parameters:
    ///   - text: Text to copy and paste
    ///   - type: The paste type to use
    ///   - restorePasteboard: Whether to restore original pasteboard content
    ///   - restoreInterval: Delay after restoring pasteboard
    /// - Returns: Success status of the paste operation
    @MainActor
    @discardableResult
    private func performPasteOperation(
        text: String,
        type: PasteType,
        restorePasteboard: Bool,
        restoreInterval: TimeInterval
    ) async -> Bool {
        logInfo("Starting to paste text by \(type.rawValue)")

        let pasteboard = NSPasteboard.general
        var savedItems: [NSPasteboardItem]?
        if restorePasteboard {
            savedItems = pasteboard.backupItems()
        }

        let startTime = CFAbsoluteTimeGetCurrent()

        // Do not restore original content here, we need to paste the new content first
        let newContent = await fetchPasteboardText(restoreOriginal: false) {
            text.copyToPasteboard()
        }
        logInfo("Time taken to copy text to pasteboard: \(startTime.elapsedTimeString) seconds")

        var success = false
        if let newContent, !newContent.isEmpty {
            success = await performPasteAction(type: type, content: newContent)
        } else {
            logError("Failed to copy text to pasteboard")
        }

        if restorePasteboard, let savedItems {
            // Small delay to ensure paste operation is done
            await Task.sleep(seconds: restoreInterval)

            pasteboard.restoreItems(savedItems)
        }

        return success
    }

    /// Perform the actual paste action based on the type
    /// - Parameters:
    ///   - type: The paste type to use
    ///   - content: The content being pasted
    /// - Returns: Success status of the paste operation
    @MainActor
    private func performPasteAction(type: PasteType, content: String) async -> Bool {
        switch type {
        case .keyboardShortcut:
            KeySender.paste()
            logInfo("Pasted text via keyboard shortcut: \(content)")
            return true

        case .menuAction:
            do {
                let axManager = AXManager.shared
                let pasteItem = try axManager.findEnabledMenuItem(.paste)
                try pasteItem.performAction(kAXPressAction)
                logInfo("Pasted text via menu action: \(content)")
                return true
            } catch {
                logError("Failed to paste via menu action: \(error)")
                return false
            }
        }
    }

    /// Types of paste actions
    public enum PasteType: String, CaseIterable {
        case keyboardShortcut
        case menuAction
    }

    // MARK: - Polling Utility

    /// Poll task, if task is true, return true, else continue polling.
    @discardableResult
    public func pollTask(
        _ task: @escaping () async -> Bool,
        every interval: TimeInterval = 0.005,
        timeout: TimeInterval = 0.2
    ) async -> Bool {
        let startTime = Date()
        while Date().timeIntervalSince(startTime) < timeout {
            if await task() {
                let elapsedTime = Date().timeIntervalSince(startTime)
                logInfo("pollTask succeeded, time taken: \(String(format: "%.4f", elapsedTime)) seconds")
                return true
            }
            await Task.sleep(seconds: interval)
        }
        logInfo("pollTask timeout: \(timeout) seconds")
        return false
    }
    
    private func currentPollingTimeout() -> TimeInterval {
        let frontmostBundleID = NSWorkspace.shared.frontmostApplication?.bundleIdentifier
        // Use a longer timeout only for Safari.
        // In local testing, Safari's selected-text copy path can be noticeably delayed,
        // while normal apps typically resolve (success or failure) much faster.
        return frontmostBundleID == safariBundleID ? PollingTimeout.safari : PollingTimeout.default
    }

}

// MARK: - String + Pasteboard

extension String {
    func copyToPasteboard() {
        guard !self.isEmpty else {
            return
        }

        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(self, forType: .string)
    }
}

// MARK: - CFAbsoluteTime Extensions

extension CFAbsoluteTime {
    /// Returns a string representing the elapsed time since this CFAbsoluteTime value.
    var elapsedTimeString: String {
        let elapsedTime = CFAbsoluteTimeGetCurrent() - self
        return String(format: "%.4f", elapsedTime)
    }
}

// MARK: - Task Extensions

extension Task where Success == Never, Failure == Never {
    /// Sleep for given seconds within a Task
    static func sleep(seconds: TimeInterval) async {
        try? await Task.sleepThrowing(seconds: seconds)
    }

    /// Sleep for given seconds within a Task, throwing an error if cancelled
    static func sleepThrowing(seconds: TimeInterval) async throws {
        try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}

// MARK: - Measure Execution Time

func measureTime(block: () -> Void) {
    let startTime = DispatchTime.now()
    block()
    let endTime = DispatchTime.now()

    let nanoseconds = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
    let milliseconds = Double(nanoseconds) / 1_000_000

    print("Execution time: \(milliseconds) ms")
}
