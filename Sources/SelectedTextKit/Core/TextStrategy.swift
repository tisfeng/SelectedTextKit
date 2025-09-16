//
//  TextStrategy.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/5.
//

import Foundation

// MARK: - TextStrategy

/// Text retrieval strategies
@objc(EZTextStrategy)
public enum TextStrategy: Int, CaseIterable, CustomStringConvertible {
    case auto = 0
    case accessibility = 1
    case appleScript = 2
    case menuAction = 3
    case shortcut = 4

    // MARK: Internal

    public var description: String {
        switch self {
        case .auto:
            return "Auto"
        case .accessibility:
            return "Accessibility"
        case .appleScript:
            return "AppleScript"
        case .menuAction:
            return "Menu Action"
        case .shortcut:
            return "Keyboard Shortcut"
        }
    }
}
