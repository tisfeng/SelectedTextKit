# Swift 与 Xcode 代码简化

仅在处理 Swift、SwiftUI、AppKit 或 Xcode 变更时加载本 reference。项目规则和现有代码模式优先。

## Swift

- 遵守声明的 Swift 版本、部署目标、availability 和模块边界。
- 优先使用明确的值语义、访问控制、描述性名称、`guard`、`switch` 和 early return。
- 保留 public API、Objective-C 暴露、typed errors、actor isolation、`Sendable`、取消语义和结果顺序。
- 不要仅为减少文件或行数而合并 protocols、helpers 或函数。
- 避免增加 type erasure、`Any`、force cast 或共享可变状态。

## SwiftUI 与 AppKit

- 保留 view identity、state ownership、data flow、生命周期和平台集成。
- 将副作用放在正确的生命周期边界。
- 检查 task cancellation、重复触发、前台应用状态和 teardown 行为。

## 验证

- 保留 target membership、compiler conditions、resources 和 availability。
- 使用仓库现有构建与测试命令，不创建不存在的 scheme、formatter 或 test target。
- 即使只提供只读简化建议，也要检查相关调用方和测试。
