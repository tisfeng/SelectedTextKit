//
//  BrowserAction.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/8.
//

import Foundation

// MARK: - Browser Action Types

/// Browser action types for AppleScript automation
public enum BrowserAction {
    case getCurrentTabURL
    case getSelectedText
    case getTextFieldText
    case insertText(String)
    case selectAllInputText
    case custom(script: String, timeout: TimeInterval? = 5.0, description: String = "Custom script")

    // MARK: - Action Properties

    /// JavaScript code for this action
    public var javascript: String {
        switch self {
        case .getCurrentTabURL:
            return "window.location.href"

        case .getSelectedText:
            return "window.getSelection().toString();"

        case .getTextFieldText:
            return """
                (function() {
                    var el = document.activeElement;
                    if (!el) return '';
                    if (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA') {
                        return el.value;
                    }
                    if (el.isContentEditable) {
                        return el.innerText || el.textContent || '';
                    }
                    return '';
                })();
                """

        case .insertText(let text):
            return "document.execCommand('insertText', false, '\(text)')"

        case .selectAllInputText:
            return """
                (function() {
                    const activeElement = document.activeElement;

                    if (!activeElement) {
                        console.log('No active element found');
                        return false;
                    }

                    // For input and textarea elements
                    if (activeElement.tagName === 'INPUT' || activeElement.tagName === 'TEXTAREA') {
                        activeElement.select();
                        return true;
                    }

                    // For contentEditable elements
                    if (activeElement.isContentEditable) {
                        const range = document.createRange();
                        range.selectNodeContents(activeElement);

                        const selection = window.getSelection();
                        selection.removeAllRanges();
                        selection.addRange(range);

                        return true;
                    }

                    console.log('Active element is neither input, textarea, nor contentEditable');
                    return false;
                })();
                """

        case .custom(let script, _, _):
            return script
        }
    }

    /// Default timeout for this action
    public var defaultTimeout: TimeInterval {
        switch self {
        case .getCurrentTabURL, .getSelectedText, .getTextFieldText, .insertText, .selectAllInputText:
            return 0.5
        case .custom(_, let timeout, _):
            return timeout ?? 5.0
        }
    }

    /// Action name for script generation
    public var actionName: String {
        switch self {
        case .getCurrentTabURL:
            return "Get Current Tab URL"
        case .getSelectedText:
            return "Get Selected Text"
        case .getTextFieldText:
            return "Get Text Field Text"
        case .insertText:
            return "Insert Text"
        case .selectAllInputText:
            return "Select All Text"
        case .custom(_, _, let description):
            return description.isEmpty ? "Custom Script" : description
        }
    }

    /// Action description
    public func description(for browserName: String) -> String {
        switch self {
        case .getCurrentTabURL:
            return "Retrieves the URL of the currently active tab in \(browserName)"
        case .getSelectedText:
            return "Gets the currently selected text from \(browserName) using JavaScript"
        case .getTextFieldText:
            return "Retrieves text from the currently focused input field in \(browserName)"
        case .insertText:
            return "Inserts text at the current cursor position in \(browserName)"
        case .selectAllInputText:
            return "Selects all text in the currently focused input element in \(browserName)"
        case .custom(_, _, let description):
            return description.isEmpty
                ? "Executes custom JavaScript in \(browserName)" : description
        }
    }

    // MARK: - Script Generation

    /// Generate complete script information for this action and browser
    /// - Parameter bundleID: Target browser bundle identifier
    /// - Returns: Complete script information
    /// - Throws: SelectedTextKitError if browser is not supported
    public func generateScriptInfo(for bundleID: String) throws -> ScriptInfo {
        guard let browser = SupportedBrowser.from(bundleID: bundleID) else {
            throw SelectedTextKitError.unsupportedBrowser(bundleID: bundleID)
        }

        return generateScriptInfo(for: browser)
    }

    /// Generate complete script information for this action and browser
    /// - Parameter browser: The supported browser
    /// - Returns: Complete script information
    public func generateScriptInfo(for browser: SupportedBrowser) -> ScriptInfo {
        let browserName = browser.displayName
        let script = browser.generateAppleScript(for: self.javascript)

        return ScriptInfo(
            name: "\(browserName) \(self.actionName)",
            script: script,
            timeout: self.defaultTimeout,
            description: self.description(for: browserName)
        )
    }
}
