---
name: worktree-rebase-merge
description: >
  在明确授权后，通过提交 source、rebase 到已验证 target，并从 target worktree merge 来完成 worktree 变更。
---

# Worktree Rebase 与 Merge

只有用户明确授权必要的 commit 和 integration 动作时才使用本工作流。除非 push 另获授权，否则绝不 push。所有 commit 使用 `git-commit` skill。

## Target 解析

- 用户指定 target branch 时使用该分支。
- 否则优先选择 `origin`；没有 `origin` 且只有一个 remote 时使用该 remote，并通过 `git ls-remote --symref <remote> HEAD` 查询实时默认分支。
- 实时解析失败时，不静默信任缓存的 `refs/remotes/<remote>/HEAD`；报告候选并要求用户指定 target。
- 要求解析出的本地 target branch 存在。

## 预检

- 记录 source HEAD、branch、分层状态和 worktree list。
- 处于 detached HEAD 时，在不暂存的情况下根据已授权任务推导 Conventional branch name，验证后创建或复用不冲突的分支，并且不移动既有 refs。
- 查找 checkout 到 target branch 的 worktree。优先使用干净的既有 target worktree；不存在时，在仓库外创建临时 target worktree 进行最终 merge。
- 不修改、stash、clean 或 commit 脏 target worktree。source 获准提交且干净后暂停，并报告脏 target。

## Source Commit

- 保留用户 staged 范围。
- index 为空时，只暂存用户明确授权的路径。
- 使用 `git-commit` 完成信息校验和提交报告。
- Rebase 前要求 source worktree 干净。

## Rebase

Rebase 前检查：

```bash
git log --oneline <target>..<source>
git diff --stat <target>...<source>
```

集成范围包含无关或异常宽泛历史时停止。从 source worktree 运行 `git rebase <target>`。出现冲突时按语义解决，只 stage 已解决文件；遇到不安全产品决策时停止。完成后要求 source 干净，运行 `git diff --check <target>...HEAD` 和项目要求的验证。

## Merge

- 再次确认 target worktree 干净。
- 从真实 target worktree 运行普通 `git merge <source>`。除非用户要求，不强制 squash、`--no-ff`、再次 rebase 或 push。
- 不使用 `git update-ref` 或 `git branch -f` 更新 target。
- 临时 target worktree 只在 merge 成功后删除；仍有冲突时保留并报告路径。

报告 source/target branches、完整 SHAs、target worktree 路径、集成 range、merge 模式、验证、最终状态和 push 状态。
