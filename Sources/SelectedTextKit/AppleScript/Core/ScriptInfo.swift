//
//  ScriptInfo.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/8.
//

import Foundation

/// Container for AppleScript information
public struct ScriptInfo {
    public let name: String
    public let script: String
    public let timeout: TimeInterval
    public let description: String?

    public init(
        name: String,
        script: String,
        timeout: TimeInterval = 5.0,
        description: String? = nil
    ) {
        self.name = name
        self.script = script
        self.timeout = timeout
        self.description = description
    }
}
