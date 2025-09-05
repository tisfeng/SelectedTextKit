//
//  AXManager+Menu.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/5.
//

import AXSwift
import AXSwiftExtension
import AppKit
import Foundation

extension AXManager {
    /// Find the copy item in the frontmost application
    ///
    /// - Returns: UIElement for copy menu item or throws AXError if not found
    public func findCopyMenuItem() throws -> UIElement {
        return try findMenuItem(.copy)
    }

    /// Find the paste item in the frontmost application
    ///
    /// - Returns: UIElement for paste menu item or throws AXError if not found
    public func findPasteMenuItem() throws -> UIElement {
        return try findMenuItem(.paste)
    }

    /// Find a specific menu item in the frontmost application
    ///
    /// - Parameters:
    ///   - menuItem: The type of menu item to find
    ///   - requireEnabled: If true, only return enabled menu items
    /// - Returns: UIElement for the menu item or throws AXError if not found or disabled (when requireEnabled is true)
    public func findMenuItem(_ menuItem: SystemMenuItem, requireEnabled: Bool = false) throws
        -> UIElement
    {
        guard checkIsProcessTrusted(prompt: true) else {
            logError("Process is not trusted for accessibility")
            throw AXError.apiDisabled
        }

        guard let appElement = frontmostAppElement else {
            throw AXError.invalidUIElement
        }

        logInfo("Checking \(menuItem) item in frontmost app: \(frontmostAppBundleID)")

        guard let foundMenuItem = try appElement.findMenuItem(menuItem) else {
            throw AXError.noMenuItem
        }

        if requireEnabled {
            guard try foundMenuItem.isEnabled() == true else {
                logError("\(menuItem) item not enabled")
                throw AXError.disabledMenuItem
            }
            logInfo("Found enabled \(menuItem) item in frontmost application menu")
        }

        return foundMenuItem
    }
    /// Find the enabled copy item in the frontmost application
    /// - Returns: UIElement for enabled copy menu item or throws AXError if not found or disabled
    public func findEnabledCopyItem() throws -> UIElement {
        return try findMenuItem(.copy, requireEnabled: true)
    }

    /// Find the enabled paste item in the frontmost application
    /// - Returns: UIElement for enabled paste menu item or throws AXError if not found or disabled
    public func findEnabledPasteItem() throws -> UIElement {
        return try findMenuItem(.paste, requireEnabled: true)
    }

    /// Find the enabled menu item in the frontmost application
    /// - Parameter menuItem: The type of menu item to find
    /// - Returns: UIElement for enabled menu item or throws AXError if not found or disabled
    public func findEnabledMenuItem(_ menuItem: SystemMenuItem) throws -> UIElement {
        return try findMenuItem(menuItem, requireEnabled: true)
    }

    @objc
    public func hasCopyMenuItem() -> Bool {
        (try? findCopyMenuItem()) != nil
    }

    @objc
    public func hasPasteMenuItem() -> Bool {
        (try? findPasteMenuItem()) != nil
    }

    // MARK: - Frontmost Application

    /// Frontmost application as `UIElement`
    var frontmostAppElement: UIElement? {
        guard let frontmostApp else {
            return nil
        }
        return Application(frontmostApp)
    }

    /// Frontmost application as `NSRunningApplication`
    var frontmostApp: NSRunningApplication? {
        let frontmostApp = NSWorkspace.shared.frontmostApplication
        guard let frontmostApp else {
            return nil
        }
        return frontmostApp
    }

    /// Bundle identifier of frontmost application
    var frontmostAppBundleID: String {
        frontmostApp?.bundleIdentifier ?? ""
    }
}
