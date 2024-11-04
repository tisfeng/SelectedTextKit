//
//  SelectedTextKit.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2024/10/3.
//  Copyright © 2024 izual. All rights reserved.
//

import AXSwift
import Cocoa

/// 1. Get selected text, try to get text by AXUI first.
/// 2. If failed, try to get text by menu action copy.
public func getSelectedText() async throws -> String? {
    logInfo("Attempting to get selected text")

    // Try AXUI method first
    let axResult = await getSelectedTextByAXUI()
    switch axResult {
    case let .success(text):
        if !text.isEmpty {
            logInfo("Successfully got non-empty text via AXUI")
            return text
        } else {
            logInfo("AXUI returned empty text, trying menu action copy")
            // Fall through to try menu action copy
        }

    case let .failure(error):
        logError("Failed to get text via AXUI: \(error)")
    }

    // If AXUI fails or returns empty text, try menu action copy
    if let menuCopyText = try await getSelectedTextByMenuBarActionCopy() {
        if !menuCopyText.isEmpty {
            logInfo("Successfully got non-empty text via menu action copy")
            return menuCopyText
        } else {
            logInfo("Menu action copy returned empty text")
        }
    }

    logError("All methods to get selected text have failed or returned empty text")
    return nil
}

/// Get selected text by AXUI
public func getSelectedTextByAXUI() async -> Result<String, AXError> {
    logInfo("Getting selected text via AXUI")

    let systemWideElement = AXUIElementCreateSystemWide()
    var focusedElementRef: CFTypeRef?

    // Get the currently focused element
    let focusedElementResult = AXUIElementCopyAttributeValue(
        systemWideElement,
        kAXFocusedUIElementAttribute as CFString,
        &focusedElementRef
    )

    guard focusedElementResult == .success,
        let focusedElement = focusedElementRef as! AXUIElement?
    else {
        logError("Failed to get focused element, error: \(focusedElementResult)")
        return .failure(focusedElementResult)
    }

    var selectedTextValue: CFTypeRef?

    // Get the selected text
    let selectedTextResult = AXUIElementCopyAttributeValue(
        focusedElement,
        kAXSelectedTextAttribute as CFString,
        &selectedTextValue
    )

    guard selectedTextResult == .success else {
        logError("Failed to get selected text, error: \(selectedTextResult)")
        return .failure(selectedTextResult)
    }

    guard let selectedText = selectedTextValue as? String else {
        logError("Selected text is not a string, error: \(selectedTextResult)")
        return .failure(.noValue)
    }

    logInfo("Selected text via AXUI: \(selectedText)")
    return .success(selectedText)
}

/// Get selected text by menu bar action copy
///
/// Refer to Copi: https://github.com/s1ntoneli/Copi/blob/531a12fdc2da66c809951926ce88af02593e0723/Copi/Utilities/SystemUtilities.swift#L257
@MainActor
public func getSelectedTextByMenuBarActionCopy() async throws -> String? {
    logInfo("Getting selected text by menu bar action copy")

    guard let copyItem = findEnabledCopyItemInFrontmostApp() else {
        return nil
    }

    return await getSelectedTextWithAction {
        try copyItem.performAction(.press)
    }
}

/// Get selected text by shortcut copy
public func getSelectedTextByShortcutCopy() async -> String? {
    logInfo("Getting selected text by shortcut copy")

    guard checkIsProcessTrusted(prompt: true) else {
        logError("Process is not trusted for accessibility")
        return nil
    }

    return await getSelectedTextWithAction {
        postCopyEvent()
    }
}

@MainActor
func getSelectedTextWithAction(
    action: @escaping () throws -> Void
) async -> String? {
    await getNextPasteboardContent(triggeredBy: action)
}

/// Get the next pasteboard content after executing an action.
/// - Parameters:
///   - action: The action that triggers the pasteboard change
///   - preservePasteboard: Whether to preserve the original pasteboard content
/// - Returns: The new pasteboard content if changed, nil if failed or timeout
@MainActor
func getNextPasteboardContent(
    triggeredBy action: @escaping () throws -> Void,
    preservePasteboard: Bool = true
) async -> String? {
    logInfo("Getting next pasteboard content")

    let pasteboard = NSPasteboard.general
    let initialChangeCount = pasteboard.changeCount
    var newContent: String?

    let executeAction = { @MainActor in
        do {
            logInfo("Executing trigger action")
            try action()
        } catch {
            logError("Failed to execute trigger action: \(error)")
            return
        }

        await pollTask { @MainActor in
            // Check if the pasteboard content has changed
            if pasteboard.changeCount != initialChangeCount {
                // !!!: The pasteboard content may be nil or other strange content(such as old content) if the pasteboard is changing by other applications in the same time, like PopClip.
                newContent = pasteboard.string()
                if let newContent {
                    logInfo("New Pasteboard content: \(newContent)")
                    return true
                }

                logError("Pasteboard changed but no valid text content found")
                return false
            }
            return false
        }
    }

    if preservePasteboard {
        await pasteboard.performTemporaryTask(executeAction)
    } else {
        await executeAction()
    }

    return newContent
}
