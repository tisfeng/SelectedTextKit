//
//  AppleScriptManager+System.swift
//  SelectedTextKitExample
//
//  Created by tisfeng on 2025/9/8.
//

import Foundation
import SelectedTextKit

// MARK: - AppleScriptManager System Extensions

extension AppleScriptManager {
    // MARK: Private
    
    
}


extension ScriptInfo {
    /// Get system alertVolume
    static let alertVolume: ScriptInfo = .init(
        name: "getAlertVolume",
        script:
"""
tell application "System Events"
    get alert volume
end tell
""",
        timeout: 0.2,
    )
}
