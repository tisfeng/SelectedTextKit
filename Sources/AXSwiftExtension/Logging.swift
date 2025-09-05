//
//  Logging.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/5.
//

import Foundation
import os.log

private let logger = Logger(
    subsystem: "com.izual.SelectedTextKit", category: "main")

/// Shared date formatter for timestamps
private let sharedDateFormatter = DateFormatter()

/// Generate high precision timestamp with microseconds
public var logTimestamp: String {
    let now = Date()
    let timeInterval = now.timeIntervalSince1970
    let microseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 1_000_000)

    sharedDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let dateString = sharedDateFormatter.string(from: now)

    return String(format: "%@.%06d", dateString, microseconds)
}

/// Log info message with timestamp
public func logInfo(_ message: String) {
    logger.info("[\(logTimestamp)] \(message)")
}

/// Log error message with timestamp
public func logError(_ message: String) {
    logger.error("[\(logTimestamp)] \(message)")
}
