# 移植外部 Agent 资产治理

- 状态：completed
- 创建日期：2026-09-09
- 意图模式：implementation
- 交付授权：auto-local-commit；禁止 push 和远程修改。
- 安全状态：normal

## 目标与范围

按用户批准的方案，对齐 Easydict `602c56b24a68d2917f4d9e5ed5180f9f4cbdf91a` 的
五专题治理规则。六个通用技能与四个子代理采用 `tisfeng/skills v0.3.0`
（`ccc74f119f61d672cfd0cb57c07a259b7bc78614`），fireworks 独立固定到
`31fea364eda5f1852b1175f3d9e29ea31d22dcb4`。不升级 v0.3.1，不删减上游资产。

允许路径：`AGENTS.md`、`docs/agents/`、`.agents/skills/`、`.agents/overrides/`、
`.codex/agents/`、双 lock 文件，以及相关 `docs/design-docs/`、`docs/references/`、
本任务计划与 history。不修改产品代码、公开 README、`.codex/config.toml`、Claude
软链接、历史提交或源仓库。

## 初始状态与门禁

- 初始 HEAD：`40ffa178a5ba5f49d634d76c6a5906005ac83269`。
- staged、unstaged、untracked、冲突均为空。
- 用户“执行”明确授权以上方案；初始自动提交资格满足。
- Agent-owned paths 为上述范围内本次实际变更；交付前冻结精确集合。
- history：`docs/histories/2026-09/2026-09-09-external-agent-assets-port.md`。

## 步骤与风险

1. 文档按源原文同步并逐项记录必要项目适配。
2. 使用固定版本安装器同步完整技能/子代理并生成双 lock。
3. 清理被替代规则与 overlay，更新来源及结构说明，旧迁移记录明确标为历史。
4. 核对完整树、lock 哈希、静态链接和相关测试；独立审查最终快照。
5. 归档计划，串行交付；新增 git-delivery 仅在当轮配置未被发现时允许严格 bootstrap。

首次接管旧文件仅在冻结并确认目标后覆盖；失败保留现场，不手改 lock 哈希。
保持中文宿主文档与上游原始语言、模型和完整指令。项目适配不得改变通用技能。

## 验证与完成条件

- 完整快照等于锁定来源，所有项目差异有说明。
- JSON/TOML、Markdown 链接、软链接、旧现行引用及 git diff --check 通过。
- 运行相关技能自动测试，区分环境跳过与实际失败。
- 不运行 Swift/Xcode 构建；新会话运行时发现未验证时明确报告。
- 验证结果与最终内容一致后归档并本地提交，不推送。

## 完成记录

文档与完整外部快照迁移完成。六技能 23 文件、四个子代理及 fireworks 140 文件与锁定源
一致。208 项测试中 203 通过、5 条件跳过；静态检查和独立审查通过，未发现阻塞 finding。
源码、公开 README、项目配置和 Claude 软链接未改。跳过项与未验证的新会话发现见 history。
完成内容验证后归档；本地 Git 交付作为串行收尾执行，实际提交以 Git 和用户回执为准。
