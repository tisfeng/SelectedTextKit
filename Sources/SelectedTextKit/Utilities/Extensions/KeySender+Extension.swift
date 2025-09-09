//
//  KeySender+Extension.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/5.
//

import Foundation
import KeySender

// MARK: - KeySender Extensions

extension KeySender {
    /// Copy (Cmd+C)
    public static func copy() {
        let sender = KeySender(key: .c, modifiers: .command)
        sender.sendGlobally()
    }

    /// Paste (Cmd+V)
    public static func paste() {
        let sender = KeySender(key: .v, modifiers: .command)
        sender.sendGlobally()
    }

    /// Select All (Cmd+A)
    public static func selectAll() {
        let sender = KeySender(key: .a, modifiers: .command)
        sender.sendGlobally()
    }
}
