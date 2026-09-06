# Agent 文档与文档治理

本目录存放面向编码 Agent 的长期仓库规则。根目录 [`AGENTS.md`](../../AGENTS.md) 是唯一任务入口和路由；本文件只定义文档边界与生命周期。

## 文档分层

- `docs/agents/`：当前有效的仓库和贡献者工作流规则。
- `docs/architecture/`：当前实现事实和运行时边界。
- `docs/design-docs/`：长期设计决策及其理由。
- `docs/exec-plans/`：多步骤 implementation 的执行计划。
- `docs/histories/`：产生仓库差异的 implementation 任务记录。
- `docs/references/`：精选的外部或跨仓库输入。
- `README.md`：面向用户的公开 Package 文档。

完成计划、历史、参考资料及其中保留的命令属于证据，不是当前指令。只有根 `AGENTS.md` 路由到的现行规则约束当前工作。

## 计划与历史

- 纯 planning 工作只保留在对话中，不创建 active plan。
- 用户授权 implementation 后，架构、跨模块、高风险或其他多步骤工作需要创建 active execution plan。
- 每个最终产生仓库文件差异的 implementation 任务都必须创建或更新一条同任务 history。
- 同一任务的后续轮次复用同一份 plan 和 history。
- 实施完成后，将 plan 移到 `docs/exec-plans/completed/`，并由 history 链接。
- 没有仓库差异的任务不创建空记录。
- 显式提交已有 staged 内容时，不反向要求为无关的既有变更补写 implementation history。

## 维护原则

- 每项详细规则只保留一个权威位置；跨职责使用链接，不复制完整条款。
- 只有新增、删除或重新路由规则文件时才更新根入口。
- 使用仓库相对链接，不提交机器本地绝对路径、秘密、原始日志或私密对话内容。
- 行为变化时，在同一任务中同步源码、测试、架构事实和受影响的公开文档。
- 治理 Markdown、skills、plans、histories 和 references 不是 Xcode 源码或运行时资源。

## Skill 与兼容入口

- 仓库维护的可执行工作流存放在 `.agents/skills/`。
- Skill 只规定已授权工作流的执行方式，不能扩大写入、Git 或外部服务权限。
- 使用 skill 前读取目标 `SKILL.md`，并只加载它明确要求的 references。
- `.claude/CLAUDE.md` 链接根 `AGENTS.md`，`.claude/skills` 链接 `.agents/skills`，让不同 Agent 共用一套规则和技能。
