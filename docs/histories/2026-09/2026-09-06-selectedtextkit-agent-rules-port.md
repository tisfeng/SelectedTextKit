## 2026-09-06 | 任务：移植 Agent 规则与 Skills

**Links：**[`completed execution plan`](../../exec-plans/completed/2026-09-06-selectedtextkit-agent-rules-port.md)

### 用户请求

将 Easydict 的 Agent 文档规则、Codex 配置和可复用 skills 移植到 SelectedTextKit，按批准方案执行，并通过 Claude-compatible 软连接维护一套共享规则。用户随后明确要求保留 Easydict 风格的中文文档。

### 变更

- 将根规则改为简洁路由，并新增 Agent、架构、设计、plan、history 和 reference 文档分层。
- 新增 planning、review 和 testing 的项目 Codex 角色。
- 新增六个通用仓库 skills 及其必要 helper scripts、references 和 tests。
- 新增 `.claude/skills` 软连接，并保留既有 `.claude/CLAUDE.md` 软连接。
- 保持项目持久化网络访问关闭，并要求每个 Git 或远程 mutation 获得明确授权。
- 将本次迁移的治理文档、skills 和 Agent 配置统一改为中文；代码注释保留英文。

### 设计意图

本次移植采用 Easydict 的唯一入口和知识分层，但不复制产品专属行为。SelectedTextKit 保留自身 Swift Package、示例 Xcode 工程、`main` 分支拓扑、中文治理文档、简体中文用户沟通和显式 Git 授权边界。

### 验证

- `git diff --check`：通过。
- 新文件 whitespace 和 final newline 验证：通过。
- TOML 解析：4 个文件通过。
- Markdown 相对链接验证：通过。
- Skill 结构验证：6 个 skills 通过。
- Shell 和 Python 语法验证：通过。
- git-commit 单元测试：19 项通过。
- review-pr 单元测试：24 项通过。
- submit-pr 单元测试：17 项通过。
- Claude 软连接验证：通过。
- Swift 和 Xcode builds：未运行，因为产品代码没有变化。

### 受影响文件

- `AGENTS.md`
- `.agents/skills/`
- `.codex/`
- `.claude/skills`
- `docs/agents/`
- `docs/architecture/`
- `docs/design-docs/`
- `docs/exec-plans/`
- `docs/histories/`
- `docs/references/`

### 后续事项

- 只有工作流确实需要且用户明确授权时，才考虑启用 `.codex/config.toml` network access。
- 当前未执行 stage 或 commit；现有 index 保持不变。
