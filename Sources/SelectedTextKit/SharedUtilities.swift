//
//  SharedUtilities.swift
//  SelectedTextKit
//
//  Created by tisfeng on 10/15/24.
//  Copyright © 2024 izual. All rights reserved.
//

import AppKit
import Foundation
import KeySender
import os.log

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
    _ task: @escaping () async -> Bool,
    every interval: TimeInterval = 0.005,
    timeout: TimeInterval = 0.1
) async -> Bool {
    let startTime = Date()
    while Date().timeIntervalSince(startTime) < timeout {
        if await task() {
            return true
        }
        await Task.sleep(seconds: interval)
    }
    logInfo("pollTask timeout")
    return false
}

// MARK: - KeySender Extensions

public extension KeySender {
    /// Copy (Cmd+C)
    static func copy() {
        let sender = KeySender(key: .c, modifiers: .command)
        sender.sendGlobally()
    }

    /// Paste (Cmd+V)
    static func paste() {
        let sender = KeySender(key: .v, modifiers: .command)
        sender.sendGlobally()
    }

    /// Select All (Cmd+A)
    static func selectAll() {
        let sender = KeySender(key: .a, modifiers: .command)
        sender.sendGlobally()
    }
}

// MARK: - Task Extensions

extension Task where Success == Never, Failure == Never {
    /// Sleep for given seconds within a Task
    static func sleep(seconds: TimeInterval) async {
        try? await Task.sleepThrowing(seconds: seconds)
    }

    /// Sleep for given seconds within a Task, throwing an error if cancelled
    static func sleepThrowing(seconds: TimeInterval) async throws {
        try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}

// MARK: - Measure Execution Time

func measureTime(block: () -> Void) {
    let startTime = DispatchTime.now()
    block()
    let endTime = DispatchTime.now()

    let nanoseconds = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
    let milliseconds = Double(nanoseconds) / 1_000_000

    print("Execution time: \(milliseconds) ms")
}
