# 外部 Agent 资产迁移映射

- 核对日期：2026-09-09。
- 宿主规则来源：Easydict `602c56b24a68d2917f4d9e5ed5180f9f4cbdf91a`。
- 目标初始提交：`40ffa178a5ba5f49d634d76c6a5906005ac83269`。
- 外部资产来源分别见 [tisfeng-skills.md](tisfeng-skills.md) 与
  [fireworks-tech-graph.md](fireworks-tech-graph.md)；双 lock 是当前安装事实。

## 完整资产

六个 `tisfeng/skills` 技能目录、四个 `.codex/agents/*.toml` 均对齐 `v0.3.0` 完整内容，
不保留本地脚本、测试、模型或指令补丁。fireworks 完整对齐独立 commit，锁定 ref 比
Easydict 的 `main` 更精确。所有入口、脚本、测试、references 和资源均纳入核验。

独立上游包含 `assets/icons/cloud/manifest-v1.json`，但 Easydict 当前 tracked tree 缺少该文件。
本次安装器正确带入该运行时依赖，按批准的“完整上游快照”保留，不复制源项目的遗漏。

## 宿主文件映射与适配

| 源或目标路径 | 处理与唯一必要差异 |
| --- | --- |
| `AGENTS.md` | 采用源通用约束与五专题路由；项目介绍、中文治理、公开 README 入口适配 |
| `docs/agents/request-boundary.md` | 与源原文一致，完整保留六项门禁和条件委派 |
| `docs/agents/git-workflow.md` | 保留源交付协议；PR 使用目标动态发现与 neutral，不复制 dev 参数 |
| `docs/agents/build-and-test.md` | 保留审查测试协议；替换为 SwiftPM/示例工程命令和系统权限边界 |
| `docs/agents/development.md` | 原文通用开发规则；适配 SwiftPM 文件归属、最低系统版本、无 Catalog/formatter，排除源专属依赖 |
| `docs/agents/README.md` | 保留生命周期与双 lock 治理；公开文档、中文与无 release-easydict 的目标事实 |
| 五个旧专题 | execution-safety 并入 request-boundary；response-conventions 并入 AGENTS；code-quality/swift-xcode/localization 并入 development，旧文件删除 |
| `.agents/overrides/` | 按新版来源治理删除，不再叠加本地技能规则 |
| `docs/design-docs/agent-documentation-structure.md` | 同步五专题职责及入口定位 |
| `docs/design-docs/external-agent-assets-management.md` | 采用源设计，去除 Easydict 自有发布技能分支 |
| `docs/references/astra-agent-guidance.md` | 仅更新条件 planner 与当前配置引用；不宣称重新调查官方指南 |
| 本目录旧迁移参考 | 保留为 09-06 历史证据，显式指向当前来源 |
| plan/history 模板 | 与源一致，不做无意义改动；本任务新建独立记录 |

## 保留与排除

`.codex/config.toml`、Claude 两个软链接、产品源码、根 README、既有架构与历史提交均保留。
不复制 Easydict 的产品架构、用户指南、Swift 迁移路线图、发布技能与执行历史。

实际验证与交付见 [本任务 history](../histories/2026-09/2026-09-09-external-agent-assets-port.md)。
