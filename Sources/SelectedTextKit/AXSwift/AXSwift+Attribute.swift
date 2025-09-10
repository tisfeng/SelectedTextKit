//
//  AXSwift+Attribute.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/5.
//

import Foundation
import AXSwift

// MARK: - UIElement Attribute Extensions

extension UIElement {
    /// Get focused UI element, throws error if failed
    public func focusedUIElement() throws -> UIElement? {
        try attribute(.focusedUIElement)
    }

    /// Get role value, throws error if failed
    public func roleValue() throws -> String? {
        try attribute(.role)
    }

    /// Get value, throws error if failed
    public func value() throws -> String? {
        try attribute(.value)
    }

    /// Get selected text, throws error if failed
    public func selectedText() throws -> String? {
        try attribute(.selectedText)
    }

    /// Get selected text range, throws error if failed
    public func selectedTextRange() throws -> CFRange? {
        try attribute(.selectedTextRange)
    }
    
    /// Get command character, throws error if failed
    public func cmdChar() throws -> String? {
        try attribute(Attribute.cmdChar)
    }

    /// Get command virtual key, throws error if failed
    public func cmdVirtualKey() throws -> Int? {
        try attribute(Attribute.cmdVirtualKey)
    }

    /// Get command modifiers, throws error if failed
    public func cmdModifiers() throws -> Int? {
        try attribute(Attribute.cmdModifiers)
    }

    /// Get title, throws error if failed
    public func title() throws -> String? {
        try attribute(.title)
    }

    /// Get identifier, throws error if failed
    public func identifier() throws -> String? {
        try attribute(.identifier)
    }

    /// Get menu bar, throws error if failed
    public func menu() throws -> UIElement? {
        try attribute(.menuBar)
    }

    /// Get enabled status, throws error if failed
    public func isEnabled() throws -> Bool? {
        try attribute(.enabled)
    }
}

extension Attribute {
    public static let cmdChar = "AXMenuItemCmdChar"
    public static let cmdVirtualKey = "AXMenuItemCmdVirtualKey"
    public static let cmdModifiers = "AXMenuItemCmdModifiers"
}

