# 执行安全与变更门禁

本文定义何时可以改变仓库或 artifact 状态。任务模式见 [`request-boundary.md`](request-boundary.md)，Git 交付见 [`git-workflow.md`](git-workflow.md)，文档生命周期见 [`README.md`](README.md)。

## 核心规则

- Planning 保持只读。
- Implementation 必须有明确授权，并且只修改实现请求所必需的路径。
- 保留无关的 staged、unstaged、untracked 和冲突内容。
- 按风险选择验证，并区分实际执行的检查与未运行检查。
- 任何产生仓库差异的 implementation 都必须有一条同任务 history。

## 首次写入前

记录：

1. 初始 `HEAD`；
2. staged、unstaged、untracked 和冲突路径；
3. 任务允许路径和 Agent-owned paths；
4. 预期 history，以及必要时的 execution plan；
5. 禁止的 Git、外部服务和破坏性动作。

如果既有变更与任务重叠，检查分层 diff 并保留其内容。不能仅凭路径名推断归属。

## Protected 状态

当范围无法分离、缺少必要授权、破坏性影响不明确，或仓库状态使安全交付前提失效时，将受影响操作设为 protected。报告具体受阻动作与证据；仍可继续只读检查或其他独立且已授权的工作。

不得使用破坏性命令、覆盖用户工作，或扩大路径来绕过阻塞。

## 变更后

- 检查最终分层 diff 和 untracked 文件。
- 确认只有允许路径发生变化。
- 创建或更新同任务 history。
- 运行必要的静态检查、构建和测试。
- 准确报告失败、环境阻塞和未验证范围。
- 除非 stage 或 commit 已获明确授权，否则保持 index 不变。
