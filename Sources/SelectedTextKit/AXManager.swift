//
//  AXManager.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2024/10/3.
//  Copyright © 2024 izual. All rights reserved.
//

import AXSwift
import AppKit
import Foundation

/// Manager class for accessibility-related operations
@objc(STKAXManager)
public final class AXManager: NSObject {

    @objc
    public static let shared = AXManager()

    /// Get selected text by AX
    /// - Returns: Selected text or throws AXError
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
        guard  let selectedText = try focusedUIElement.selectedText() else {
            logError("No selected text available")
            throw AXError.noValue
        }

        logInfo("Selected text via AX: \(selectedText)")
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
    
    @objc
    public func hasCopyMenuItem() -> Bool {
        findCopyMenuItem() != nil
    }
    
    // MARK: - Private Properties
    
    /// A `UIElement` for frontmost application.
    private var frontmostAppElement: UIElement? {
        let frontmostApp = NSWorkspace.shared.frontmostApplication
        guard let frontmostApp else {
            return nil
        }
        return Application(frontmostApp)
    }
}

// MARK: - AXError to conform to NSError for better interoperability

extension AXError: @retroactive CustomNSError {
    public var errorCode: Int {
        return Int(self.rawValue)
    }
}
