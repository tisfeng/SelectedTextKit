//
//  SelectedTextKitError+Extension.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/8.
//

import Foundation

// MARK: - Convenience Error Creation

public extension SelectedTextKitError {
    
    /// Create a timeout error for general operations
    static func operationTimeout(_ operation: String, duration: TimeInterval) -> Self {
        .timeout(operation: operation, duration: duration)
    }
    
    /// Create an accessibility permission error
    static var accessibilityPermissionRequired: Self {
        .accessibilityPermissionDenied
    }
    
    /// Create an element not found error with description
    static func elementNotFound(_ description: String = "UI element") -> Self {
        .elementNotFound(description: description)
    }
    
    /// Create an invalid input error
    static func invalidParameter(_ parameter: String, reason: String) -> Self {
        .invalidInput(parameter: parameter, reason: reason)
    }
    
    /// Create a browser not found error
    static var noBrowserFound: Self {
        .browserNotFound
    }
    
    /// Create an unsupported browser error
    static func browserNotSupported(_ bundleID: String) -> Self {
        .unsupportedBrowser(bundleID: bundleID)
    }
    
    /// Wrap a system error
    static func system(_ error: Error) -> Self {
        .systemError(underlying: error)
    }
    
    /// Create an unknown error with description
    static func unknown(_ description: String) -> Self {
        .unknownError(description: description)
    }
}

// MARK: - Error Checking

public extension SelectedTextKitError {
    
    /// Check if this is a timeout-related error
    var isTimeout: Bool {
        switch self {
        case .timeout, .appleScriptTimeout:
            return true
        default:
            return false
        }
    }
    
    /// Check if this is an AppleScript-related error
    var isAppleScriptError: Bool {
        switch self {
        case .appleScriptExecution, .appleScriptTimeout:
            return true
        default:
            return false
        }
    }
    
    /// Check if this is a browser-related error
    var isBrowserError: Bool {
        switch self {
        case .unsupportedBrowser, .browserNotFound:
            return true
        default:
            return false
        }
    }
    
    /// Check if this is an accessibility-related error
    var isAccessibilityError: Bool {
        switch self {
        case .accessibilityPermissionDenied, .elementNotFound:
            return true
        default:
            return false
        }
    }
    
    /// Check if this error is recoverable (user can take action to fix it)
    var isRecoverable: Bool {
        switch self {
        case .timeout, .accessibilityPermissionDenied, .browserNotFound, .unsupportedBrowser, .invalidInput:
            return true
        case .appleScriptExecution, .appleScriptTimeout, .elementNotFound, .systemError, .unknownError:
            return false
        }
    }
}

// MARK: - Error Bridging

public extension SelectedTextKitError {
    
    /// Convert to NSError for Objective-C compatibility
    var asNSError: NSError {
        NSError(
            domain: Self.errorDomain,
            code: errorCode,
            userInfo: errorUserInfo
        )
    }
    
    /// Create from NSError if it's a SelectedTextKit error
    static func from(_ nsError: NSError) -> SelectedTextKitError? {
        guard nsError.domain == errorDomain else { return nil }
        
        switch nsError.code {
        case 1001:
            let operation = nsError.userInfo["operation"] as? String ?? "Unknown operation"
            let duration = nsError.userInfo["duration"] as? TimeInterval ?? 0
            return .timeout(operation: operation, duration: duration)
        case 1002:
            let script = nsError.userInfo["script"] as? String ?? ""
            let exitCode = nsError.userInfo["exitCode"] as? Int ?? -1
            let output = nsError.userInfo["output"] as? String
            return .appleScriptExecution(script: script, exitCode: exitCode, output: output)
        case 1003:
            let script = nsError.userInfo["script"] as? String ?? ""
            let duration = nsError.userInfo["duration"] as? TimeInterval ?? 0
            return .appleScriptTimeout(script: script, duration: duration)
        case 1004:
            let bundleID = nsError.userInfo["bundleID"] as? String ?? ""
            return .unsupportedBrowser(bundleID: bundleID)
        case 1005:
            return .browserNotFound
        case 1006:
            return .accessibilityPermissionDenied
        case 1007:
            let description = nsError.userInfo["elementDescription"] as? String ?? "UI element"
            return .elementNotFound(description: description)
        case 1008:
            let parameter = nsError.userInfo["parameter"] as? String ?? ""
            let reason = nsError.userInfo["reason"] as? String ?? ""
            return .invalidInput(parameter: parameter, reason: reason)
        case 1009:
            if let underlying = nsError.userInfo[NSUnderlyingErrorKey] as? Error {
                return .systemError(underlying: underlying)
            }
            return .unknownError(description: nsError.localizedDescription)
        case 1010:
            let description = nsError.userInfo["errorDescription"] as? String ?? nsError.localizedDescription
            return .unknownError(description: description)
        default:
            return nil
        }
    }
}
