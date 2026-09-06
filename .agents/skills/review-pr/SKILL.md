---
name: review-pr
description: >
  准备并审查准确的 GitHub PR head、真实 base diff、完整 review threads、关联上下文和 CI；远程 mutation 默认关闭。
---

# PR Review 工作流

先读取 [`../review/SKILL.md`](../review/SKILL.md)。本 skill 增加 GitHub 身份、checkout 准备、thread 收集、CI 和最终刷新。

## 接受的引用

- `https://github.com/<owner>/<repo>/pull/<number>`
- `<owner>/<repo>#<number>`
- 当前 checkout 能唯一确定仓库时的 PR number

## 准备

用户明确要求使用本 PR review 工作流时，授权脚本进行安全的本地准备，但不授权产品修复、latest-base 集成、push、comment、approve 或 thread resolve。

```bash
bash .agents/skills/review-pr/scripts/prepare-pr-branch.sh <pr-ref>
```

只有用户要求隔离或并行 review 时才使用 `--worktree`。只有用户明确要求 latest-base 集成或冲突解决时才使用 `--merge-latest`；该选项不授权 push。

核对准备后 checkout 的完整 `HEAD` 等于 GitHub `headRefOid`，branch/upstream 符合预期，且工作树干净。以 PR 实际 `baseRefName` 的真实 merge-base diff 为审查范围，不硬编码 `main` 或 `dev`。

## 证据

- 阅读 PR metadata、正文、commits、changed files、关联 issues 和必要代码上下文。
- 检查 CI checks 和相关 logs，包括 skipped 或 cancelled jobs。
- 收集全部分页 review threads：

```bash
python3 .agents/skills/review-pr/scripts/review_threads.py collect \
  --repo OWNER/REPO \
  --pr NUMBER
```

- 评估每条 `isResolved == false` thread，包括 outdated threads、bots 和 replies。
- 已有 thread 评估与新增独立 findings 分开。
- 绿色 CI 和 outdated 标记都不能证明问题已修复。

## 可选 Thread Resolve

除非用户明确授权，否则禁用 thread resolve。准备或应用 resolution plan 前读取 [`references/thread-resolution.md`](references/thread-resolution.md)。Resolve 不得附带 reply、approve、close 或 push。

## 最终刷新

报告前立即刷新 PR head、state、checks 和完整 thread 集合。如果 head、comments、replies 或 thread state 发生变化，重新阅读受影响代码后再定稿。

报告被审完整 SHA、base、范围、CI、未解决 thread 评估、新 findings、未执行检查和本地准备动作。除非用户要求，或 review 确有需要且取得授权，否则不运行 `xcodebuild`。
