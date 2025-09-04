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
            // Get selected text using multiple fallback methods
            if let selectedText = try await textManager.getSelectedText() {
                print("Selected text: \(selectedText)")
            }

            // Get selected text by menu action
            if let text = try await textManager.getSelectedTextByMenuAction() {
                print("Text from menu copy: \(text)")
            }

            // Get selected text by shortcut
            if let text = try await textManager.getSelectedTextByShortcut() {
                print("Text from shortcut copy: \(text)")
            }

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
 
 */
