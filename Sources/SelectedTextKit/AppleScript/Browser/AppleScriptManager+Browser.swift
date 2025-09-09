//
//  AppleScriptManager+Browser.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/8.
//

import Foundation

// MARK: - Browser Support Methods

extension AppleScriptManager {

    /// Check if a browser supports AppleScript automation
    public func isBrowserSupportingAppleScript(_ bundleID: String) -> Bool {
        return SupportedBrowser.isSupported(bundleID)
    }

    /// Check if a browser is Safari
    public func isSafari(_ bundleID: String) -> Bool {
        guard let browser: SupportedBrowser = SupportedBrowser(rawValue: bundleID) else {
            return false
        }
        return browser == .safari
    }

    /// Check if a browser uses Chrome kernel
    public func isChromeKernelBrowser(_ bundleID: String) -> Bool {
        guard let browser: SupportedBrowser = SupportedBrowser(rawValue: bundleID) else {
            return false
        }
        return browser.kernel == .chrome
    }
}

// MARK: - Browser Action Execution

extension AppleScriptManager {
    /// Execute a action for a specific browser
    public func executeBrowserAction(_ action: BrowserAction, browser: SupportedBrowser) async throws
        -> String?
    {
        let scriptInfo = try action.generateScriptInfo(for: browser)
        return try await runAppleScript(scriptInfo)
    }
    
    /// Execute a action for a specific browser by bundle identifier
    public func executeBrowserAction(_ action: BrowserAction, bundleID: String) async throws
        -> String?
    {
        guard isBrowserSupportingAppleScript(bundleID) else {
            throw SelectedTextKitError.unsupportedBrowser(bundleID: bundleID)
        }

        let scriptInfo = try action.generateScriptInfo(for: bundleID)
        return try await runAppleScript(scriptInfo)
    }
}

// MARK: - Convenience Methods

extension AppleScriptManager {

    /// Get selected text from a browser
    public func getSelectedTextFromBrowser(_ bundleID: String) async throws -> String? {
        try await executeBrowserAction(.getSelectedText, bundleID: bundleID)
    }

    /// Get current tab URL from a browser
    public func getCurrentTabURLFromBrowser(_ bundleID: String) async throws -> String? {
        try await executeBrowserAction(.getCurrentTabURL, bundleID: bundleID)
    }

    /// Insert text in browser
    public func insertTextInBrowser(_ text: String, bundleID: String) async throws -> Bool {
        do {
            let result = try await executeBrowserAction(.insertText(text), bundleID: bundleID) ?? ""
            return result.boolValue
        } catch {
            logInfo("Failed to insert text in browser: \(error)")
            return false
        }
    }

    /// Select all text in the currently focused input field
    public func selectAllInputTextInBrowser(_ bundleID: String) async throws -> Bool {
        do {
            let result = try await executeBrowserAction(.selectAllInputText, bundleID: bundleID) ?? ""
            return result.boolValue
        } catch {
            logInfo("Failed to select all text in browser: \(error)")
            return false
        }
    }
}

// MARK: - String Extensions

extension String {
    var boolValue: Bool {
        (self as NSString).boolValue
    }
}
