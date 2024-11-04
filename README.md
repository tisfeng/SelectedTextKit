## SelectedTextKit

This is a macOS library that allows you to easily get the selected text.

It's a part of [Easydict](https://github.com/tisfeng/Easydict).

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

### Thanks

Get selected text by menu bar action copy is inspired by [Copi](https://github.com/s1ntoneli/Copi/blob/531a12fdc2da66c809951926ce88af02593e0723/Copi/Utilities/SystemUtilities.swift#L257), thanks for [s1ntoneli](https://github.com/s1ntoneli)'s work.
