//
//  SelectedTextManagerTests.swift
//  SelectedTextKitExampleTests
//
//  Created by tisfeng on 2025/9/8.
//

import Foundation
import SelectedTextKit
import AppKit
import Testing

struct SelectedTextManagerTests {
    let axManager = AXManager.shared
    let textManager = SelectedTextManager.shared
    let pasteboardManager = PasteboardManager.shared

    let pasteboard = NSPasteboard.general
    
    @Test("SelectedTextManager getSelectedText examples")
    func example() async {
        do {
            // 🆕 New API: Get selected text using automatic strategy
            if let selectedText = try await textManager.getSelectedText(strategy: .auto) {
                print("Selected text (auto): \(selectedText)")
            }
            
            // Get selected text using specific strategy
            if let text = try await textManager.getSelectedText(strategy: .accessibility) {
                print("Text from accessibility: \(text)")
            }

            // Get selected text using menu action strategy
            if let text = try await textManager.getSelectedText(strategy: .menuAction) {
                print("Text from menu action: \(text)")
            }

            // Get selected text using shortcut strategy
            if let text = try await textManager.getSelectedText(strategy: .shortcut) {
                print("Text from shortcut: \(text)")
            }

            // Get selected text using AppleScript strategy
            let bundleID = SupportedBrowser.chrome.rawValue
            if let text = try await textManager.getSelectedText(strategy: .appleScript, bundleID: bundleID) {
                print("Text from AppleScript: \(text)")
            }
        } catch {
            print("Error: \(error)")
        }
    }
}
