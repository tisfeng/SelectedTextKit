# SelectedTextKit - Refactored API

## 概述

SelectedTextKit 已经重构为更清晰的面向对象架构，提供了更好的代码组织和 Objective-C 兼容性。

## 新的架构

### 核心管理类

1. **SelectedTextManager** - 主要的选中文本管理类
2. **AccessibilityManager** - 处理无障碍功能相关操作
3. **PasteboardManager** - 处理剪贴板相关操作

### 主要特性

- ✅ 面向对象的设计，避免全局函数污染
- ✅ 更好的 Objective-C 兼容性
- ✅ 保持向后兼容性（Legacy API）
- ✅ 更清晰的代码组织和维护性
- ✅ 线程安全的设计

## 新 API 使用方法

### Swift 使用

```swift
import SelectedTextKit

// 获取选中文本（推荐方式）
let manager = SelectedTextManager.shared

do {
    if let text = try await manager.getSelectedText() {
        print("选中的文本: \(text)")
    }
} catch {
    print("获取文本失败: \(error)")
}

// 复制并粘贴文本
await manager.copyTextAndPaste("Hello World")

// 通过特定方法获取选中文本
if let text = try await manager.getSelectedTextByMenuBarActionCopy() {
    print("通过菜单复制获取的文本: \(text)")
}
```

### Objective-C 使用

```objc
@import SelectedTextKit;

// 获取选中文本
STKSelectedTextManager *manager = [STKSelectedTextManager shared];

[manager getSelectedTextWithCompletionHandler:^(NSString * _Nullable text, NSError * _Nullable error) {
    if (text) {
        NSLog(@"选中的文本: %@", text);
    }
}];

// 复制并粘贴文本
[manager copyTextAndPaste:@"Hello from Objective-C" preservePasteboard:YES];
```

## 向后兼容性

现有代码无需修改，Legacy API 仍然可用：

```swift
// 这些全局函数仍然可用（但建议迁移到新 API）
if let text = try await getSelectedText() {
    print("选中的文本 (Legacy): \(text)")
}

await copyTextAndPaste("Legacy API 示例")
```

## 迁移指南

### 从 Legacy API 迁移到新 API

| Legacy API | 新 API |
|------------|--------|
| `getSelectedText()` | `SelectedTextManager.shared.getSelectedText()` |
| `getSelectedTextByAXUI()` | `SelectedTextManager.shared.getSelectedTextByAXUI()` |
| `getSelectedTextByMenuBarActionCopy()` | `SelectedTextManager.shared.getSelectedTextByMenuBarActionCopy()` |
| `copyTextAndPaste(_:preservePasteboard:)` | `SelectedTextManager.shared.copyTextAndPaste(_:preservePasteboard:)` |

### 优势

1. **更好的命名空间管理** - 避免全局函数污染
2. **更强的类型安全** - 面向对象的设计提供更好的类型推断
3. **更好的 IDE 支持** - 自动完成和文档更加完善
4. **更容易测试** - 可以轻松创建 mock 对象
5. **更好的 Objective-C 互操作性** - 专门优化的 @objc 接口

## 类说明

### SelectedTextManager

主要的管理类，提供获取选中文本的各种方法。

**主要方法：**
- `getSelectedText()` - 自动选择最佳方法获取选中文本
- `getSelectedTextByAXUI()` - 通过无障碍 API 获取选中文本
- `getSelectedTextByMenuBarActionCopy()` - 通过菜单栏复制操作获取选中文本
- `getSelectedTextByShortcutCopy()` - 通过快捷键复制获取选中文本
- `copyTextAndPaste(_:preservePasteboard:)` - 复制文本并粘贴

### AccessibilityManager

处理所有与 macOS 无障碍功能相关的操作。

### PasteboardManager

管理剪贴板相关的操作，包括临时保护剪贴板内容。

## 注意事项

- 所有异步方法都使用 `async/await`
- 需要系统无障碍权限才能正常工作
- 保持对现有 Legacy API 的完全向后兼容
- 新的 API 提供更好的错误处理和类型安全
