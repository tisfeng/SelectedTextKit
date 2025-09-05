//
//  AXManager.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2024/10/3.
//  Copyright © 2024 izual. All rights reserved.
//

import AppKit
import AXSwift
import AXSwiftExtension

/// Manager class for accessibility-related operations
@objc(STKAXManager)
public final class AXManager: NSObject {

    @objc
    public static let shared = AXManager()

    /// Get selected text by AX
    ///
    /// - Returns: Selected text or throws AXError
    ///
    /// - Important: objc can get AXError value by NSError.code
    @objc
    public func getSelectedTextByAX() async throws -> String? {
        logInfo("Getting selected text via AX")

        // Get frontmost application element
        guard let frontmostAppElement = frontmostAppElement else {
            logError("Failed to get frontmost application element")
            throw AXError.invalidUIElement
        }

        // Get the currently focused element
        guard let focusedUIElement = try frontmostAppElement.focusedUIElement() else {
            logError("Failed to get focused UI element")
            throw AXError.invalidUIElement
        }

        // Get the selected text
        guard let selectedText = try focusedUIElement.selectedText() else {
            logError("No selected text available")
            throw AXError.noValue
        }

        logInfo("Selected text via AX: \(selectedText)")
        return selectedText
    }
}

