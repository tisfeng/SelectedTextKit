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

/// Namespace for informational SelectedTextKit values.
public enum STKInfo {
    /// Current SelectedTextKit version.
    public static let version = "2.6.7"

    /// Library name.
    public static let name = "SelectedTextKit"
}

/// SelectedTextKit version information for Objective-C compatibility
@objc(STKVersionInfo)
public final class VersionInfo: NSObject {
    /// Current library version
    @objc public static let libraryVersion = STKInfo.version

    /// Library name
    @objc public static let libraryName = STKInfo.name
}
