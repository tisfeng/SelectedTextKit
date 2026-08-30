//
//  NSPasteboard+Extension.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2024/10/3.
//  Copyright © 2024 izual. All rights reserved.
//

import AppKit

extension NSPasteboard {
    /// Protect the pasteboard items from being changed by temporary tasks.
    /// This method will backup current pasteboard contents, execute the task, and then restore the original contents.
    ///
    /// - Parameters:
    ///   - restoreInterval: Delay before restoring contents
    ///   - shouldRestore: Optional validation closure evaluated before restoring.
    ///     Return false to keep the current contents instead of the backup.
    ///   - task: The async task to execute
    @MainActor
    public func performTemporaryTask(
        restoreInterval: TimeInterval = 0.0,
        shouldRestore: (() -> Bool)? = nil,
        task: @escaping () async -> Void
    ) async {
        let savedItems = backupItems()

        await task()

        await Task.sleep(seconds: restoreInterval)

        if let shouldRestore, !shouldRestore() {
            return
        }
        restoreItems(savedItems)
    }
}

// MARK: - NSPasteboard Extension for Saving and Restoring Contents

extension NSPasteboard {
    /// Save current pasteboard contents and return the saved items
    /// - Returns: Array of saved pasteboard items
    @MainActor
    @objc public func backupItems() -> [NSPasteboardItem] {
        /**
         Fix crash:
        
         AppKit     -[NSPasteboardItem dataForType:]
         Easydict   (extension in SelectedTextKit):__C.NSPasteboard.saveCurrentContents() -> () NSPasteboard+Extension.swift:39
        
         ------
        
         Fix crash:
        
         *** -[__NSArrayM objectAtIndex:]: index 1 beyond bounds for empty array
         -[NSPasteboard _updateTypeCacheIfNeeded]
         -[NSPasteboard _typesAtIndex:combinesItems:]
         */
        var itemsToBackup = [NSPasteboardItem]()
        if let items = self.pasteboardItems {
            for item in items {
                let backupItem = NSPasteboardItem()
                let types = item.types  // copy snapshot
                for type in types {
                    if let data = item.data(forType: type) {
                        backupItem.setData(data, forType: type)
                    }
                }
                itemsToBackup.append(backupItem)
            }
        }

        return itemsToBackup
    }

    /// Restore pasteboard contents from saved items
    /// - Parameter pasteboardItems: Array of pasteboard items to restore
    /// - Returns: True if restoration was successful, false otherwise
    @MainActor
    @discardableResult
    @objc public func restoreItems(_ pasteboardItems: [NSPasteboardItem]) -> Bool {
        guard !pasteboardItems.isEmpty else {
            logInfo("No pasteboard items to restore")
            return false
        }

        clearContents()
        let success = writeObjects(pasteboardItems)
        if !success {
            logError("Failed to restore pasteboard items")
        }

        return success
    }
}

extension NSPasteboard {
    /// A convenience property to get and set string content on the pasteboard.
    @objc
    public var string: String {
        get { string(forType: .string) ?? "" }
        set {
            clearContents()
            setString(newValue, forType: .string)
        }
    }

    /// 剪贴板当前是否为“有效空”:无任何类型,或仅有一个空字符串。
    /// 用于识别模拟 ⌘C 后目标应用对空选区执行复制、清空了剪贴板的场景。
    var isEffectivelyEmpty: Bool {
        guard let types, !types.isEmpty else { return true }
        guard types.count == 1, types.contains(.string) else { return false }
        return string.isEmpty
    }
}
