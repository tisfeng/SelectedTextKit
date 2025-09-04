//
//  SelectedTextKitExampleTests.swift
//  SelectedTextKitExampleTests
//
//  Created by tisfeng on 2025/9/4.
//

import Testing
import AppKit
@testable import SelectedTextKit

struct SelectedTextKitExampleTests {
    let manager = PasteboardManager.shared
    let pasteboard = NSPasteboard.general
    
    // MARK: - PasteboardManager Tests
    
    @Test("Test pasteText with restorePasteboard true and false")
    func testPasteText() async throws {
        let originalContent = pasteboard.string
        let testText = originalContent + " Appended Test Text"

        // Paste text with restoration
        await manager.pasteText(testText, restorePasteboard: true)
        #expect(originalContent == pasteboard.string, "Pasteboard should be restored to original content")
        
        // Paste text without restoration to see the change
        await manager.pasteText(testText, restorePasteboard: false)
        #expect(originalContent != pasteboard.string, "Pasteboard should not be restored, content should change")
    }
    
    @Test("Test pasteText consecutive calls with restore")
    func testPasteTextConsecutiveCallsWithRestore() async throws {
        let originalContent = pasteboard.string
        let testCount = 100
        var costTimes: [Double] = []

        for index in 0 ..< testCount {
            let startTime = CFAbsoluteTimeGetCurrent()
            await manager.pasteText(String(index), restorePasteboard: true, restoreInterval: 0.0)
            let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
            costTimes.append(elapsedTime)
            
            // After each call, the pasteboard should be restored to original content
            let currentContent = pasteboard.string
            #expect(currentContent == originalContent, "Pasteboard should be restored after call \(index + 1)")
        }
        
        // log max cost time
        if let maxTime = costTimes.max() {
            print("Max time for pasteText in \(testCount) calls: \(maxTime) seconds")
        }
        
        // log avarage cost time
        let averageTime = costTimes.reduce(0, +) / Double(costTimes.count)
        print("Average time for pasteText in \(testCount) calls: \(averageTime) seconds")
    }
}
