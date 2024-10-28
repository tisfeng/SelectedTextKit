//
//  SystemUtility.swift
//  Easydict
//
//  Created by tisfeng on 2024/10/3.
//  Copyright © 2024 izual. All rights reserved.
//

import AXSwift
import AXSwiftExt
import Carbon
import KeySender
import AppKit

// MARK: - SystemUtility

@objcMembers
public class SystemUtility: NSObject {
    /// Copy text and paste text safely.
    static func copyTextAndPasteSafely(_ text: String) async {
        logInfo("Copy text and paste text safely")

       let text =  await monitorPasteboardContentChange {
            text.copyToClipboard()
        }

        if let text = text {
            postPasteEvent()
            logInfo("Pasted text: \(text)")
        } else {
            logError("Failed to paste text")
        }

//        monitorPasteboardContentChange(
//            triggerAction: {
//                text.copyToClipboard()
//            },
//            onPasteboardChange: { text in
//                if let pastedText = text {
//                    postPasteEvent()
//                    logInfo("Pasted text: \(pastedText)")
//                } else {
//                    logError("Failed to paste text")
//                }
//            }
//        )
    }
}

/// Post copy event: Cmd+C
public func postCopyEvent() {
    let sender = KeySender(key: .c, modifiers: .command)
    sender.sendGlobally()
}

/// Post paste event: Cmd+V
func postPasteEvent() {
    let sender = KeySender(key: .v, modifiers: .command)
    sender.sendGlobally()
}

func measureTime(block: () -> Void) {
    let startTime = DispatchTime.now()
    block()
    let endTime = DispatchTime.now()

    let nanoseconds = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
    let milliseconds = Double(nanoseconds) / 1_000_000

    print("Execution time: \(milliseconds) ms")
}

extension String {
    /// Copy to clipboard
    func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(self, forType: .string)
    }
}
