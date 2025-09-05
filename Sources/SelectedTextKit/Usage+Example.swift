//
//  Usage Example
//  SelectedTextKit
//
//  This file demonstrates how to use the new SelectedTextKit API
//

import Foundation

// MARK: - New API Usage (Recommended)

class ModernUsageExample {
    private let textManager = SelectedTextManager.shared
    private let axManager = AXManager.shared
    private let pasteboardManager = PasteboardManager.shared

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

            // 🆕 New API: Get selected text using multiple strategies
            let preferredStrategies: TextStrategySet = [.accessibility, .menuAction]
            if let text = try await textManager.getSelectedText(strategies: preferredStrategies) {
                print("Text from preferred strategies: \(text)")
            }
        } catch {
            print("Error: \(error)")
        }
    }

    // MARK: - New Menu Item Finding Examples

    func menuItemExample() async throws {
        // Find different types of menu items
        let copyItem = try axManager.findMenuItem(.copy)
        let pasteItem = try axManager.findMenuItem(.paste)

        // Check if menu items exist
        if axManager.hasCopyMenuItem() {
            print("Copy menu item is available")
        }

        if axManager.hasPasteMenuItem() {
            print("Paste menu item is available")
        }

        // Find enabled menu items only
        do {
            let enabledCopyItem = try axManager.findEnabledMenuItem(.copy)
            print("Found enabled copy item: \(enabledCopyItem)")
        } catch {
            print("Copy item not found or not enabled: \(error)")
        }

        do {
            let enabledPasteItem = try axManager.findEnabledMenuItem(.paste)
            print("Found enabled paste item: \(enabledPasteItem)")
        } catch {
            print("Paste item not found or not enabled: \(error)")
        }
    }
}

// MARK: - Objective-C Compatible Usage

/*
 In Objective-C, you would use:

 @import SelectedTextKit;

 // Get selected text
 STKSelectedTextManager *manager = [STKSelectedTextManager shared];
 [manager getSelectedText:^(NSString * _Nullable text, NSError * _Nullable error) {
     if (text) {
         NSLog(@"Selected text: %@", text);
     }
 }];

 */
