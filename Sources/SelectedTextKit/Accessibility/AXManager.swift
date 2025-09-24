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

    /// Retrieves the currently selected text using Accessibility (AX).
    ///
    /// - Returns: The selected text as a `String`, or `nil` if no text is selected.
    /// - Throws: An `AXError` if the focused element is invalid or the selected text cannot be retrieved.
    ///
    /// - Note: In Objective-C, the `AXError` can be accessed via `NSError.code`.
    @objc
    public func getSelectedTextByAX() async throws -> String {
        logInfo("Getting selected text via AX")

        // For AXSwift:
        // If the error is `.noValue` or `.attributeUnsupported`, `nil` is returned instead of throwing.
        // So we need to explicitly throw error if focused element is nil.
        guard let focusedUIElement = try systemWideElement.focusedUIElement(),
              let selectedText = try focusedUIElement.selectedText() else {
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
