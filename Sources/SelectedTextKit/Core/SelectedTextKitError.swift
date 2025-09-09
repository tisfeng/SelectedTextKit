//
//  SelectedTextKitError.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/8.
//

import Foundation

// MARK: - Error Types

/// Unified error type for SelectedTextKit operations
public enum SelectedTextKitError: Error, LocalizedError, CustomNSError {
    case timeout(operation: String, duration: TimeInterval)
    case appleScriptExecution(script: String, exitCode: Int? = 1, description: String? = nil)
    case unsupportedBrowser(bundleID: String)
    case browserNotFound
    case accessibilityPermissionDenied
    case elementNotFound(description: String)
    case invalidInput(parameter: String, reason: String)
    case systemError(underlying: Error)
    case unknownError(description: String)

    public var errorDescription: String? {
        switch self {
        case .timeout(let operation, let duration):
            return "Operation '\(operation)' timed out after \(duration) seconds"
        case .appleScriptExecution(_, let exitCode, let output):
            return
                "AppleScript execution failed with exit code \(exitCode): \(output ?? "Unknown error")"
        case .unsupportedBrowser(let bundleID):
            return "Browser '\(bundleID)' is not supported for AppleScript operations"
        case .browserNotFound:
            return "No frontmost browser application found"
        case .accessibilityPermissionDenied:
            return "Accessibility permission is required for this operation"
        case .elementNotFound(let description):
            return "UI element not found: \(description)"
        case .invalidInput(let parameter, let reason):
            return "Invalid input for parameter '\(parameter)': \(reason)"
        case .systemError(let underlying):
            return "System error: \(underlying.localizedDescription)"
        case .unknownError(let description):
            return "Unknown error: \(description)"
        }
    }

    public var failureReason: String? {
        switch self {
        case .timeout(let operation, _):
            return "The \(operation) operation took too long to complete"
        case .appleScriptExecution:
            return "The AppleScript command failed to execute successfully"
        case .unsupportedBrowser:
            return "The browser does not support AppleScript automation"
        case .browserNotFound:
            return "No supported browser application is currently running"
        case .accessibilityPermissionDenied:
            return "The application does not have accessibility permissions"
        case .elementNotFound:
            return "The required UI element could not be located"
        case .invalidInput:
            return "The provided input parameters are invalid"
        case .systemError:
            return "An underlying system error occurred"
        case .unknownError:
            return "An unexpected error occurred"
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .timeout:
            return
                "Try increasing the timeout duration or check if the target application is responding"
        case .appleScriptExecution:
            return
                "Ensure the target application is running and accessible, or try running the script manually"
        case .unsupportedBrowser:
            return "Use a supported browser like Safari, Chrome, or Microsoft Edge"
        case .browserNotFound:
            return "Open a supported browser application and try again"
        case .accessibilityPermissionDenied:
            return
                "Grant accessibility permissions in System Preferences > Security & Privacy > Privacy > Accessibility"
        case .elementNotFound:
            return "Ensure the target element is visible and accessible"
        case .invalidInput:
            return "Check the input parameters and provide valid values"
        case .systemError:
            return "Check system logs for more details"
        case .unknownError:
            return "Try restarting the application or contact support"
        }
    }

    // MARK: CustomNSError

    public static var errorDomain: String {
        "SelectedTextKitErrorDomain"
    }

    public var errorCode: Int {
        switch self {
        case .timeout: return 1001
        case .appleScriptExecution: return 1002
        case .unsupportedBrowser: return 1003
        case .browserNotFound: return 1004
        case .accessibilityPermissionDenied: return 1005
        case .elementNotFound: return 1006
        case .invalidInput: return 1007
        case .systemError: return 1008
        case .unknownError: return 1009
        }
    }

    public var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [
            NSLocalizedDescriptionKey: errorDescription ?? "Unknown error",
            NSLocalizedFailureReasonErrorKey: failureReason ?? "",
            NSLocalizedRecoverySuggestionErrorKey: recoverySuggestion ?? "",
        ]

        switch self {
        case .timeout(let operation, let duration):
            userInfo["operation"] = operation
            userInfo["duration"] = duration
        case .appleScriptExecution(let script, let exitCode, let output):
            userInfo["script"] = script
            userInfo["exitCode"] = exitCode
            userInfo["output"] = output
        case .unsupportedBrowser(let bundleID):
            userInfo["bundleID"] = bundleID
        case .elementNotFound(let description):
            userInfo["elementDescription"] = description
        case .invalidInput(let parameter, let reason):
            userInfo["parameter"] = parameter
            userInfo["reason"] = reason
        case .systemError(let underlying):
            userInfo[NSUnderlyingErrorKey] = underlying
        case .unknownError(let description):
            userInfo["errorDescription"] = description
        default:
            break
        }

        return userInfo
    }
}
