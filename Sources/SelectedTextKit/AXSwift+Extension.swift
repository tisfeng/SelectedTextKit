//
//  AXSwift+Extension.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2024/10/8.
//  Copyright © 2024 izual. All rights reserved.
//

import AXSwift
import AXSwiftExt
import AppKit
import Foundation

// MARK: - Legacy Global Functions (moved to AccessibilityManager)

/// Find the copy item in the frontmost application.
/// - Note: This is a legacy function for backward compatibility. Use AccessibilityManager().findCopyMenuItem() instead.
public func findCopyMenuItem() -> UIElement? {
    return AccessibilityManager().findCopyMenuItem()
}

/// Find the enabled copy item in the frontmost application.
/// - Note: This is a legacy function for backward compatibility. Use AccessibilityManager().findEnabledCopyItem() instead.
public func findEnabledCopyItem() -> UIElement? {
    return AccessibilityManager().findEnabledCopyItem()
}

// MARK: - UIElement Extensions

extension UIElement {
    /// Find the copy item element, identifier is "copy:", or title is "Copy".
    /// Search strategy: Start from the 4th item (usually Edit menu),
    /// then expand to adjacent items alternately.
    /// Search index order: 3 -> 2 -> 4 -> 1 -> 5 -> 0 -> 6
    public func findCopyMenuItem() -> UIElement? {
        guard let menu, let menuChildren = menu.children else {
            logError("Menu children not found")
            return nil
        }

        let totalItems = menuChildren.count

        // Start from index 3 (4th item) if available
        let startIndex = 3

        // If we have enough items, try the 4th item first (usually Edit menu)
        if totalItems > startIndex {
            let editMenu = menuChildren[startIndex]
            logInfo("Checking the Edit menu, index: \(startIndex)")
            if let copyElement = findCopyMenuItemIn(editMenu) {
                return copyElement
            }

            // Search adjacent items alternately
            for offset in 1...(max(startIndex, totalItems - startIndex - 1)) {
                // Try left item
                let leftIndex = startIndex - offset
                if leftIndex >= 0 {
                    logInfo("Checking menu at index \(leftIndex)")
                    if let copyElement = findCopyMenuItemIn(menuChildren[leftIndex]) {
                        return copyElement
                    }
                }

                // Try right item
                let rightIndex = startIndex + offset
                if rightIndex < totalItems {
                    logInfo("Checking menu at index \(rightIndex)")
                    if let copyElement = findCopyMenuItemIn(menuChildren[rightIndex]) {
                        return copyElement
                    }
                }

                // If both indices are out of bounds, stop searching
                if leftIndex < 0 && rightIndex >= totalItems {
                    break
                }
            }
        }

        // If still not found, search the entire menu as fallback
        logInfo("Copy not found in adjacent menus, searching entire menu")
        return findCopyMenuItemIn(menu)
    }

    /// Check if the element is a copy element, identifier is "copy:", means copy action selector.
    public var isCopyIdentifier: Bool {
        identifier == SystemMenuItem.copy.rawValue
    }

    /// Check if the element is a copy element, title is "Copy".
    public var isCopyTitle: Bool {
        guard let title = title else {
            return false
        }
        return copyTitles.contains(title)
    }
}

// MARK: - NSRunningApplication Extensions

/// NSRunningApplication extension description: localizedName (bundleIdentifier)
extension NSRunningApplication {
    open override var description: String {
        "\(localizedName ?? "") (\(bundleIdentifier ?? ""))"
    }
}

// MARK: - Private Helper Functions

private func findCopyMenuItemIn(_ menuElement: UIElement) -> UIElement? {
    menuElement.deepFirst { element in
        guard let identifier = element.identifier else {
            return false
        }

        if element.isCopyIdentifier {
            logInfo("Found copy item by copy identifier: \(identifier)")
            return true
        }

        if element.cmdChar == "C", element.isCopyTitle {
            logInfo("Found copy title item in menu: \(element.title!), identifier: \(identifier)")
            return true
        }
        return false
    }
}

/// Menu bar copy titles set, include most of the languages.
private let copyTitles: Set<String> = [
    "Copy",  // English
    "拷贝", "复制",  // Simplified Chinese
    "拷貝", "複製",  // Traditional Chinese
    "コピー",  // Japanese
    "복사",  // Korean
    "Copier",  // French
    "Copiar",  // Spanish, Portuguese
    "Copia",  // Italian
    "Kopieren",  // German
    "Копировать",  // Russian
    "Kopiëren",  // Dutch
    "Kopiér",  // Danish
    "Kopiera",  // Swedish
    "Kopioi",  // Finnish
    "Αντιγραφή",  // Greek
    "Kopyala",  // Turkish
    "Salin",  // Indonesian
    "Sao chép",  // Vietnamese
    "คัดลอก",  // Thai
    "Копіювати",  // Ukrainian
    "Kopiuj",  // Polish
    "Másolás",  // Hungarian
    "Kopírovat",  // Czech
    "Kopírovať",  // Slovak
    "Kopiraj",  // Croatian, Serbian (Latin)
    "Копирај",  // Serbian (Cyrillic)
    "Копиране",  // Bulgarian
    "Kopēt",  // Latvian
    "Kopijuoti",  // Lithuanian
    "Copiază",  // Romanian
    "העתק",  // Hebrew
    "نسخ",  // Arabic
    "کپی",  // Persian
]
