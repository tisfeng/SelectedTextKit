//
//  SharedUtilities.swift
//  SelectedTextKit
//
//  Created by tisfeng on 10/15/24.
//  Copyright © 2024 izual. All rights reserved.
//

import Foundation
import os.log
import KeySender
import AppKit

let logger = Logger(subsystem: "com.izual.SelectedTextKit", category: "main")

func logInfo(_ message: String) {
    logger.info("\(message)")
}

func logError(_ message: String) {
    logger.error("\(message)")
}

/// Poll task, if task is true, return true, else continue polling.
@discardableResult
public func pollTask(
    _ task: @escaping () -> Bool,
    every interval: TimeInterval = 0.005,
    timeout: TimeInterval = 0.1
) async -> Bool {
    let startTime = Date()
    while Date().timeIntervalSince(startTime) < timeout {
        if task() {
            return true
        }
        try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
    }
    logInfo("pollTask timeout")
    return false
}

/// Copy text and paste text safely.
func copyTextAndPasteSafely(_ text: String) async {
    logInfo("Copy text and paste text safely")

    let newContent = await getNextPasteboardContent {
        text.copyToClipboard()
    }

    if let text = newContent {
        postPasteEvent()
        logInfo("Pasted text: \(text)")
    } else {
        logError("Failed to paste text")
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

extension String {
    func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(self, forType: .string)
    }
}

func measureTime(block: () -> Void) {
    let startTime = DispatchTime.now()
    block()
    let endTime = DispatchTime.now()

    let nanoseconds = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
    let milliseconds = Double(nanoseconds) / 1_000_000

    print("Execution time: \(milliseconds) ms")
}
