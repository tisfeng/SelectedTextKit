//
//  NSPasteboard+Extension.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2024/10/3.
//  Copyright © 2024 izual. All rights reserved.
//

import AppKit

extension NSPasteboard {
    /// Pasteboard type marker used to opt the restored contents OUT of
    /// clipboard-history recording in well-behaved clipboard managers
    /// (Maccy, Pastebot, Alfred, LaunchBar, PopClip, …). The convention
    /// is documented at https://nspasteboard.com/. Setting this on the
    /// final restore step makes the round-trip invisible to history
    /// listeners — exactly what callers expect from a "temporary task".
    public static let transientType = NSPasteboard.PasteboardType(
        rawValue: "org.nspasteboard.TransientType"
    )

    /// Protect the pasteboard items from being changed by temporary tasks.
    /// This method will backup current pasteboard contents, execute the task, and then restore the original contents.
    ///
    /// The restore step is marked with `org.nspasteboard.TransientType`
    /// (https://nspasteboard.com/) so clipboard managers skip it — the
    /// whole point of `performTemporaryTask` is to leave no user-visible
    /// trace of the round-trip, and the marker is the standard way to
    /// communicate "this write is transient" to history consumers.
    ///
    /// - Parameters:
    ///   - restoreInterval: Delay before restoring contents
    ///   - markRestoreAsTransient: When `true` (default) the restore
    ///     declares the nspasteboard transient marker. Set `false` to
    ///     opt out — useful if a caller explicitly wants the restored
    ///     state to look like a fresh user copy.
    ///   - task: The async task to execute
    @MainActor
    public func performTemporaryTask(
        restoreInterval: TimeInterval = 0.0,
        markRestoreAsTransient: Bool = true,
        task: @escaping () async -> Void
    ) async {
        let savedItems = backupItems()

        await task()

        await Task.sleep(seconds: restoreInterval)

        restoreItems(savedItems, markAsTransient: markRestoreAsTransient)
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

    /// Restore pasteboard contents from saved items.
    ///
    /// - Parameters:
    ///   - pasteboardItems: Array of pasteboard items to restore.
    ///   - markAsTransient: When `true` (default) the restore declares
    ///     `org.nspasteboard.TransientType` so well-behaved clipboard
    ///     managers (Maccy, Pastebot, etc.) skip the entry. The marker
    ///     is added as an empty-string value on each restored item, so
    ///     all original data types remain readable.
    /// - Returns: True if restoration was successful, false otherwise.
    @MainActor
    @discardableResult
    @objc public func restoreItems(
        _ pasteboardItems: [NSPasteboardItem],
        markAsTransient: Bool = true
    ) -> Bool {
        guard !pasteboardItems.isEmpty else {
            logInfo("No pasteboard items to restore")
            return false
        }

        if markAsTransient {
            // Re-add the marker on each restored item. Clipboard managers
            // check `pasteboard.types` (or per-item `types`) for the
            // marker before recording, so it must be present at the time
            // of the write — declaring it later would not retroactively
            // suppress the change-count tick.
            for item in pasteboardItems {
                item.setString("", forType: NSPasteboard.transientType)
            }
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
}
