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

- ✅ **Cross-Language Support**
  - Modern Swift API with async/await
  - Objective-C compatibility

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

private let textManager = SelectedTextManager.shared

func example() async {
    do {
        // Get selected text using multiple fallback methods
        if let selectedText = try await textManager.getSelectedText() {
            print("Selected text: \(selectedText)")
        }

        // Get selected text by menu action
        if let text = try await textManager.getSelectedTextByMenuAction() {
            print("Text from menu copy: \(text)")
        }

        // Get selected text by shortcut
        if let text = try await textManager.getSelectedTextByShortcut() {
            print("Text from shortcut copy: \(text)")
        }

    } catch {
        print("Error: \(error)")
    }
}
```

## API Reference

### SelectedTextManager

Main class for text retrieval operations:

- `getSelectedText()` - Get selected text with automatic fallback
- `getSelectedTextByAX()` - Get text via Accessibility
- `getSelectedTextByMenuAction()` - Get text via menu bar copy action
- `getSelectedTextByShortcut()` - Get text via Cmd+C

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
