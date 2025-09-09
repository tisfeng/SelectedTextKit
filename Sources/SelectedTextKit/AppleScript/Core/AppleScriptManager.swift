//
//  AppleScriptManager
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/7.
//

import AppKit
import Foundation
import Subprocess

public final class AppleScriptManager {
    // MARK: - Public

    /// Shared singleton instance
    public static let shared = AppleScriptManager()

    /// Run an AppleScript command asynchronously using swift-subprocess with timeout support.
    ///
    /// - Parameters:
    ///   - script: The AppleScript source code to execute.
    ///   - timeout: Timeout in seconds. Default is 5.0.
    /// - Returns: The output string if successful, or throws an error.
    public func runAppleScript(_ script: String, timeout: TimeInterval = 5.0) async throws
        -> String?
    {
        do {
            return try await withTimeout(in: .seconds(timeout)) {
                let result = try await run(
                    .name("osascript"),
                    arguments: ["-e", script],
                    output: .string(limit: .max),
                    error: .standardOutput
                )

                let trimmedOutput = result.standardOutput?.trimmingCharacters(
                    in: .whitespacesAndNewlines)

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
            throw SelectedTextKitError.timeout(
                operation: "AppleScript execution", duration: timeout)
        } catch let error as SelectedTextKitError {
            throw error
        } catch {
            throw SelectedTextKitError.systemError(underlying: error)
        }
    }

    /// Execute an AppleScript using ScriptInfo configuration.
    ///
    /// - Parameter scriptInfo: The script information containing script, timeout, and metadata.
    /// - Returns: The output string if successful, or throws an error.
    public func runAppleScript(_ scriptInfo: ScriptInfo) async throws -> String? {
        let timeout = scriptInfo.timeout ?? 5.0

        do {
            let result = try await runAppleScript(scriptInfo.script, timeout: timeout)

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

extension TerminationStatus {
    public var exitCode: Code? {
        if case .exited(let code) = self {
            return code
        }
        return nil
    }
}
