---
name: submit-pr
description: >
  从干净且已提交的 checkout 规划或创建 GitHub PR，并校验 repository、branch、fork、title、body、push 和幂等规则。
---

# 提交 Pull Request

只有用户明确要求规划或创建 GitHub PR 时才使用本 skill。它不负责 review、merge、关闭 issue 或创建 commit。

运行任一模式前读取 [`references/workflow.md`](references/workflow.md)。

## 模式

- `plan`：只读检查拓扑和正文。
- `apply`：取得明确 PR 创建授权后，fetch 准确 base、push 冻结 head SHA、创建或复用 PR，并进行验证。

```bash
python3 .agents/skills/submit-pr/scripts/submit_pr.py plan --help
python3 .agents/skills/submit-pr/scripts/submit_pr.py apply --help
```

## 质量要求

- 标题：`type(scope): subject`。
- 任务分支：`<type>/<kebab-case-summary>`。
- 正文按以下顺序包含：
  1. `变更说明 / Summary`
  2. `关联 Issue / Linked Issues`
  3. `验证 / Verification`
  4. `截图 / Screenshots`
- 保留仓库 PR template 中有意义的提示和 checklist。
- 非 UI 变更的截图段使用 `N/A`。
- UI 变更提醒用户在 GitHub 补充截图；不得编造或静默省略。

动态发现实际 base repository、默认 branch、base remote、head remote 和 fork 关系，不硬编码其他仓库拓扑。

执行 `apply` 前要求工作树干净，并检查完整 `base...HEAD` commit 和 diff range 是否与任务一致。冻结 head SHA。Helper 必须使用准确 refspec push 该 SHA，并校验创建或复用的 PR。幂等检查发现不匹配时不得创建第二个 PR。

报告 PR URL、number、base/head 身份、冻结 SHA、branch/push/PR actions、draft 状态、issue policy、截图需要和最终验证。
