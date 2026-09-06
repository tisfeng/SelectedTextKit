# 构建与测试

## 测试范围

- 对行为变化、错误路径、策略回退、pasteboard 所有权、AppleScript 行为和并发边界添加聚焦测试。
- 优先使用确定性测试，避免仅为低价值测试引入生产 hook。
- Browser、Accessibility、pasteboard 和 AppleScript 测试可能依赖本地权限或前台应用；必须明确报告这些环境依赖。
- 扩大验证范围前先诊断失败。

## 项目命令

```bash
# 解析依赖
swift package resolve

# 快速构建库
swift build --target SelectedTextKit

# 构建全部 Swift Package targets
swift build

# 构建示例应用
xcodebuild \
  -project SelectedTextKitExample.xcodeproj \
  -scheme SelectedTextKitExample \
  -destination 'platform=macOS' \
  build

# 运行 Xcode 测试 target
xcodebuild \
  -project SelectedTextKitExample.xcodeproj \
  -scheme SelectedTextKitExample \
  -destination 'platform=macOS' \
  test
```

`Package.swift` 当前没有 SwiftPM test target，因此不能声称 `swift test` 验证了 `SelectedTextKitExampleTests`。

## 验证选择

- 每次仓库变更都运行 `git diff --check`。
- Swift library 变更至少运行 `swift build --target SelectedTextKit`。
- Package manifest 或依赖变更按需运行 `swift package resolve` 和相关构建。
- 示例应用变更运行对应 Xcode build。
- 测试源码变更运行受影响的 Xcode tests。
- 范围广、高风险、公共 API、工程设置或实质性 Swift 变更，即使 diff 较小，也应运行完整相关 build 和 test。
- 仅修改文档、skill 或 Agent 配置时使用静态检查，不要求 Swift 或 Xcode build。

不要在同一 workspace 或 DerivedData 路径并发运行 Xcode 构建。默认位置不可用时使用明确的临时 DerivedData 路径。

## Tester 与 Reviewer 协作

- 有价值的独立测试工作使用 `.codex/agents/tester.toml`；独立实施审查使用 `.codex/agents/reviewer.toml`。
- 给每个子 Agent 提供冻结范围、允许路径、行为预期和当前快照。
- Tester 只能修改分配的测试和 fixture，不修改生产代码或 Git 状态。
- Reviewer 保持只读，并报告有证据的 findings。
- 主 Agent 核验 findings、协调非并发构建、更新 history，并负责最终交付。
