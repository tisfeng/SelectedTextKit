# Git 工作流

本文规定 Git 状态保护与交付。请求语义和变更安全分别见 [`request-boundary.md`](request-boundary.md) 和 [`execution-safety.md`](execution-safety.md)。

## 安全规则

- 保留无关的 staged、unstaged、untracked 和冲突内容。
- 除非用户明确授权对应动作，或明确调用包含该动作的工作流，否则不执行 stage、commit、push、pull、merge、rebase、stash、switch branch、添加 remote 或重写历史。
- 执行已授权的远程或历史变更动作前，检查 remote 身份和 commit 关系。
- 每个 commit 保持原子性，使用 Angular-style 信息：`type(scope): subject`。
- 任务分支使用 Conventional 格式：`<type>/<kebab-case-summary>`。

## 暂存与提交

- 显式本地提交使用 [`.agents/skills/git-commit/SKILL.md`](../../.agents/skills/git-commit/SKILL.md)。
- 已有 staged 内容时，将原始 staged patch 视为完整提交范围。
- index 为空时，只有用户明确授权暂存并指定或清楚表达目标路径后才能运行 `git add`。
- 禁止将 `git add .` 作为隐式回退。
- 提交后报告完整 SHA、实际提交信息、剩余工作树状态和 push 状态。

## Pull Request

- 只有用户明确要求创建或提交 PR 时才使用 `.agents/skills/submit-pr/SKILL.md`。
- 动态发现仓库当前默认分支和 remote 拓扑，不硬编码其他仓库的 branch 或 remote 参数。
- PR review 使用 `.agents/skills/review-pr/SKILL.md`。
- PR review 默认只读；resolve thread、发布评论、approve、push 或关闭操作都需要明确授权。
