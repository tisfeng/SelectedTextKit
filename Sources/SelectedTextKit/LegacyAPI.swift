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
/// - Note: This is a legacy function for backward compatibility. Use `SelectedTextManager.shared.getSelectedText()` instead.
public func getSelectedText() async throws -> String? {
    return try await SelectedTextManager.shared.getSelectedText()
}

/// Get selected text by AXUI
/// - Returns: Selected text or nil if failed, throws on error
/// - Note: This is a legacy function for backward compatibility. Use `SelectedTextManager.shared.getSelectedTextByAXUI()` instead.
public func getSelectedTextByAXUI() async throws -> String? {
    return try await SelectedTextManager.shared.getSelectedTextByAXUI()
}

/// Get selected text by menu bar action copy
/// - Returns: Selected text or nil if failed
/// - Note: This is a legacy function for backward compatibility. Use `SelectedTextManager.shared.getSelectedTextByMenuBarActionCopy()` instead.
@MainActor
public func getSelectedTextByMenuBarActionCopy() async throws -> String? {
    return try await SelectedTextManager.shared.getSelectedTextByMenuBarActionCopy()
}

/// Get selected text by shortcut copy (Cmd+C)
/// - Returns: Selected text or nil if failed
/// - Note: This is a legacy function for backward compatibility. Use `SelectedTextManager.shared.getSelectedTextByShortcutCopy()` instead.
public func getSelectedTextByShortcutCopy() async -> String? {
    return await SelectedTextManager.shared.getSelectedTextByShortcutCopy()
}
