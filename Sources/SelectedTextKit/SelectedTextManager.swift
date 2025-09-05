//
//  SelectedTextManager.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2024/10/3.
//  Copyright © 2024 izual. All rights reserved.
//

import AXSwift
import AXSwiftExtension
import AppKit
import KeySender

/// Main manager class for getting selected text from applications
@objc(STKSelectedTextManager)
public final class SelectedTextManager: NSObject {

    /// Shared singleton instance
    @objc
    public static let shared = SelectedTextManager()

    private let axManager = AXManager.shared
    private let pasteboardManager = PasteboardManager.shared

    /// Get selected text using specified strategy
    ///
    /// - Parameter strategy: The text retrieval strategy to use
    /// - Returns: Selected text or nil if failed
    /// - Throws: Error if the operation fails
    @objc
    public func getSelectedText(strategy: TextStrategy) async throws -> String? {
        logInfo("Attempting to get selected text using strategy: \(strategy.description)")

        switch strategy {
        case .auto:
            return try await getSelectedTextAuto()
        case .accessibility:
            return try await getSelectedTextByAX()
        case .appleScript:
            logError("AppleScript strategy not implemented yet")
            return nil
        case .menuAction:
            return try await getSelectedTextByMenuAction()
        case .shortcut:
            return try await getSelectedTextByShortcut()
        }
    }

    /// Get selected text using multiple strategies in order
    ///
    /// - Parameter strategies: Set of strategies to try in order
    /// - Returns: Selected text or nil if all strategies fail
    public func getSelectedText(strategies: TextStrategySet) async throws -> String? {
        logInfo(
            "Attempting to get selected text using strategies: \(strategies)")

        for strategy in strategies {
            do {
                if let text = try await getSelectedText(strategy: strategy) {
                    if !text.isEmpty {
                        logInfo("Successfully got non-empty text via \(strategy.description)")
                        return text
                    } else {
                        logInfo("\(strategy.description) returned empty text, trying next strategy")
                    }
                }
            } catch {
                logError("Failed to get text via \(strategy.description): \(error)")
                continue
            }
        }

        logError("All strategies failed to get selected text")
        return nil
    }

    // MARK: - Private Get selected text methods

    /// Get selected text using auto strategy (tries multiple methods)
    ///
    /// 1. Try Accessibility method first
    /// 2. If failed, try menu action copy
    /// - Returns: Selected text or nil if failed
    private func getSelectedTextAuto() async throws -> String? {
        logInfo("Using auto strategy for getting selected text")

        // Try Accessibility method first
        if let text = try await getSelectedTextByAX() {
            if !text.isEmpty {
                logInfo("Successfully got non-empty text via Accessibility")
                return text
            } else {
                logInfo("Accessibility returned empty text")
            }
        }

        do {
            // If Accessibility fails or returns empty text, try menu action copy
            if let menuCopyText = try await getSelectedTextByMenuAction() {
                if !menuCopyText.isEmpty {
                    logInfo("Successfully got non-empty text via menu action copy")
                    return menuCopyText
                } else {
                    logInfo("Menu action copy returned empty text")
                }
            }
        } catch {
            logError("Failed to get text via menu action copy: \(error)")

            let axError = error as? AXError
            if axError == .apiDisabled {
                logInfo("Accessibility API is disabled, returning nil")
                return nil
            } else if axError == .noMenuItem {
                logInfo("Menu action copy not available, falling back to shortcut copy")
                return try await getSelectedTextByShortcut()
            } else if axError == .disabledMenuItem {
                logInfo("Menu action copy is disabled, maybe no text selected, returning nil")
                return nil
            } else {
                throw error
            }
        }

        logError("All auto strategy methods failed or returned empty text")
        return nil
    }

    /// Get selected text by AXUI
    ///
    /// - Returns: Selected text or nil if failed, throws on error
    private func getSelectedTextByAX() async throws -> String? {
        return try await axManager.getSelectedTextByAX()
    }

    /// Get selected text by menu bar action copy
    ///
    /// - Returns: Selected text or nil if failed
    @MainActor
    private func getSelectedTextByMenuAction() async throws -> String? {
        logInfo("Getting selected text by menu bar action copy")

        let copyItem = try axManager.findEnabledMenuItem(.copy)

        return await pasteboardManager.getSelectedText {
            try copyItem.performAction(.press)
        }
    }

    /// Get selected text by shortcut copy (Cmd+C)
    ///
    /// - Returns: Selected text or nil if failed
    private func getSelectedTextByShortcut() async throws -> String? {
        logInfo("Getting selected text by shortcut copy")

        guard checkIsProcessTrusted(prompt: true) else {
            logError("Process is not trusted for accessibility")
            throw AXError.apiDisabled
        }

        return await pasteboardManager.getSelectedText {
            KeySender.copy()
        }
    }
}
