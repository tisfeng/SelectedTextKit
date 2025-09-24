//
//  SelectedTextManager.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2024/10/3.
//  Copyright © 2024 izual. All rights reserved.
//

import AXSwift
import AppKit
import KeySender

/// Main manager class for getting selected text from applications
@objc(STKSelectedTextManager)
public final class SelectedTextManager: NSObject {

    @objc
    public static let shared = SelectedTextManager()

    private let axManager = AXManager.shared
    private let pasteboardManager = PasteboardManager.shared
    private let appleScriptManager = AppleScriptManager.shared

    /// Get selected text from current focused application using specified strategy
    ///
    /// - Parameter strategy: The text retrieval strategy to use
    /// - Parameter bundleID: Optional browser bundle identifier for AppleScript strategy
    /// - Returns: Selected text or nil if failed
    /// - Throws: Error if the operation fails
    @objc
    public func getSelectedText(
        strategy: TextStrategy,
        bundleID: String? = nil
    ) async throws -> String? {
        logInfo("Attempting to get selected text using strategy: \(strategy.description)")

        switch strategy {
        case .auto:
            return try await getSelectedTextAuto()
        case .accessibility:
            return try await getSelectedTextByAX()
        case .appleScript:
            return try await getSelectedTextByAppleScript(from: bundleID)
        case .menuAction:
            return try await getSelectedTextByMenuAction()
        case .shortcut:
            return try await getSelectedTextByShortcut()
        }
    }

    /// Get selected text using multiple strategies in order
    ///
    /// - Parameter strategies: Array of strategies to try in order
    /// - Returns: Selected text or nil if all strategies fail
    /// - Throws: SelectedTextKitError if operation fails due to system issues
    public func getSelectedText(strategies: [TextStrategy]) async throws -> String? {
        logInfo("Attempting to get selected text using strategies: \(strategies)")

        var lastError: SelectedTextKitError?

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
            } catch let error as SelectedTextKitError {
                logError(
                    "Failed to get text via \(strategy.description): \(error.localizedDescription)")
                lastError = error

                // Don't continue trying other strategies for certain critical errors
                if case .accessibilityPermissionDenied = error {
                    throw error
                }
                continue
            } catch {
                logError("Failed to get text via \(strategy.description): \(error)")
                lastError = .systemError(underlying: error)
                continue
            }
        }

        logError("All strategies failed to get selected text")

        // If we have a specific error from the last attempt, throw it
        if let lastError {
            throw lastError
        }

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
        let text = try await getSelectedTextByAX()
        if !text.isEmpty {
            logInfo("Successfully got non-empty text via Accessibility")
            return text
        } else {
            logInfo("Accessibility returned empty text")
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
    private func getSelectedTextByAX() async throws -> String {
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

        // Execute copy operation with muted alert volume to prevent system beep on empty selection
        return try await AppleScriptManager.shared.withMutedAlertVolume {
            return await pasteboardManager.getSelectedText {
                KeySender.copy()
            }
        }
    }

    /// Get selected text by AppleScript from browser applications
    ///
    /// - Parameter browserBundleID: The bundle identifier of the browser
    /// - Returns: Selected text or nil if failed, throws on error
    private func getSelectedTextByAppleScript(from browserBundleID: String?) async throws -> String? {
        let frontmostApp = NSWorkspace.shared.frontmostApplication
        let browserBundleID = browserBundleID ?? frontmostApp?.bundleIdentifier ?? ""
        
        logInfo("Getting selected text by AppleScript from browser: \(browserBundleID)")

        guard appleScriptManager.isBrowserSupportingAppleScript(browserBundleID) else {
            throw SelectedTextKitError.unsupportedBrowser(bundleID: browserBundleID)
        }

        return try await appleScriptManager.getSelectedTextFromBrowser(browserBundleID)
    }
}
