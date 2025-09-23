# SelectedTextKit

A modern macOS library for getting selected text with multiple fallback strategies, smart volume management, and powerful pasteboard utilities.

It's a part of [Easydict](https://github.com/tisfeng/Easydict).

## Features

- ✅ **Multiple Text Retrieval Strategies**
  - **Accessibility**: Get selected text via Accessibility API (AXUI)
  - **Menu Action**: Get selected text by menu bar copy action
  - **Keyboard Shortcut**: Get selected text by `Cmd+C` with muted system volume
  - **AppleScript**: Get selected text from browsers using AppleScript
  - **Auto**: Intelligent fallback with multiple methods
  - **Custom Strategy Arrays**: Define your own combination of strategies

- ✅ **Smart Fallback System**
  - Configurable strategy combinations
  - Automatic retry with different methods
  - Graceful error handling and recovery

- ✅ **Pasteboard Protection**
  - Backup and restore pasteboard contents
  - Execute temporary tasks without polluting user's pasteboard
  - Volume management to prevent system beep sounds

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
        // Option 1: Use auto strategy (recommended for most cases)
        if let selectedText = try await textManager.getSelectedText(strategy: .auto) {
            print("Selected text: \(selectedText)")
        }

        // Option 2: Use custom strategy array with ordered fallbacks
        let strategies: [TextStrategy] = [.accessibility, .menuAction, .shortcut]
        if let text = try await textManager.getSelectedText(strategies: strategies) {
            print("Text from custom strategies: \(text)")
        }

        // Option 3: Use specific strategies for browsers (order matters)
        let browserStrategies: [TextStrategy] = [.appleScript, .accessibility]
        if let text = try await textManager.getSelectedText(strategies: browserStrategies) {
            print("Text from browser: \(text)")
        }

        // Option 4: Use individual strategy methods
        if let text = try await textManager.getSelectedText(strategy: .menuAction) {
            print("Text from menu copy: \(text)")
        }

        // Option 5: Use shortcut strategy with muted volume
        if let text = try await textManager.getSelectedText(strategy: .shortcut) {
            print("Text from shortcut copy: \(text)")
        }

    } catch {
        print("Error: \(error)")
    }
}
```

#### Available Text Strategies

```swift
// All available strategies
public enum TextStrategy {
    case auto          // Intelligent fallback (accessibility → menu action)
    case accessibility // Get text via Accessibility API
    case appleScript   // Get text from browsers via AppleScript
    case menuAction    // Get text via menu bar copy action
    case shortcut      // Get text via Cmd+C (with muted volume)
}

// Create ordered strategy arrays (execution order matters!)
let browserStrategies: [TextStrategy] = [.appleScript, .accessibility, .menuAction, .shortcut]
let fallbackStrategies: [TextStrategy] = [.accessibility, .menuAction, .shortcut]
```

## API Reference

### Core Methods

- `getSelectedText(strategy: TextStrategy)` - Get text using a specific strategy  
- `getSelectedText(strategies: [TextStrategy])` - Get text using multiple strategies with ordered fallback

### Available Strategies

| Strategy | Description | Best For |
|----------|-------------|----------|
| `.auto` | Smart fallback (accessibility → menu action) | **Recommended** - Most reliable |
| `.accessibility` | Direct Accessibility API | Fast, lightweight access |
| `.appleScript` | Browser automation via AppleScript | Safari, Chrome, Firefox |
| `.menuAction` | System menu bar copy action | When accessibility is limited |
| `.shortcut` | Cmd+C with muted system volume | Universal compatibility |


## Requirements

- macOS 11.0+
- Swift 5.7+

## Dependencies

- [AXSwift](https://github.com/tmandry/AXSwift) - Accessibility framework
- [KeySender](https://github.com/tisfeng/KeySender) - Keyboard event simulation

## Acknowledgments

- Menu bar copy action inspired by [Copi](https://github.com/s1ntoneli/Copi) by [s1ntoneli](https://github.com/s1ntoneli)

## License

MIT License - see [LICENSE](LICENSE) for details.
