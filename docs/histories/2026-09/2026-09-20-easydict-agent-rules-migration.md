# 2026-09-20 | 任务：迁移 Easydict Agent 规则

**Links:** [执行计划](../../exec-plans/completed/2026-09/2026-09-20-easydict-agent-rules-migration.md)

### 用户请求

执行已确认的 Easydict Agent 规则迁移方案。

### 变更

- 将入口收敛为 `AGENTS.md` 加三份专题规则：构建测试、编码规范和外部 Skills。
- 从 `tisfeng/skills v0.6.3` 完整同步六个通用 Skill，保留 `fireworks-tech-graph` 的固定
  commit 快照并更新 `skills-lock.json`。
- 删除旧 `.codex/agents/*.toml` 和 `.codex/agents-lock.json`，保留项目权限配置
  `.codex/config.toml`。
- 适配 SelectedTextKit 的 SwiftPM、`SelectedTextKitExample.xcodeproj`、测试目录和
  `PBXFileSystemSynchronizedRootGroup` 工程边界；未修改产品源码或工程文件。

### 设计意图

采用 Easydict 当前的单一 Agent 规则入口和平台无关 Skills，同时只对 SelectedTextKit 的
项目事实做语义适配，不复制 Easydict 的产品或发布规则。

### 验证

- 安装器同源算法独立复算七个 Skill 目录 hash，全部与 lock 一致；`jq -e .`、TOML 解析、
  `bash -n`、Python 编译和 `git diff --check` 通过。
- `git-commit` 19 项、`review` 7 项、`review-pr` 57 项、`submit-pr` 23 项、
  `worktree-rebase-merge` 6 项现有 Skill 测试通过。
- 完成旧路径/旧 custom-agent 路由扫描、Markdown 相对链接和锚点检查，以及只读最终 review。
- 未运行 Xcode build/test：本次仅修改治理文档、Skills 和配置快照，不涉及产品或工程行为。

### 受影响文件

- `AGENTS.md`、`docs/agents/`、相关 design/reference 文档及本任务 plan/history。
- `.agents/skills/` 六个 `tisfeng/skills` 快照和既有 `fireworks-tech-graph` 快照。
- `skills-lock.json`、旧 custom-agent 退役文件。

### 后续事项

- 已按授权创建本地提交；未 push、创建 PR、merge 或修改远程状态。
