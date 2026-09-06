# 将 Easydict Agent 规则移植到 SelectedTextKit

- 状态：completed
- 创建日期：2026-09-06
- 负责人：Codex
- 关联 Issue 或 PR：none

## 背景

SelectedTextKit 原本只有一份简短的根规则和 Claude 链接，没有分层 Agent 文档、项目 Codex 角色、仓库 skills、执行计划与 history 生命周期或架构说明。用户要求从 Easydict 进行语义移植，并批准了适配当前 Package 的方案。

## 任务契约

- 模式：implementation
- 交付授权：none
- 安全状态：normal
- 目标结果：为 Codex 和 Claude-compatible Agent 建立一套共享的仓库规则和 skill 系统。
- 允许路径：`AGENTS.md`、`.agents/`、`.codex/`、`.claude/skills` 和 `docs/`。
- 同任务 history：`docs/histories/2026-09/2026-09-06-selectedtextkit-agent-rules-port.md`
- 禁止动作：stage、commit、push、修改产品代码、恢复用户删除的 `.claude/settings.local.json`，以及启用未经授权的网络访问。

## 初始状态

- 初始 HEAD：`8914f64a3616b548ddbe05cd3227c57d704af8cf`
- 初始 staged 路径：none
- 初始 unstaged 路径：用户删除的 `.claude/settings.local.json`
- 初始 untracked 路径：none
- 初始冲突：none
- Agent-owned paths：`AGENTS.md`、`.agents/`、`.codex/`、`.claude/skills` 和 `docs/`

## 目标

- 保持 `AGENTS.md` 为唯一简洁任务入口。
- 分离现行规则、架构、设计理由、plans、histories、references、Codex 角色和可复用 skills。
- 保留 SelectedTextKit 的 SwiftPM、Xcode、测试、语言和 Git 边界。
- 通过 Claude-compatible 软连接共享 skills。
- 保留 helper scripts 及其单元测试覆盖。

## 非目标

- 不复制 Easydict 的 release、localization、公开 user-doc、migration、assets 或产品专属规则。
- 不重复引入全局已经可用的绘图 skill。
- 不修改源码、测试、Package metadata 或 Xcode 工程。
- 不执行 stage、commit、push 或 GitHub mutation。

## 已完成工作

1. 将根规则改为简洁任务路由。
2. 新增仓库规则、架构、设计、计划、历史和参考资料分层。
3. 新增 planner、reviewer 和 tester Codex 配置。
4. 新增六个通用 skills 以及选择性 helper scripts 和 tests。
5. 将 review fixtures 适配到 SelectedTextKit，并让 submit-pr tests 不依赖仓库 PR template。
6. 新增 `.claude/skills -> ../.agents/skills`。
7. 因为没有单独授权持久化网络访问，项目级 Codex network access 保持关闭。
8. 根据用户后续纠正，将本次迁移的规则和文档从英文统一改为中文；代码注释继续使用英文。

## 验证

- `git diff --check`：最终分层 diff 通过。
- 新文件 trailing whitespace 和 final newline 检查：46 个文本文件通过。
- TOML 解析：4 个文件通过。
- Markdown 相对链接：31 个文件通过。
- Skill front matter：6 个 skills 通过。
- Shell 和 Python 语法检查：通过。
- git-commit tests：19 项通过。
- review-pr tests：24 项通过。
- submit-pr tests：17 项通过。
- 软连接检查：两个 Claude 链接都指向权威目标。
- Swift 和 Xcode builds：未运行，因为没有产品代码或工程变更。

## 完成条件

- [x] 所有计划中的规则层均已创建，并按用户最终要求使用中文。
- [x] 使用 SelectedTextKit 构建和架构事实替换 Easydict 产品假设。
- [x] 通用 helper tests 通过。
- [x] 用户删除内容保持不变。
- [x] 未执行 stage、commit、push 或产品代码修改。
