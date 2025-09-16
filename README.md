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
let quickStrategies: [TextStrategy] = [.accessibility, .shortcut]
let browserStrategies: [TextStrategy] = [.appleScript, .accessibility, .menuAction]
let fallbackStrategies: [TextStrategy] = [.accessibility, .menuAction, .shortcut]
```

## API Reference

### SelectedTextManager

Main class for text retrieval operations:

#### Core Methods

- `getSelectedText(strategy: TextStrategy, bundleID: String? = nil)` - Get text using a specific strategy
- `getSelectedText(strategies: [TextStrategy])` - Get text using multiple strategies with ordered fallback
  
#### Strategy-Specific Methods

- `getSelectedText(strategy: .accessibility)` - Get text via Accessibility API
- `getSelectedText(strategy: .appleScript)` - Get text via AppleScript (browsers)
- `getSelectedText(strategy: .menuAction)` - Get text via menu bar copy action
- `getSelectedText(strategy: .shortcut)` - Get text via Cmd+C shortcut
- `getSelectedText(strategy: .auto)` - Smart fallback strategy

#### Strategy Arrays

Create ordered combinations of strategies (execution order is preserved):

```swift
// Fast strategies first
let quickArray: [TextStrategy] = [.accessibility, .shortcut]

// Browser-optimized strategies (AppleScript first for better performance)
let browserArray: [TextStrategy] = [.appleScript, .accessibility, .menuAction]

// Maximum compatibility (try fastest methods first)
let compatibilityArray: [TextStrategy] = [.accessibility, .menuAction, .shortcut]
```

### TextStrategy Enum

```swift
public enum TextStrategy: Int, CaseIterable {
    case auto          // Intelligent fallback
    case accessibility // Accessibility API
    case appleScript   // AppleScript (browsers)
    case menuAction    // Menu bar copy
    case shortcut      // Keyboard shortcut
}
```

### Usage Scenarios

#### 🚀 Quick Integration (Recommended)

For most applications, use the auto strategy:

```swift
let textManager = SelectedTextManager.shared

// Simple and reliable
if let text = try await textManager.getSelectedText(strategy: .auto) {
    // Process selected text
}
```

#### 🌐 Browser Applications

For browser-focused applications with AppleScript support:

```swift
let browserStrategies: [TextStrategy] = [.appleScript, .accessibility, .menuAction]

if let text = try await textManager.getSelectedText(strategies: browserStrategies) {
    // Process browser text
}
```

#### ⚡ Performance-Optimized

For applications requiring fast response:

```swift
let quickStrategies: [TextStrategy] = [.accessibility, .shortcut]

if let text = try await textManager.getSelectedText(strategies: quickStrategies) {
    // Process text quickly
}
```

#### 🔄 Maximum Compatibility

For applications requiring maximum success rate:

```swift
let allStrategies: [TextStrategy] = [.accessibility, .appleScript, .menuAction, .shortcut]

if let text = try await textManager.getSelectedText(strategies: allStrategies) {
    // Process with maximum compatibility
}
```

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
