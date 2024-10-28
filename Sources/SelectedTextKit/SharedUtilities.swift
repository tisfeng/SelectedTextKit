//
//  SharedUtilities.swift
//  Easydict
//
//  Created by tisfeng on 10/15/24.
//  Copyright © 2024 izual. All rights reserved.
//

import AXSwift
import Foundation

// MARK: - SharedUtilities


/// Poll task, if task is true, return true, else continue polling.
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
