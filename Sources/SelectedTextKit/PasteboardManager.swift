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

    /// Shared singleton instance
    @objc
    public static let shared = PasteboardManager()

    /// Get selected text with a given action
    /// - Parameter action: Action to execute that should trigger a pasteboard change
    /// - Returns: Selected text or nil if failed
    @MainActor
    public func getSelectedTextWithAction(
        action: @escaping () throws -> Void
    ) async -> String? {
        await getNextPasteboardContent(triggeredBy: action)
    }

    /// Get the next pasteboard content after executing an action
    /// - Parameters:
    ///   - action: The action that triggers the pasteboard change
    ///   - preservePasteboard: Whether to preserve the original pasteboard content
    /// - Returns: The new pasteboard content if changed, nil if failed or timeout
    @MainActor
    public func getNextPasteboardContent(
        triggeredBy action: @escaping () throws -> Void,
        preservePasteboard: Bool = true
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

        if preservePasteboard {
            await pasteboard.performTemporaryTask(executeAction)
        } else {
            await executeAction()
        }

        return newContent
    }

    /// Copy text and paste it
    /// - Parameters:
    ///   - text: Text to copy and paste
    ///   - preservePasteboard: Whether to preserve original pasteboard content
    @objc public func copyTextAndPaste(_ text: String, preservePasteboard: Bool = true) async {
        logInfo("Copy text and paste text safely")

        let newContent = await getNextPasteboardContent(
            triggeredBy: {
                text.copyToPasteboard()
            }, preservePasteboard: preservePasteboard)

        if let text = newContent {
            KeySender.copy()
            logInfo("Pasted text: \(text)")
        } else {
            logError("Failed to paste text")
        }
    }
}

// MARK: - String + Pasteboard

extension String {
    func copyToPasteboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(self, forType: .string)
    }
}
