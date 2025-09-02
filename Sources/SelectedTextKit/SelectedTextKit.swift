//
//  SelectedTextKit.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2024/10/3.
//  Copyright © 2024 izual. All rights reserved.
//

// This file serves as the main entry point for the SelectedTextKit library
// All functionality has been moved to dedicated manager classes for better organization
// Legacy functions are provided for backward compatibility

import Foundation

/// SelectedTextKit version information
@objc(STKVersionInfo)
public final class VersionInfo: NSObject {
    @objc public static let libraryVersion = "1.0.0"
    @objc public static let build = "1"
}
