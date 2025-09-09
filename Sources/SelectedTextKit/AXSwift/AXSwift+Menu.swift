//
//  AXSwift+Menu.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/5.
//

import AXSwift
import AppKit
import Foundation

extension UIElement {
    /// Find a specific menu item by type
    /// Search strategy: Start from the 4th item (usually Edit menu),
    /// then expand to adjacent items alternately.
    /// Search index order: 3 -> 2 -> 4 -> 1 -> 5 -> 0 -> 6
    public func findMenuItem(_ menuItemType: SystemMenuItem) throws -> UIElement? {
        return try findMenuItemGeneric(menuItemType)
    }

    /// Find the copy item element (backward compatibility)
    /// Search strategy: Start from the 4th item (usually Edit menu),
    /// then expand to adjacent items alternately.
    /// Search index order: 3 -> 2 -> 4 -> 1 -> 5 -> 0 -> 6
    public func findCopyMenuItem() throws -> UIElement? {
        return try findMenuItemGeneric(.copy)
    }

    /// Find the paste item element
    /// Search strategy: Start from the 4th item (usually Edit menu),
    /// then expand to adjacent items alternately.
    /// Search index order: 3 -> 2 -> 4 -> 1 -> 5 -> 0 -> 6
    public func findPasteMenuItem() throws -> UIElement? {
        return try findMenuItemGeneric(.paste)
    }

    /// Generic menu item finder implementation
    private func findMenuItemGeneric(_ menuItemType: SystemMenuItem) throws -> UIElement? {
        do {
            guard let menu = try menu(), let menuChildren = try menu.children() else {
                logError("Menu children not found")
                return nil
            }

            let totalItems = menuChildren.count

            // Start from index 3 (4th item) if available
            let startIndex = 3

            // If we have enough items, try the 4th item first (usually Edit menu)
            if totalItems > startIndex {
                let editMenu = menuChildren[startIndex]
                logInfo("Checking the Edit menu for \(menuItemType), index: \(startIndex)")
                if let element = try findMenuItemInElement(editMenu, menuItemType: menuItemType) {
                    return element
                }

                // Search adjacent items alternately
                for offset in 1...(max(startIndex, totalItems - startIndex - 1)) {
                    // Try left item
                    let leftIndex = startIndex - offset
                    if leftIndex >= 0 {
                        logInfo("Checking menu at index \(leftIndex) for \(menuItemType)")
                        if let element = try findMenuItemInElement(
                            menuChildren[leftIndex], menuItemType: menuItemType)
                        {
                            return element
                        }
                    }

                    // Try right item
                    let rightIndex = startIndex + offset
                    if rightIndex < totalItems {
                        logInfo("Checking menu at index \(rightIndex) for \(menuItemType)")
                        if let element = try findMenuItemInElement(
                            menuChildren[rightIndex], menuItemType: menuItemType)
                        {
                            return element
                        }
                    }

                    // If both indices are out of bounds, stop searching
                    if leftIndex < 0 && rightIndex >= totalItems {
                        break
                    }
                }
            }

            // If still not found, search the entire menu as fallback
            logInfo("\(menuItemType) not found in adjacent menus, searching entire menu")
            return try findMenuItemInElement(menu, menuItemType: menuItemType)
        } catch {
            logError("Error finding menu item \(menuItemType): \(error)")
            return nil
        }
    }

    /// Helper method to find menu item in a specific element
    private func findMenuItemInElement(
        _ menuElement: UIElement,
        menuItemType: SystemMenuItem
    ) throws -> UIElement? {
        return try menuElement.deepFirst { [self] element in
            do {
                guard let identifier = try element.identifier() else {
                    return false
                }

                // Check by identifier first (more reliable)
                if identifier == menuItemType.rawValue {
                    logInfo("Found \(menuItemType) item by identifier: \(identifier)")
                    return true
                }

                // Check by title and shortcut character as fallback
                if let shortcutChar = menuItemType.shortcutChar,
                   try element.cmdChar() == shortcutChar,
                   let title = try element.title(),
                    isMenuTitleMatching(title, for: menuItemType)
                {
                    logInfo(
                        "Found \(menuItemType) title item in menu: \(try element.title()!), identifier: \(identifier)"
                    )
                    return true
                }

                return false
            } catch {
                // If we can't get element attributes, skip this element
                return false
            }
        }
    }

    /// Check if menu title matches the menu item type
    private func isMenuTitleMatching(_ title: String?, for menuItemType: SystemMenuItem) -> Bool {
        return menuItemType.matchesTitle(title)
    }

    /// Check if the element is a copy element, identifier is "copy:", means copy action selector.
    public var isCopyIdentifier: Bool {
        do {
            return try identifier() == SystemMenuItem.copy.rawValue
        } catch {
            return false
        }
    }

    /// Check if the element is a copy element, title is "Copy".
    public var isCopyTitle: Bool {
        do {
            return SystemMenuItem.copy.matchesTitle(try title())
        } catch {
            return false
        }
    }

    /// Check if the element is a paste element, identifier is "paste:", means paste action selector.
    public var isPasteIdentifier: Bool {
        do {
            return try identifier() == SystemMenuItem.paste.rawValue
        } catch {
            return false
        }
    }

    /// Check if the element is a paste element, title is "Paste".
    public var isPasteTitle: Bool {
        do {
            return SystemMenuItem.paste.matchesTitle(try title())
        } catch {
            return false
        }
    }
}
