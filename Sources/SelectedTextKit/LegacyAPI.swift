//
//  LegacyAPI.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2024/10/3.
//  Copyright © 2024 izual. All rights reserved.
//

import AXSwift
import Cocoa
import Foundation

// MARK: - Legacy Global Functions for Backward Compatibility
// These functions are provided for backward compatibility with existing code.
// New code should use the manager classes directly.

/// Get selected text using multiple fallback methods
/// - Returns: Selected text or nil if failed
@available(macOS, deprecated, message: "Use SelectedTextManager.shared.getSelectedText() instead.")
public func getSelectedText() async throws -> String? {
    return try await SelectedTextManager.shared.getSelectedText()
}

/// Get selected text by AXUI
/// - Returns: Selected text or nil if failed, throws on error
@available(
    macOS, deprecated, message: "Use SelectedTextManager.shared.getSelectedTextByAXUI() instead."
)
public func getSelectedTextByAXUI() async throws -> String? {
    return try await SelectedTextManager.shared.getSelectedTextByAX()
}

/// Get selected text by menu bar action copy
/// - Returns: Selected text or nil if failed
@available(
    macOS, deprecated,
    message: "Use SelectedTextManager.shared.getSelectedTextByMenuBarActionCopy() instead."
)
@MainActor
public func getSelectedTextByMenuBarActionCopy() async throws -> String? {
    return try await SelectedTextManager.shared.getSelectedTextByMenuAction()
}

/// Get selected text by shortcut copy (Cmd+C)
/// - Returns: Selected text or nil if failed
@available(
    macOS, deprecated,
    message: "Use SelectedTextManager.shared.getSelectedTextByShortcutCopy() instead."
)
public func getSelectedTextByShortcutCopy() async -> String? {
    return await SelectedTextManager.shared.getSelectedTextByShortcut()
}

// MARK: - Legacy Global Functions (moved to AccessibilityManager)

/// Find the copy item in the frontmost application.
@available(macOS, deprecated, message: "Use AccessibilityManager().findCopyMenuItem() instead.")
public func findCopyMenuItem() -> UIElement? {
    return AXManager().findCopyMenuItem()
}

/// Find the enabled copy item in the frontmost application.
@available(macOS, deprecated, message: "Use AccessibilityManager().findEnabledCopyItem() instead.")
public func findEnabledCopyItem() -> UIElement? {
    return AXManager().findEnabledCopyItem()
}

// MARK: - Public API for Objective-C compatibility

/// Copy text and paste it (Legacy function for backward compatibility)
/// - Parameters:
///   - text: Text to copy and paste
///   - preservePasteboard: Whether to preserve original pasteboard content
@available(
    macOS, deprecated,
    message: "Use SelectedTextManager.shared.copyTextAndPaste(_:preservePasteboard:) instead."
)
public func copyTextAndPaste(_ text: String, preservePasteboard: Bool = true) async {
    await SelectedTextManager.shared.copyTextAndPaste(text, preservePasteboard: preservePasteboard)
}
