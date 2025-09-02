//
//  SelectedTextKit+API.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2024/10/3.
//  Copyright © 2024 izual. All rights reserved.
//

import Foundation

// MARK: - Public API for Objective-C compatibility

/// Copy text and paste it (Legacy function for backward compatibility)
/// - Parameters:
///   - text: Text to copy and paste
///   - preservePasteboard: Whether to preserve original pasteboard content
/// - Note: Use `SelectedTextManager.shared.copyTextAndPaste(_:preservePasteboard:)` instead.
public func copyTextAndPaste(_ text: String, preservePasteboard: Bool = true) async {
    await SelectedTextManager.shared.copyTextAndPaste(text, preservePasteboard: preservePasteboard)
}
