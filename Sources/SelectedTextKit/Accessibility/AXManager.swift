//
//  AXManager.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2024/10/3.
//  Copyright © 2024 izual. All rights reserved.
//

import AXSwift
import AppKit

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

        // Get the currently focused element
        guard let appElement = frontmostAppElement,
              let focusedUIElement = try appElement.focusedUIElement() else {
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

extension AXManager {
    /// Get the frame of the selected text in the frontmost application
    ///
    /// - Returns: NSValue containing NSRect of selected text frame, or .zero rect if not available
    @objc
    public func getSelectedTextFrame() throws -> NSValue {
        if let focusedUIElement = try systemWideElement.focusedUIElement(),
           let selectedRange = try focusedUIElement.selectedTextRange(),
           let bounds: NSRect = try focusedUIElement.parameterizedAttribute(
               .boundsForRangeParameterized,
               param: selectedRange
           ) {
            return NSValue(rect: bounds)
        }
        return NSValue(rect: .zero)
    }
}
