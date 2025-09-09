//
//  AppleScriptManager+System.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/9.
//

import Foundation

// MARK: - System Volume Management

extension AppleScriptManager {

    /// Temporarily mute alert volume and execute an operation
    ///
    /// - Parameter operation: The operation to execute while muted
    /// - Returns: Result of the operation
    /// - Throws: Any error from the operation or volume management
    public func withMutedAlertVolume<T>(_ operation: () async throws -> T) async throws -> T {
        // Save current volume and mute in one operation
        let originalVolume = try await muteAlertVolume()

        do {
            // Execute the operation
            let result = try await operation()

            // Restore original volume
            try await setAlertVolume(originalVolume)

            return result
        } catch {
            // Ensure we restore volume even if operation fails
            try? await setAlertVolume(originalVolume)
            throw error
        }
    }
    
    /// Mute alert volume and return the original volume level
    ///
    /// - Returns: Original alert volume level (0-100)
    /// - Throws: SelectedTextKitError if getting/setting volume fails
    public func muteAlertVolume() async throws -> Int {
        let script = systemEventsScript(
            """
            set originalVolume to alert volume of (get volume settings)
            set volume alert volume 0
            return originalVolume
            """)

        guard let result = try await runAppleScript(script, timeout: 2.0),
            let originalVolume = Int(result)
        else {
            throw SelectedTextKitError.appleScriptExecution(
                script: script,
                description: "Failed to parse original volume")
        }

        return originalVolume
    }
    
    /// Get current system alert volume
    ///
    /// - Returns: Current alert volume (0-100) or nil if failed
    public func getCurrentAlertVolume() async throws -> Int? {
        let script = systemEventsScript("get alert volume of (get volume settings)")

        guard let result = try await runAppleScript(script, timeout: 2.0),
            let volume = Int(result)
        else {
            return nil
        }

        return volume
    }

    /// Set system alert volume
    ///
    /// - Parameter volume: Volume level (0-100)
    /// - Throws: SelectedTextKitError if setting volume fails
    public func setAlertVolume(_ volume: Int) async throws {
        let clampedVolume = max(0, min(100, volume))
        let script = systemEventsScript("set volume alert volume \(clampedVolume)")

        _ = try await runAppleScript(script, timeout: 2.0)
    }

    /// Create a System Events AppleScript with the given commands
    ///
    /// - Parameter commands: The commands to execute within System Events
    /// - Returns: Complete AppleScript string
    private func systemEventsScript(_ commands: String) -> String {
        return """
            tell application "System Events"
                \(commands)
            end tell
            """
    }

}
