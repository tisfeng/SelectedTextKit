# Swift 与 Xcode 规则

## Swift

- 使用 Swift 5.9 或更高版本，并遵守 `Package.swift` 声明的部署目标：macOS 11 和 Mac Catalyst 14。
- 使用 4 空格缩进并匹配周围风格。
- 每个文件聚焦一个主要 class 或 struct；紧密相关的 protocol、简单 model、私有 helper 和辅助 extension 可以保留在同一文件。
- 使用 `// MARK: - ...` 组织 protocol 实现和较长逻辑区域。
- 保留 public API、Objective-C 名称、错误语义、actor isolation、`Sendable` 约束和部署可用性。
- 优先使用 structured concurrency 和明确的 task lifetime；不要为了消除编译器诊断而删除隔离或强制转换。
- 优先使用 typed error，不吞掉调用方可观察的权限、pasteboard 或 AppleScript 错误。

## Package 与 Xcode 边界

- `Sources/SelectedTextKit/` 下的库源码由 SwiftPM 管理，新增或移动文件通常不需要修改 `project.pbxproj`。
- 示例应用及其测试位于 `SelectedTextKitExample.xcodeproj`；修改时保留 target membership、build settings、entitlements 和 scheme 行为。
- 治理 Markdown、plans、histories、references、skills 和 Codex 配置不得加入 Xcode target 或 build phase。
- 不创建仓库不存在的 scheme、test target、formatter 命令或 build setting。

## 测试

- 测试使用 Swift Testing：`import Testing`、`@Test` 和 `#expect`。
- 新回退分支、typed error、pasteboard generation ownership、权限失败、browser 行为和并发边界需要聚焦测试。
- 测试说明和最终验证报告必须标明依赖权限或前台应用的行为。
