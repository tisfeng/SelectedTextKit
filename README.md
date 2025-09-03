# SelectedTextKit

A modern macOS library for getting selected text with multiple fallback methods and powerful pasteboard utilities.

It's a part of [Easydict](https://github.com/tisfeng/Easydict).

## Features

- ✅ **Multiple Text Retrieval Methods**
  - Get selected text via Accessibility (AXUI)
  - Get selected text by menu bar action copy
  - Get selected text by shortcut key `Cmd+C`
  - Automatic fallback between methods

- ✅ **Pasteboard Protection**
  - Backup and restore pasteboard contents
  - Execute temporary tasks without polluting user's pasteboard
  - Convenient pasteboard string operations

- ✅ **Cross-Language Support**
  - Modern Swift API with async/await
  - Objective-C compatibility
  - Legacy function support for backward compatibility

- ✅ **Clean Architecture**
  - Manager-based design
  - Separate concerns (Text, Accessibility, Pasteboard)
  - Extensible and maintainable code structure

## Installation

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/tisfeng/SelectedTextKit.git", from: "2.0.0")
]
```

Or add it through Xcode: File → Add Package Dependencies

## Usage

### Swift (Recommended)

```swift
import SelectedTextKit

// Modern API using SelectedTextManager
let textManager = SelectedTextManager.shared

do {
    // Get selected text with automatic fallback
    if let selectedText = try await textManager.getSelectedText() {
        print("Selected text: \(selectedText)")
    }
    
    // Use specific methods
    let axText = try await textManager.getSelectedTextByAXUI()
    let menuText = try await textManager.getSelectedTextByMenuBarActionCopy()
    let shortcutText = await textManager.getSelectedTextByShortcutCopy()
    
    // Copy and paste with pasteboard protection
    await textManager.copyTextAndPaste("Hello World", preservePasteboard: true)
} catch {
    print("Error: \(error)")
}
```

## API Reference

### SelectedTextManager

Main class for text retrieval operations:

- `getSelectedText()` - Get selected text with automatic fallback
- `getSelectedTextByAXUI()` - Get text via Accessibility
- `getSelectedTextByMenuBarActionCopy()` - Get text via menu action
- `getSelectedTextByShortcutCopy()` - Get text via Cmd+C
- `copyTextAndPaste(_:preservePasteboard:)` - Copy and paste text

### Pasteboard Utilities

Convenient functions for pasteboard operations:

- `performTemporaryPasteboardTask(_:restoreDelay:)` - Execute task with pasteboard protection
- `setPasteboardString(_:)` / `getPasteboardString()` - Simple string operations
- `savePasteboardContents()` / `restorePasteboardContents()` - Manual backup/restore

### NSPasteboard Extensions

- `performTemporaryTask(_:restoreDelay:)` - Protected task execution
- `backupItems()` / `restoreOriginalContents()` - Content management

## Requirements

- macOS 11.0+

## Dependencies

- [AXSwift](https://github.com/tmandry/AXSwift) - Accessibility framework
- [KeySender](https://github.com/tisfeng/KeySender) - Keyboard event simulation

## Thanks

- Get selected text by menu bar action copy is inspired by [Copi](https://github.com/s1ntoneli/Copi/blob/531a12fdc2da66c809951926ce88af02593e0723/Copi/Utilities/SystemUtilities.swift#L257), thanks to [s1ntoneli](https://github.com/s1ntoneli)'s work.
- Accessibility features built upon [AXSwift](https://github.com/tmandry/AXSwift) framework.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
