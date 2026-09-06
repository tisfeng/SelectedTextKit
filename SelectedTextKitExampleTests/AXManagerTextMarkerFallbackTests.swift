//
//  AXManagerTextMarkerFallbackTests.swift
//  SelectedTextKitExampleTests
//
//  Created by tisfeng on 2026/9/6.
//

import ApplicationServices
import Testing

@testable import SelectedTextKit

/// Tests the deterministic selection rules between native AX and Text Marker results.
struct AXManagerTextMarkerFallbackTests {

    /// A native AX error used to verify that fallback failure preserves the original error.
    private enum NativeTextError: Error {
        case unavailable
    }

    @Test("Native selected text takes precedence over Text Marker text")
    func nativeTextTakesPrecedence() throws {
        var fallbackWasRead = false

        let selectedText = try AXManager.resolvedSelectedText(
            from: .success("Native text"),
            textMarkerText: {
                fallbackWasRead = true
                return "Text Marker text"
            }
        )

        #expect(selectedText == "Native text")
        #expect(!fallbackWasRead)
    }

    @Test("Empty native selected text falls back to Text Marker text")
    func emptyNativeTextFallsBackToTextMarker() throws {
        let selectedText = try AXManager.resolvedSelectedText(
            from: .success(""),
            textMarkerText: { "Text Marker text" }
        )

        #expect(selectedText == "Text Marker text")
    }

    @Test("Missing native selected text falls back to Text Marker text")
    func missingNativeTextFallsBackToTextMarker() throws {
        let selectedText = try AXManager.resolvedSelectedText(
            from: .success(nil),
            textMarkerText: { "Text Marker text" }
        )

        #expect(selectedText == "Text Marker text")
    }

    @Test("Native AX errors fall back to Text Marker text")
    func nativeErrorFallsBackToTextMarker() throws {
        let nativeResult: Result<String?, Error> = .failure(NativeTextError.unavailable)

        let selectedText = try AXManager.resolvedSelectedText(
            from: nativeResult,
            textMarkerText: { "Text Marker text" }
        )

        #expect(selectedText == "Text Marker text")
    }

    @Test("Empty native selected text remains empty when Text Marker is unavailable")
    func emptyNativeTextRemainsEmptyWithoutTextMarker() throws {
        let selectedText = try AXManager.resolvedSelectedText(
            from: .success(""),
            textMarkerText: { nil }
        )

        #expect(selectedText.isEmpty)
    }

    @Test("Missing native selected text throws noValue when Text Marker is unavailable")
    func missingNativeTextThrowsNoValueWithoutTextMarker() {
        #expect(throws: AXError.self) {
            try AXManager.resolvedSelectedText(
                from: .success(nil),
                textMarkerText: { nil }
            )
        }
    }

    @Test("Native AX errors are preserved when Text Marker is unavailable")
    func nativeErrorIsPreservedWithoutTextMarker() {
        let nativeResult: Result<String?, Error> = .failure(NativeTextError.unavailable)

        #expect(throws: NativeTextError.self) {
            try AXManager.resolvedSelectedText(
                from: nativeResult,
                textMarkerText: { nil }
            )
        }
    }
}
