//
//  AppleScriptManager.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/7.
//

import AXSwiftExtension
import AppKit
import Foundation
import Subprocess

/// Run an AppleScript command asynchronously using swift-subprocess with timeout support.
/// - Parameters:
///   - script: The AppleScript source code to execute.
///   - timeout: Timeout in seconds. Default is 5.0.
/// - Returns: The output string if successful, or throws an error.
public func runAppleScript(_ script: String, timeout: TimeInterval = 5.0) async throws -> String? {
    do {
        return try await withTimeout(in: .seconds(timeout)) {
            let result = try await run(
                .name("osascript"),
                arguments: ["-e", script],
                output: .string(limit: .max),
                error: .standardOutput
            )
            
            let trimmedOutput = result.standardOutput?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if !result.terminationStatus.isSuccess {
                throw SelectedTextKitError.appleScriptExecution(
                    script: script,
                    exitCode: Int(result.terminationStatus.exitCode ?? -1),
                    output: trimmedOutput
                )
            }
            
            return trimmedOutput
        }
    } catch is TimeoutError {
        throw SelectedTextKitError.appleScriptTimeout(script: script, duration: timeout)
    } catch let error as SelectedTextKitError {
        throw error
    } catch {
        throw SelectedTextKitError.systemError(underlying: error)
    }
}

/// A general purpose timeout method that respects cancellation
public func withTimeout<T: Sendable>(
    in timeout: Duration,
    isolation: isolated (any Actor)? = #isolation,
    body: @escaping () async throws -> T
) async throws -> T {
    try await withThrowingTaskGroup(of: T.self) { group in
        group.addTask {
            try await body()
        }
        
        group.addTask {
            try await Task.sleep(for: timeout)
            throw TimeoutError()
        }
        
        guard let result = try await group.next() else {
            throw TimeoutError()
        }
        
        group.cancelAll()
        return result
    }
}

/// Internal timeout error for withTimeout function
internal struct TimeoutError: Error {
}

extension TerminationStatus {
    public var exitCode: Code? {
        if case .exited(let code) = self {
            return code
        }
        return nil
    }
}

/// Frontmost application bundle identifier
var frontmostAppBundleID: String {
    NSWorkspace.shared.frontmostApplication?.bundleIdentifier ?? ""
}

public final class AppleScriptManager {
    // MARK: Internal
    
    static let shared = AppleScriptManager()
    
    /// Browser action types for better abstraction
    enum BrowserAction {
        case getCurrentTabURL
        case getSelectedText
        case getTextFieldText
        case insertText(String)
        case selectAllText
    }
    
    func isBrowserSupportingAppleScript(_ bundleID: String) -> Bool {
        return SupportedBrowser.from(bundleID: bundleID) != nil
    }
    
    func isSafari(_ bundleID: String) -> Bool {
        return SupportedBrowser.from(bundleID: bundleID) == .safari
    }
    
    func isChromeKernelBrowser(_ bundleID: String) -> Bool {
        return SupportedBrowser.from(bundleID: bundleID)?.isChromeKernel ?? false
    }
    
    func getSelectedTextFromBrowser(_ bundleID: String) async throws -> String? {
        try await executeBrowserAction(.getSelectedText, bundleID: bundleID)
    }
    
    func getCurrentTabURLFromBrowser(_ bundleID: String) async throws -> String? {
        try await executeBrowserAction(.getCurrentTabURL, bundleID: bundleID)
    }
    
    func insertTextInBrowser(_ text: String, bundleID: String) async throws -> Bool {
        do {
            let result = try await executeBrowserAction(.insertText(text), bundleID: bundleID) ?? ""
            return result.boolValue
        } catch {
            logInfo("Failed to insert text in browser: \(error)")
            return false
        }
    }
    
    func selectAllInputTextInBrowser(_ bundleID: String) async throws -> Bool {
        do {
            let result = try await executeBrowserAction(.selectAllText, bundleID: bundleID) ?? ""
            return result.boolValue
        } catch {
            logInfo("Failed to select all text in browser: \(error)")
            return false
        }
        
    }
    
    // MARK: Private
    
    /// Generic browser action executor that handles Safari and Chrome differences
    private func executeBrowserAction(_ action: BrowserAction, bundleID: String) async throws
    -> String?
    {
        guard isBrowserSupportingAppleScript(bundleID) else {
            throw SelectedTextKitError.unsupportedBrowser(bundleID: bundleID)
        }
        
        let script: String
        let timeout: TimeInterval?
        let logMessage: String
        
        if isSafari(bundleID) {
            (script, timeout, logMessage) = safariScriptFor(action: action, bundleID: bundleID)
        } else if isChromeKernelBrowser(bundleID) {
            (script, timeout, logMessage) = chromeScriptFor(action: action, bundleID: bundleID)
        } else {
            throw SelectedTextKitError.unsupportedBrowser(bundleID: bundleID)
        }
        
        do {
            let result = try await runAppleScript(script, timeout: timeout ?? 5.0)
            logInfo("\(logMessage): \(result ?? "")")
            return result
        } catch let error as SelectedTextKitError {
            throw error
        } catch {
            throw SelectedTextKitError.systemError(underlying: error)
        }
    }
    
    // MARK: - Chrome AppleScript
    
    /// Generate Chrome-specific AppleScript for different actions
    private func chromeScriptFor(action: BrowserAction, bundleID: String) -> (
        script: String, timeout: TimeInterval?, logMessage: String
    ) {
        switch action {
        case .getCurrentTabURL:
            let script = """
                tell application id "\(bundleID)"
                   set theUrl to URL of active tab of front window
                end tell
                """
            return (script, nil, "Chrome current tab URL")
            
        case .getSelectedText:
            let script = """
                tell application id "\(bundleID)"
                   tell active tab of front window
                       set selection_text to execute javascript "window.getSelection().toString();"
                   end tell
                end tell
                """
            return (script, 0.2, "Chrome Browser selected text")
            
        case .getTextFieldText:
            let script = """
                tell application id "\(bundleID)"
                    tell active tab of front window
                        set inputText to execute javascript "
                            \(getTextFieldTextScript())
                        "
                    end tell
                end tell
                """
            return (script, 0.2, "Chrome Browser text field text")
            
        case .insertText(let text):
            let script = """
                tell application id "\(bundleID)"
                   tell active tab of front window
                        execute javascript "document.execCommand('insertText', false, '\(text)')"
                   end tell
                end tell
                """
            return (script, nil, "Chrome insert text result")
            
        case .selectAllText:
            let script = """
                tell application id "\(bundleID)"
                   tell active tab of front window
                       execute javascript "
                           \(getSelectAllInputTextScript())
                       "
                   end tell
                end tell
                """
            return (script, nil, "Chrome select all text result")
        }
    }
    
    // MARK: - Safari AppleScript
    
    /// Generate Safari-specific AppleScript for different actions
    private func safariScriptFor(action: BrowserAction, bundleID: String) -> (
        script: String, timeout: TimeInterval?, logMessage: String
    ) {
        switch action {
        case .getCurrentTabURL:
            let script = """
                tell application id "\(bundleID)"
                   set theUrl to URL of front document
                end tell
                """
            return (script, nil, "Safari current tab URL")
            
        case .getSelectedText:
            let script = """
                tell application id "\(bundleID)"
                    tell front window
                        set selection_text to do JavaScript "window.getSelection().toString();" in current tab
                    end tell
                end tell
                """
            return (script, 0.2, "Safari selected text")
            
        case .getTextFieldText:
            let script = """
                tell application id "\(bundleID)"
                    do JavaScript "
                        \(getTextFieldTextScript())
                    " in document 1
                end tell
                """
            return (script, 0.2, "Safari text field text")
            
        case .insertText(let text):
            let script = """
                tell application id "\(bundleID)"
                    do JavaScript "document.execCommand('insertText', false, '\(text)')" in document 1
                end tell
                """
            return (script, nil, "Safari insert text result")
            
        case .selectAllText:
            let script = """
                tell application id "\(bundleID)"
                    do JavaScript "
                        \(getSelectAllInputTextScript())
                    " in document 1
                end tell
                """
            return (script, nil, "Safari select all text result")
        }
    }
    
    private func getTextFieldTextScript() -> String {
        """
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
    }
    
    /// Modern implementation for selecting all text in the focused element
    private func getSelectAllInputTextScript() -> String {
        """
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
    }
}

// MARK: - Browser Types

/// Supported browser types with their bundle identifiers
public enum SupportedBrowser: String, CaseIterable {
    case safari = "com.apple.Safari"
    case chrome = "com.google.Chrome"
    case edge = "com.microsoft.edgemac"
    
    /// Whether this browser uses Chrome kernel
    var isChromeKernel: Bool {
        switch self {
        case .safari:
            return false
        case .chrome, .edge:
            return true
        }
    }
    
    /// Create browser from bundle identifier
    static func from(bundleID: String) -> SupportedBrowser? {
        return SupportedBrowser(rawValue: bundleID)
    }
}

extension String {
    var boolValue: Bool {
        (self as NSString).boolValue
    }
}
