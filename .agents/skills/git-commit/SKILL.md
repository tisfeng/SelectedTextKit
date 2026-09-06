---
name: git-commit
description: >
  仅根据明确授权的 staged 内容创建 Angular-style 本地提交，校验提交信息，报告准确结果，并且绝不 push。
---

# Git 提交流程

根据 staged patch 创建一个准确的本地 commit。本 skill 不提供暂存授权，也不执行 push。

## 必需流程

1. 读取 `git status`、原始 staged patch、当前分支和最近十条 commits。
2. staged patch 为空时停止。只有用户另外明确授权准确暂存范围后才 stage 文件。
3. staged 路径超出用户请求范围时，保留 index 并报告冲突。
4. 将原始 staged patch 作为 commit 内容的唯一权威来源。
5. 先起草英文信息；非英语用户还需要在英文区块前加入含义一致的本地语言区块。
6. 除非用户要求只预览或先确认，否则依次校验信息、创建 commit、校验实际 commit 并报告结果。

使用以下 staged patch 命令：

```bash
GIT_PAGER=cat git --no-pager diff --staged \
  --no-ext-diff --no-textconv --unified=5
```

## 提交信息契约

每个语言区块使用以下结构：

```text
type(scope): subject

说明背景或动机的段落。

说明主要变更的段落。

说明结果或影响的段落。
```

- 使用范围最窄且准确的 Angular type 和 scope。
- 标题不超过 80 个字符。
- 英文 subject 使用小写祈使式摘要，结尾不加句号。
- 每个语言区块恰好包含三个正文段落。
- 本地语言和英文区块的含义与顺序必须一致。
- 双语区块之间使用一个空行、严格 70 个连字符和另一个空行。
- 只有不兼容变更才使用 `!` 和最终 `BREAKING CHANGE:` footer。

将实际信息写入 `commit_message.txt`，然后校验：

```bash
python3 .agents/skills/git-commit/scripts/validate-commit-message.py \
  --file commit_message.txt \
  --mode english
```

双语信息使用 `--mode bilingual`。运行 `git commit -F commit_message.txt` 后，校验实际 commit：

```bash
python3 .agents/skills/git-commit/scripts/validate-commit-message.py \
  --commit <full-commit-sha> \
  --expected-file commit_message.txt \
  --mode <english-or-bilingual>
```

只有提交后校验成功才删除 `commit_message.txt`。提交后校验失败时不得自动 amend。

## Type 指南

- `feat`：新增用户可见行为
- `fix`：修复缺陷或回归
- `docs`：只修改文档
- `style`：不改变行为的格式修改
- `refactor`：不改变行为的内部结构调整
- `perf`：性能改进
- `test`：只修改测试
- `build`：依赖或构建配置
- `ci`：持续集成工作流
- `chore`：其他维护工作
- `revert`：回滚既有变更

## Branch Name Guidance

其他已授权工作流需要任务分支名时，在不暂存的情况下检查任务和只读 diff，再推导 `<type>/<kebab-case-summary>`。本指南不授权创建分支或其他 Git mutation。

## 提交后报告

收集完整 SHA、实际提交信息、当前分支、最终工作树状态，并运行：

```bash
python3 .agents/skills/git-commit/scripts/commit-change-stats.py <full-sha>
```

报告总计、代码和文档文本变更，以及是否仍有未提交内容。明确说明没有 push。只有实际 commit 和提交信息校验都通过后才能报告成功。
