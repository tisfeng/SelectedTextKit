## 2026-09-06 | 任务：使用 Text Marker 命名常量

**Links:** [Easydict 参考提交](https://github.com/tisfeng/Easydict/commit/06b339b42fb138cc5e7a45742bbf99de02eeab2a)；
[SelectedTextKit PR #10](https://github.com/tisfeng/SelectedTextKit/pull/10)

### 用户请求

参考 Easydict 的对应提交，更新 SelectedTextKit 的 Accessibility Text Marker 实现。

### 变更

- 使用 SDK 提供的 Text Marker attribute 常量替换两个字符串字面量。
- 保留现有 selected-text fallback 顺序、错误处理和 `CFString` 调用形式。

### 设计意图

让 Text Marker 查询与系统定义的符号保持一致，减少字面量漂移风险，同时不扩大
PR #10 的行为范围。

### 验证

- `swift build --target SelectedTextKit`：通过；输出包含既有的未处理 entitlements resource
  warning，以及 `AXError+Custom.swift` 的 Swift 6 import warning。
- `git diff --check`：通过。
- 手动检查：两个命名常量的 CFString 值与被替换字面量一致，fallback 控制流未改变。

### 受影响文件

- `Sources/SelectedTextKit/Accessibility/AXManager.swift`
- `docs/histories/2026-09/2026-09-06-use-text-marker-constants.md`

### 后续事项

- 无。
