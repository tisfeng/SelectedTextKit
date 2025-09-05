//
//  AXError+Custom.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/5.
//

import Foundation
import ApplicationServices

// MARK: - Custom AXError Definitions

extension AXError {
    /// No menu item found
    public static let noMenuItem = AXError(rawValue: 1001)!
    
    /// Disabled menu item
    public static let disabledMenuItem = AXError(rawValue: 1002)!
}

// MARK: - AXError to conform to NSError for better interoperability

extension AXError: @retroactive CustomNSError {
    public var errorCode: Int {
        return Int(self.rawValue)
    }
}
