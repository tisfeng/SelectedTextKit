//
//  SupportedBrowser.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/8.
//

import Foundation

/// Browser kernel types for JavaScript execution
public enum BrowserKernel {
    case safari
    case chrome
}

/// Supported browser types with their bundle identifiers
public enum SupportedBrowser: String, CaseIterable {
    case safari = "com.apple.Safari"
    case chrome = "com.google.Chrome"
    case edge = "com.microsoft.edgemac"

    /// Display name for the browser
    public var displayName: String {
        switch self {
        case .safari:
            return "Safari"
        case .chrome:
            return "Chrome"
        case .edge:
            return "Microsoft Edge"
        }
    }

    /// JavaScript execution style for this browser
    public var kernel: BrowserKernel {
        switch self {
        case .safari:
            return .safari
        case .chrome, .edge:
            return .chrome
        }
    }

    /// Create browser from bundle identifier
    public static func from(bundleID: String) -> SupportedBrowser? {
        return SupportedBrowser(rawValue: bundleID)
    }

    /// Check if a bundle ID is supported
    public static func isSupported(_ bundleID: String) -> Bool {
        return from(bundleID: bundleID) != nil
    }

    /// Generate AppleScript for JavaScript execution
    /// - Parameter javascript: JavaScript code to execute
    /// - Returns: Complete AppleScript for this browser
    public func generateAppleScript(for javascript: String) -> String {
        let bundleID = self.rawValue

        switch kernel {
        case .safari:
            return """
                tell application id "\(bundleID)"
                    do JavaScript "\(javascript)" in document 1
                end tell
                """
        case .chrome:
            return """
                tell application id "\(bundleID)"
                    tell active tab of front window
                        execute javascript "\(javascript)"
                    end tell
                end tell
                """
        }
    }
}
