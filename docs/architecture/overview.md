# SelectedTextKit 架构总览

SelectedTextKit 是一个 Swift Package，通过 Accessibility、AppleScript、菜单操作和模拟键盘快捷键从 macOS 应用获取选中文本。支持 macOS 11 和 Mac Catalyst 14。

## 仓库布局

```text
Sources/SelectedTextKit/
├── Core/                   # 公共入口值、策略和 typed errors
├── TextSelection/          # 策略编排
├── Accessibility/         # Accessibility 取词和菜单访问
├── AppleScript/            # Browser 和系统 AppleScript 支持
├── Pasteboard/             # 临时复制和 pasteboard 恢复
├── AXSwift/                # AXSwift extensions 和菜单 helpers
└── Utilities/              # Logging、timeout 和依赖 extensions

SelectedTextKitExample/      # SwiftUI 示例应用
SelectedTextKitExampleTests/ # Xcode 工程中的 Swift Testing suites
Package.swift                # SwiftPM products、targets 和 dependencies
SelectedTextKitExample.xcodeproj/
```

## 运行时边界

- `SelectedTextManager` 是单个策略或有序策略数组的公共编排边界。
- `AXManager` 负责 Accessibility 取词和菜单项查找。
- `AppleScriptManager` 负责 browser 选中文本脚本，以及快捷键复制使用的临时提示音量控制。
- `PasteboardManager` 负责观察临时复制和恢复 pasteboard。
- `KeySender` 执行模拟复制快捷键，`AXSwift` 提供 Accessibility 基础能力。
- AppKit 集成、Accessibility trust、前台应用状态和共享 pasteboard ownership 都是可观察的系统边界，需要谨慎处理错误和并发。

## 验证边界

最快的库验证是 `swift build --target SelectedTextKit`。示例应用和 `SelectedTextKitExampleTests` 通过 `SelectedTextKitExample.xcodeproj` 构建和测试。准确命令和触发条件见 [`../agents/build-and-test.md`](../agents/build-and-test.md)。

## 文档边界

- 当前 Agent 规则：`../agents/`。
- 设计理由：`../design-docs/`。
- Implementation plans 和 histories：`../exec-plans/` 与 `../histories/`。
- 公开 Package 用法：仓库根目录 `README.md`。
