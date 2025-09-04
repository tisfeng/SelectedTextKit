//
//  PasteboardManager.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2024/10/3.
//  Copyright © 2024 izual. All rights reserved.
//

import AppKit
import Foundation
import KeySender

/// Manager class for pasteboard-related operations
@objc(STKPasteboardManager)
public final class PasteboardManager: NSObject {

    @objc
    public static let shared = PasteboardManager()

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

        let executeAction = { @MainActor in
            do {
                logInfo("Executing trigger action")
                try action()
            } catch {
                logError("Failed to execute trigger action: \(error)")
                return
            }

            await pollTask { @MainActor in
                // Check if the pasteboard content has changed
                if pasteboard.changeCount != initialChangeCount {
                    // !!!: The pasteboard content may be nil or other strange content(such as old content) if the pasteboard is changing by other applications in the same time, like PopClip.
                    newContent = pasteboard.string
                    if let newContent {
                        logInfo("New Pasteboard content: \(newContent)")
                        return true
                    }

                    logError("Pasteboard changed but no valid text content found")
                    return false
                }
                return false
            }
        }

        if restoreOriginal {
            await pasteboard.performTemporaryTask(restoreInterval: restoreInterval, task: executeAction)
        } else {
            await executeAction()
        }

        return newContent
    }

    /// Paste given text by copying it to pasteboard and simulating paste action
    ///
    /// - Parameters:
    ///   - text: Text to copy and paste
    ///   - restorePasteboard: Whether to restore original pasteboard content
    ///   - restoreInterval: Delay after restoring pasteboard
    @objc public func pasteText(
        _ text: String,
        restorePasteboard: Bool = true,
        restoreInterval: TimeInterval = 0.05) async {
        logInfo("Starting to paste text by copying to pasteboard")

        let pasteboard = NSPasteboard.general
        var savedItems: [NSPasteboardItem]?
        if restorePasteboard {
            savedItems = await pasteboard.backupItems()
        }

        let startTime = CFAbsoluteTimeGetCurrent()

        // Do not restore original content here, we need to paste the new content first
        let newContent = await fetchPasteboardText(restoreOriginal: false) {
            text.copyToPasteboard()
        }
        logInfo("Time taken to copy text to pasteboard: \(startTime.elapsedTimeString) seconds")

        if let newContent, !newContent.isEmpty {
            KeySender.paste()
            logInfo("Pasted text: \(newContent)")
        } else {
            logError("Failed to paste text")
        }
        
        if restorePasteboard, let savedItems {
            // Small delay to ensure paste operation is done
            await Task.sleep(seconds: restoreInterval)
            
            await pasteboard.restoreItems(savedItems)
        }
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

extension CFAbsoluteTime {
    /// Returns a string representing the elapsed time since this CFAbsoluteTime value.
    var elapsedTimeString: String {
        let elapsedTime = CFAbsoluteTimeGetCurrent() - self
        return String(format: "%.4f", elapsedTime)
    }
}
