//
//  AccessibilityManager.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2024/10/3.
//  Copyright © 2024 izual. All rights reserved.
//

import AXSwift
import AppKit
import Foundation

/// Manager class for accessibility-related operations
@objc(STKAccessibilityManager)
public final class AccessibilityManager: NSObject {

    /// Get selected text by AXUI
    /// - Returns: Selected text or throws AXError
    public func getSelectedTextByAXUI() async throws -> String? {
        logInfo("Getting selected text via AXUI")

        let systemWideElement = AXUIElementCreateSystemWide()
        var focusedElementRef: CFTypeRef?

        // Get the currently focused element
        let focusedElementResult = AXUIElementCopyAttributeValue(
            systemWideElement,
            kAXFocusedUIElementAttribute as CFString,
            &focusedElementRef
        )

        guard focusedElementResult == .success,
            let focusedElement = focusedElementRef as! AXUIElement?
        else {
            logError("Failed to get focused element, error: \(focusedElementResult)")
            throw focusedElementResult
        }

        var selectedTextValue: CFTypeRef?

        // Get the selected text
        let selectedTextResult = AXUIElementCopyAttributeValue(
            focusedElement,
            kAXSelectedTextAttribute as CFString,
            &selectedTextValue
        )

        guard selectedTextResult == .success else {
            logError("Failed to get selected text, error: \(selectedTextResult)")
            throw selectedTextResult
        }

        guard let selectedText = selectedTextValue as? String else {
            logError("Selected text is not a string, error: \(selectedTextResult)")
            throw AXError.noValue
        }

        logInfo("Selected text via AXUI: \(selectedText)")
        return selectedText
    }

    /// Find the copy item in the frontmost application
    /// - Returns: UIElement for copy menu item or nil if not found
    public func findCopyMenuItem() -> UIElement? {
        guard checkIsProcessTrusted(prompt: true) else {
            logError("Process is not trusted for accessibility")
            return nil
        }

        let frontmostApp = NSWorkspace.shared.frontmostApplication
        guard let frontmostApp, let appElement = Application(frontmostApp) else {
            logError("Failed to get frontmost application: \(String(describing: frontmostApp))")
            return nil
        }

        logInfo("Checking copy item in frontmost application: \(frontmostApp)")

        return appElement.findCopyMenuItem()
    }

    /// Find the enabled copy item in the frontmost application
    /// - Returns: UIElement for enabled copy menu item or nil if not found
    public func findEnabledCopyItem() -> UIElement? {
        guard let copyItem = findCopyMenuItem(), copyItem.isEnabled == true else {
            logError("Copy item not found or not enabled")
            return nil
        }

        logInfo("Found enabled copy item in frontmost application menu")

        return copyItem
    }
}
