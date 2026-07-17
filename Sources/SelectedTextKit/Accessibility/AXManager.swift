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

        guard let focusedApplication = try systemWideElement.focusedApplication() else {
            throw AXError.noValue
        }
        let processID = try focusedApplication.pid()

        let selectedText: String
        if processID == ProcessInfo.processInfo.processIdentifier {
            selectedText = try await MainActor.run {
                try Self.selectedText(inProcess: processID)
            }
        } else {
            selectedText = try await Task.detached(priority: .userInitiated) {
                try Self.selectedText(inProcess: processID)
            }.value
        }

        logInfo("Selected text via AX: \(selectedText)")
        return selectedText
    }

    /// Reads selected text from a fixed target process on the current executor.
    private static func selectedText(inProcess processID: pid_t) throws -> String {
        let application = UIElement(AXUIElementCreateApplication(processID))

        // AXSwift returns nil for missing or unsupported attributes, so convert
        // those results to the error expected by existing callers.
        guard let focusedUIElement = try application.focusedUIElement(),
              let selectedText = try focusedUIElement.selectedText() else {
            throw AXError.noValue
        }

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
