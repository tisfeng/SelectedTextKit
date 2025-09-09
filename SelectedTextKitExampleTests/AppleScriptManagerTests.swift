//
//  AppleScriptManagerTests.swift
//  SelectedTextKitExampleTests
//
//  Created by tisfeng on 2025/9/8.
//

import AppKit
import Foundation
import Testing

@testable import SelectedTextKit

/// Test suite for AppleScriptManager functionality
struct AppleScriptManagerTests {

    let manager = AppleScriptManager.shared

    // MARK: - Basic Script Execution Tests

    @Test("Test basic AppleScript execution with simple command")
    func testBasicAppleScriptExecution() async throws {
        // Test simple AppleScript that should work on all systems
        let script = """
            tell application "System Events"
                return "Hello from AppleScript"
            end tell
            """

        let result = try await manager.runAppleScript(script, timeout: 5.0)
        #expect(result == "Hello from AppleScript", "Script should return expected text")
    }

    @Test("Test AppleScript with browser action")
    func testAppleScriptWithBrowserAction() async throws {
        // Test getting selected text from Chrome
        let result = try await manager.executeBrowserAction(.getSelectedText, browser: .chrome)
        logInfo("Selected text from Chrome: \(String(describing: result))")
        
        // Test getting selected text from Safari
        let safariResult = try await manager.executeBrowserAction(.getSelectedText, browser: .safari)
        logInfo("Selected text from Safari: \(String(describing: safariResult))")
    }

    @Test("Test AppleScript timeout handling")
    func testAppleScriptTimeout() async {
        // Script that intentionally takes longer than timeout
        let script = """
            delay 3
            return "Should timeout"
            """

        let customAction = BrowserAction.custom(
            script: "\(script)",
            timeout: 2.0,
            description: "Custom console log"
        )

        await #expect(throws: SelectedTextKitError.self) {
            try await manager.executeBrowserAction(customAction, browser: .safari)
        }
    }

    @Test("Test invalid AppleScript handling")
    func testInvalidAppleScript() async {
        let invalidScript = "this is not valid AppleScript syntax"

        await #expect(throws: SelectedTextKitError.self) {
            try await manager.runAppleScript(invalidScript, timeout: 5.0)
        }
    }

    // MARK: - Browser Support Tests

    @Test("Test browser support detection")
    func testBrowserSupportDetection() {
        // Test known supported browsers
        #expect(
            manager.isBrowserSupportingAppleScript("com.apple.Safari"), "Safari should be supported"
        )
        #expect(
            manager.isBrowserSupportingAppleScript("com.google.Chrome"),
            "Chrome should be supported")
        #expect(
            manager.isBrowserSupportingAppleScript("com.microsoft.edgemac"),
            "Edge should be supported")

        // Test unsupported browser
        #expect(
            !manager.isBrowserSupportingAppleScript("com.unknown.browser"),
            "Unknown browser should not be supported")
    }

    @Test("Test error types and properties")
    func testErrorTypes() {
        // Test timeout error
        let timeoutError = SelectedTextKitError.timeout(operation: "test", duration: 5.0)
        #expect(timeoutError.isTimeout, "Timeout error should be identified as timeout")
        #expect(!timeoutError.isAppleScriptError, "Timeout error should not be AppleScript error")
        #expect(timeoutError.isRecoverable, "Timeout error should be recoverable")

        // Test AppleScript execution error
        let scriptError = SelectedTextKitError.appleScriptExecution(
            script: "test script",
            exitCode: 1,
            description: "error output"
        )
        #expect(
            scriptError.isAppleScriptError, "Script error should be identified as AppleScript error"
        )
        #expect(!scriptError.isTimeout, "Script error should not be timeout")
        #expect(!scriptError.isRecoverable, "Script error should not be recoverable")

        // Test browser error
        let browserError = SelectedTextKitError.unsupportedBrowser(bundleID: "com.test.browser")
        #expect(browserError.isBrowserError, "Browser error should be identified as browser error")
        #expect(browserError.isRecoverable, "Browser error should be recoverable")
    }


    // MARK: - Performance Tests

    @Test("Test script execution performance")
    func testScriptExecutionPerformance() async throws {
        let simpleScript = """
            tell application "System Events"
                return "test"
            end tell
            """

        let startTime = CFAbsoluteTimeGetCurrent()
        _ = try await manager.runAppleScript(simpleScript, timeout: 5.0)
        let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime

        print("Script execution time: \(elapsedTime) seconds")
        #expect(elapsedTime < 2.0, "Simple script should execute quickly")
    }

    @Test("Test multiple concurrent script executions")
    func testConcurrentScriptExecution() async throws {
        let script = """
            tell application "System Events"
                return "concurrent test"
            end tell
            """

        // Execute multiple scripts concurrently
        let tasks = (1...5).map { index in
            Task {
                return try await manager.runAppleScript(script, timeout: 5.0)
            }
        }

        let results = try await withThrowingTaskGroup(of: String?.self) { group in
            for task in tasks {
                group.addTask { try await task.value }
            }

            var allResults: [String?] = []
            for try await result in group {
                allResults.append(result)
            }
            return allResults
        }

        #expect(results.count == 5, "Should execute 5 scripts")
        #expect(
            results.allSatisfy { $0 == "concurrent test" },
            "All scripts should return expected result")
    }
}
