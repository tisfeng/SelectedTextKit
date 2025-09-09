//
//  AXSwift+Search.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/5.
//

import AXSwift
import Cocoa

extension UIElement {

    /// Get children elements, throws error if failed
    public func children() throws -> [UIElement]? {
        let axElements: [AXUIElement]? = try attribute(.children)
        return axElements?.map { UIElement($0) }
    }

    /// Iteratively search through the UI element tree in a depth-first manner to find an element that satisfies the given condition.
    public func deepFirst(where condition: @escaping (UIElement) -> Bool) throws -> UIElement? {
        if condition(self) {
            return self
        }

        for child in try children() ?? [] {
            if let element = try child.deepFirst { condition($0) } {
                return element
            }
        }
        
        return nil
    }
}
