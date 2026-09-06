---
name: review
description: >
  只读审查本地任务、工作树、commit、range、文件或模块的正确性，并提供有证据的 findings。
---

# 通用代码审查

本 skill 是只读 review 核心。GitHub PR 上下文和 thread 处理由 `review-pr` skill 负责。

## 冻结范围

- 明确目标行为、baseline、最终 snapshot、路径和排除项。
- 审查一次任务时，使用主 Agent 的初始 HEAD 和分层初始变更，将任务工作与用户既有工作分开。
- 审查工作树时，分别检查 staged、unstaged 和相关 untracked 内容。
- 审查 commit 时，解析完整 SHA 并与预期 parent 对比。
- 审查 range 时，明确使用 `A..B` 端点差异还是 `A...B` merge-base 差异。
- 审查文件或模块时，检查必要调用方、依赖和测试。

## 审查重点

关注 correctness、regression、security、data loss、concurrency、lifecycle、错误传播、public API compatibility、deployment availability 和缺失的高价值测试。不要报告仅属偏好的 style 问题，也不要在没有明确触发条件时制造推测性故障。

每条 finding 包含：

- priority；
- 准确路径和位置；
- 触发条件和可观察影响；
- 来自被审 snapshot 的证据；
- 最小 Suggested Fix；
- 聚焦验证方式。

没有 actionable finding 时明确说明，并列出 residual risk 或未执行检查。单独 review 不授权修复、Git mutation 或外部服务动作。
