//
//  NSPasteboard+Extension.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2024/10/3.
//  Copyright © 2024 izual. All rights reserved.
//

import AppKit

private var kSavedItemsKey: UInt8 = 0

extension NSPasteboard {
    /// Protect the pasteboard items from being changed by temporary tasks.
    func performTemporaryTask(
        _ task: @escaping () async -> Void,
        restoreDelay: TimeInterval = 0
    ) async -> Void {
        saveCurrentContents()

        await task()

        if restoreDelay > 0 {
            try? await Task.sleep(nanoseconds: UInt64(restoreDelay * 1_000_000_000))
        }
        restoreOriginalContents()
    }
}

extension NSPasteboard {
    func saveCurrentContents() {
        var archivedItems = [NSPasteboardItem]()
        if let allItems = pasteboardItems {
            for item in allItems {
                let archivedItem = NSPasteboardItem()
                for type in item.types {
                    if let data = item.data(forType: type) {
                        archivedItem.setData(data, forType: type)
                    }
                }
                archivedItems.append(archivedItem)
            }
        }

        if !archivedItems.isEmpty {
            savedItems = archivedItems
        }
    }

    func restoreOriginalContents() {
        if let items = savedItems {
            clearContents()
            writeObjects(items)
            savedItems = nil
        }
    }

    private var savedItems: [NSPasteboardItem]? {
        get {
            objc_getAssociatedObject(self, &kSavedItemsKey) as? [NSPasteboardItem]
        }
        set {
            objc_setAssociatedObject(self, &kSavedItemsKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension NSPasteboard {
    func setString(_ string: String?) {
        clearContents()
        if let string {
            setString(string, forType: .string)
        }
    }

    func string() -> String? {
        // Check if there is text type data
        guard let types = types, types.contains(.string) else {
            logInfo("No string type data found: \(types)")
            return nil
        }
        return string(forType: .string)
    }
}
