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

    func example() async {
        do {
            // Get selected text using the modern API
            if let selectedText = try await textManager.getSelectedText() {
                print("Selected text: \(selectedText)")
            }

            // Get selected text by specific method
            if let text = try await textManager.getSelectedTextByMenuBarActionCopy() {
                print("Text from menu copy: \(text)")
            }

            // Copy and paste text
            await textManager.copyTextAndPaste("Hello World")

        } catch {
            print("Error: \(error)")
        }
    }
}

// MARK: - Legacy API Usage (For backward compatibility)

class LegacyUsageExample {
    func example() async {
        do {
            // Legacy global functions still work
            if let selectedText = try await getSelectedText() {
                print("Selected text (legacy): \(selectedText)")
            }

            // Copy and paste using legacy function
            await copyTextAndPaste("Hello World Legacy")

        } catch {
            print("Error: \(error)")
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

 // Copy and paste
 [manager copyTextAndPaste:@"Hello from Objective-C" preservePasteboard:YES];
 */
