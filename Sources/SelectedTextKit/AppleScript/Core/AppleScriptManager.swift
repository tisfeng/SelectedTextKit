//
//  AppleScriptManager
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/7.
//

import AppKit
import Foundation

public final class AppleScriptManager {
    // MARK: - Public

    /// Shared singleton instance
    public static let shared = AppleScriptManager()

    /// Run an AppleScript command using NSAppleScript.
    ///
    /// - Parameters:
    ///   - script: The AppleScript source code to execute.
    ///   - timeout: Timeout in seconds. Default is 5.0.
    /// - Returns: The output string if successful, or throws an error.
    public func runAppleScript(_ script: String, timeout: TimeInterval = 5.0) async throws
        -> String?
    {
        return try await withTimeout(in: timeout) {
            return try await withCheckedThrowingContinuation { continuation in
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        let appleScript = NSAppleScript(source: script)
                        var errorDict: NSDictionary?

                        let result = appleScript?.executeAndReturnError(&errorDict)

                        if let errorDict {
                            let errorCode = errorDict[NSAppleScript.errorNumber] as? Int ?? -1
                            let errorMessage =
                                errorDict[NSAppleScript.errorMessage] as? String
                                ?? "Unknown AppleScript error"

                            let error = SelectedTextKitError.appleScriptExecution(
                                script: script,
                                exitCode: errorCode,
                                description: errorMessage
                            )
                            continuation.resume(throwing: error)
                            return
                        }

                        let output = result?.stringValue?.trimmingCharacters(
                            in: .whitespacesAndNewlines)
                        continuation.resume(returning: output)

                    } catch {
                        continuation.resume(
                            throwing: SelectedTextKitError.systemError(underlying: error))
                    }
                }
            }
        }
    }

    /// Execute an AppleScript using ScriptInfo configuration.
    ///
    /// - Parameter scriptInfo: The script information containing script, timeout, and metadata.
    /// - Returns: The output string if successful, or throws an error.
    public func runAppleScript(_ scriptInfo: ScriptInfo) async throws -> String? {
        do {
            let result = try await runAppleScript(scriptInfo.script, timeout: scriptInfo.timeout)

            // Log execution with script name
            logInfo("Executed script '\(scriptInfo.name)': \(result ?? "no output")")

            return result
        } catch {
            // Log error with script name
            logInfo("Failed to execute script '\(scriptInfo.name)': \(error)")
            throw error
        }
    }
}
