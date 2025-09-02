//
//  NSPasteboard+Extension.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2024/10/3.
//  Copyright © 2024 izual. All rights reserved.
//

import AppKit

private var kBackupItemsKey: UInt8 = 0

public extension NSPasteboard {
    /// Protect the pasteboard items from being changed by temporary tasks.
    @MainActor
    func performTemporaryTask(
        _ task: @escaping () async -> Void,
        restoreDelay: TimeInterval = 0
    ) async {
        saveCurrentContents()

        await task()

        if restoreDelay > 0 {
            try? await Task.sleep(nanoseconds: UInt64(restoreDelay * 1_000_000_000))
        }
        restoreOriginalContents()
    }
}

// MARK: - NSPasteboard Extension for Saving and Restoring Contents

public extension NSPasteboard {
    @MainActor
    @objc func saveCurrentContents() {
        /**
         FIX crash:

         AppKit     -[NSPasteboardItem dataForType:]
         Easydict   (extension in SelectedTextKit):__C.NSPasteboard.saveCurrentContents() -> () NSPasteboard+Extension.swift:39
         */
        DispatchQueue.main.async {
            do {
                var backupItems = [NSPasteboardItem]()
                if let items = self.pasteboardItems {
                    for item in items {
                        let backupItem = NSPasteboardItem()
                        for type in item.types {
                            if let data = item.data(forType: type) {
                                backupItem.setData(data, forType: type)
                            }
                        }
                        backupItems.append(backupItem)
                    }
                }

                if !backupItems.isEmpty {
                    self.backupItems = backupItems
                }
            } catch {
                logError("Failed to save current contents: \(error)")
            }
        }
    }

    @MainActor
    @objc func restoreOriginalContents() {
        if let items = backupItems {
            clearContents()
            writeObjects(items)
            backupItems = nil
        }
    }

    private var backupItems: [NSPasteboardItem]? {
        get {
            objc_getAssociatedObject(self, &kBackupItemsKey) as? [NSPasteboardItem]
        }
        set {
            objc_setAssociatedObject(self, &kBackupItemsKey, newValue, .OBJC_ASSOCIATION_RETAIN)
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
