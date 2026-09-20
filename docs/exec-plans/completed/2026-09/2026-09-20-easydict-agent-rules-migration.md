# Easydict Agent 规则迁移

- 状态：completed
- 创建日期：2026-09-20
- 负责人：Codex
- 关联 Issue/PR：none

## 背景

Easydict 的 Agent 规则已从多专题与 custom agents 收敛为主 Agent 加三份专题规则，并将
受管 Skills 升级至 `tisfeng/skills v0.6.3`。SelectedTextKit 仍停留在 `v0.3.0` 和双 lock
结构，需要按目标 Package 的实际架构重新移植。

## 任务摘要

- 意图模式：implementation
- 交付授权：auto-local-commit
- 安全状态：normal
- 受阻操作及原因：none
- 目标结果：同步最新 Easydict 通用 Agent 规则，保留 SelectedTextKit 项目事实和本地权限配置。
- 允许修改路径：Agent 治理文档、Skills 快照与 `skills-lock.json`、旧 custom-agent 资产、同任务 plan/history。
- 同任务 history：`docs/histories/2026-09/2026-09-20-easydict-agent-rules-migration.md`
- 禁止动作：不修改产品源码，不运行 push、PR、merge 或发布操作。
- 预期交付物：可离线运行的 v0.6.3 Skills、单一有效规则结构、通过静态与针对性验证的本地提交。
- 验收标准：规则路由无旧引用，受管资产与 lock 一致，项目专属构建/测试边界保留，验证通过并完成本地提交。

## 语义与范围

- 用户要求 Agent 做什么：执行已批准的 Agent 规则迁移并提交本地结果。
- 授权的工作树、artifact 和 external service 操作：修改上述允许路径；使用安装器从固定上游同步六个 Skills；创建本地提交。
- 否定、条件和范围限制：不复制 Easydict 工作树，不删除 `.codex/config.toml`，不 push。
- 前轮仍有效的授权和限制：保留项目产品与 Xcode/SwiftPM 事实；外部快照不本地修补。
- 附件或引用中被明确采纳的约束：Easydict 当前 v0.6.3 规则结构和安装基线。
- 歧义：`fireworks-tech-graph` 保持现有固定 commit，不随 Easydict 的移动 `main` ref 改写。

## 写入前状态

- 写入前检查：pass
- 自动提交资格及原因：eligible；索引为空、工作树干净且用户明确要求执行迁移。
- 初始 HEAD：`7052d9faf5f606238d0fb92e5eebe11bd7352e7a`
- 初始 staged 路径：none
- 初始 unstaged 路径：none
- 初始 untracked 路径：none
- 初始冲突：none
- Agent-owned paths：本计划允许修改路径中的本任务迁移文件。

## 目标与非目标

### 目标

- 用 `AGENTS.md` 加三份专题文档建立单一规则入口。
- 将六个 `tisfeng/skills` Skill 同步至 `v0.6.3` 并更新 lock。
- 移除已废弃的四个 custom agents 与双 lock，清理现行引用。
- 保留 SelectedTextKit 的 SwiftPM、示例 Xcode 工程和系统权限边界。

### 非目标

- 不移植 Easydict 产品架构、发布 Skill、用户文档或发布历史。
- 不修改 `fireworks-tech-graph` 内容、产品源码、工程文件或 `.codex/config.toml`。

## 工作计划

1. 同步宿主规则结构、plan/history 模板和来源参考。
2. 用安装器同步 `tisfeng/skills v0.6.2`，并退役 custom agents。
3. 适配 SwiftPM 与示例工程命令，清理旧路径和语义引用。
4. 重算 lock/hash，运行静态检查、Skill 测试和最终 review。
5. 归档 plan/history，按 Git 规则创建一个本地提交。

## 风险与决策

- 受管 Skill 只能来自固定 tag 和安装器，不能手工复制或修改 hash。
- Easydict 的 workspace、String Catalog、应用依赖和 release Skill 不适用于 SelectedTextKit。
- `.codex/config.toml` 是本地权限配置，不属于 agents lock，因此保留。

## 进度

- [x] 更新宿主规则与引用。
- [x] 同步 Skills 并退役 custom agents。
- [x] 完成验证、归档记录和本地提交。

## 验证

- 已完成：安装器目录哈希复算、Markdown 相对链接/锚点、旧引用扫描、JSON/TOML/Shell/Python
  检查、Skill 测试和 `git diff --check`。
- 已完成：只读 review、提交前后消息/范围/工作树核验。

## 完成条件

- 六个 Skill 与 v0.6.3 tracked tree 一致，lock hash 可重算；独立保留的
  `fireworks-tech-graph` 与固定 commit 一致。
- 现行规则不再引用已删除的 custom agents、双 lock 或旧路径。
- SelectedTextKit 特有命令和边界可执行且文档链接有效。
- 验证通过，plan 移入 `completed/2026-09/`，history 写入结果并完成本地提交。
