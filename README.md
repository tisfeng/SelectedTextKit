## SelectedTextKit

This is a macOS library that allows you to easily get the selected text.

### Features

- [x] Get selected text via AXUI
- [x] Get selected text by menu bar action copy
- [x] Get selected text by shortcut key `cmd + c`

### Usage

```swift
import SelectedTextKit

// Get selected text via AXUI, if fails, it will try to get text by menu bar action copy.
let text = try await getSelectedText()

// Get selected text by menu bar action copy
let text = try await getSelectedTextByMenuBarActionCopy()
```
