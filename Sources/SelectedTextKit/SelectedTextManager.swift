//
//  SelectedTextManager.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2024/10/3.
//  Copyright © 2024 izual. All rights reserved.
//

import AXSwift
import AXSwiftExt
import Cocoa

/// Main manager class for getting selected text from applications
@objc(STKSelectedTextManager)
public final class SelectedTextManager: NSObject {

    /// Shared singleton instance
    @objc
    public static let shared = SelectedTextManager()

    private let accessibilityManager = AccessibilityManager()
    private let pasteboardManager = PasteboardManager()

    private override init() {}

    /// Get selected text using multiple fallback methods
    /// 1. Try AXUI method first
    /// 2. If failed, try menu action copy
    /// - Returns: Selected text or nil if failed
    @objc
    public func getSelectedText() async throws -> String? {
        logInfo("Attempting to get selected text")

        // Try AXUI method first
        do {
            if let text = try await accessibilityManager.getSelectedTextByAXUI() {
                if !text.isEmpty {
                    logInfo("Successfully got non-empty text via AXUI")
                    return text
                } else {
                    logInfo("AXUI returned empty text, trying menu action copy")
                    // Fall through to try menu action copy
                }
            }
        } catch {
            logError("Failed to get text via AXUI: \(error)")
        }

        // If AXUI fails or returns empty text, try menu action copy
        if let menuCopyText = try await getSelectedTextByMenuBarActionCopy() {
            if !menuCopyText.isEmpty {
                logInfo("Successfully got non-empty text via menu action copy")
                return menuCopyText
            } else {
                logInfo("Menu action copy returned empty text")
            }
        }

        logError("All methods to get selected text have failed or returned empty text")
        return nil
    }

    /// Get selected text by AXUI
    /// - Returns: Selected text or nil if failed, throws on error
    @objc
    public func getSelectedTextByAXUI() async throws -> String? {
        return try await accessibilityManager.getSelectedTextByAXUI()
    }

    /// Get selected text by menu bar action copy
    /// - Returns: Selected text or nil if failed
    @MainActor
    @objc
    public func getSelectedTextByMenuBarActionCopy() async throws -> String? {
        logInfo("Getting selected text by menu bar action copy")

        guard let copyItem = accessibilityManager.findEnabledCopyItem() else {
            return nil
        }

        return await pasteboardManager.getSelectedTextWithAction {
            try copyItem.performAction(kAXPressAction)
        }
    }

    /// Get selected text by shortcut copy (Cmd+C)
    /// - Returns: Selected text or nil if failed
    @objc
    public func getSelectedTextByShortcutCopy() async -> String? {
        logInfo("Getting selected text by shortcut copy")

        guard checkIsProcessTrusted(prompt: true) else {
            logError("Process is not trusted for accessibility")
            return nil
        }

        return await pasteboardManager.getSelectedTextWithAction {
            postCopyEvent()
        }
    }

    /// Copy text and paste it
    /// - Parameters:
    ///   - text: Text to copy and paste
    ///   - preservePasteboard: Whether to preserve original pasteboard content
    @objc
    public func copyTextAndPaste(_ text: String, preservePasteboard: Bool = true) async {
        await pasteboardManager.copyTextAndPaste(text, preservePasteboard: preservePasteboard)
    }
}
