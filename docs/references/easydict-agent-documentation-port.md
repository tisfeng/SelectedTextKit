# Easydict Agent 文档移植参考

## 来源与决定

- 源仓库：Easydict。
- 源提交：`a408afe0db85a9f29722561aa445bccd1b5d0244`。
- 核对日期：2026-09-06。
- 原参考基线：`608d1f18c416d02338aaa7cf3eb13299f89c9740`；本次相关治理路径与该基线一致。
- 首次迁移提交：`b0e75efd4101eef78fdee7b1bcb23ac150b5e309`；其过度精简由本轮纠正。
- 用户批准：完整保留通用规则和技能，只适配必要项目事实；submit-pr 测试使用内置示例模板。

本文是来源和验收证据，不是独立的执行规则。恢复 implementation 自动本地交付、
PR review 证据驱动线程维护及网络配置是用户批准方案的一部分；实际执行仍服从
有效用户指令、工作流条件和运行环境权限。

## 逐文件映射

下表源与目标路径相同。“原样”包含正文、示例、固定输出契约和资源；不以行数缩减
为目标。执行权限也与源文件核对。

| 源／目标相对路径 | 处理 | 理由与允许差异 |
| --- | --- | --- |
| `.agents/overrides/README.md` | 原样保留 | 内容与源文件一致。 |
| `.agents/overrides/fireworks-tech-graph/layout.md` | 必要适配 | 仅替换 overlay 的项目名称。 |
| `.agents/skills/code-simplifier/SKILL.md` | 原样保留 | 内容与源文件一致。 |
| `.agents/skills/code-simplifier/references/swift-xcode.md` | 原样保留 | 内容与源文件一致。 |
| `.agents/skills/git-commit/SKILL.md` | 原样保留 | 内容与源文件一致。 |
| `.agents/skills/git-commit/scripts/commit-change-stats.py` | 原样保留 | 内容与源文件一致。 |
| `.agents/skills/git-commit/scripts/validate-commit-message.py` | 原样保留 | 内容与源文件一致。 |
| `.agents/skills/git-commit/tests/test_commit_change_stats.py` | 原样保留 | 内容与源文件一致。 |
| `.agents/skills/git-commit/tests/test_validate_commit_message.py` | 原样保留 | 内容与源文件一致。 |
| `.agents/skills/review-pr/SKILL.md` | 原样保留 | 内容与源文件一致。 |
| `.agents/skills/review-pr/references/thread-resolution.md` | 原样保留 | 内容与源文件一致。 |
| `.agents/skills/review-pr/scripts/prepare-pr-branch.sh` | 原样保留 | 内容与源文件一致。 |
| `.agents/skills/review-pr/scripts/review_threads.py` | 原样保留 | 内容与源文件一致。 |
| `.agents/skills/review-pr/tests/test_prepare_pr_branch.py` | 原样保留 | 内容与源文件一致。 |
| `.agents/skills/review-pr/tests/test_review_threads.py` | 原样保留 | 内容与源文件一致。 |
| `.agents/skills/review/SKILL.md` | 原样保留 | 内容与源文件一致。 |
| `.agents/skills/submit-pr/SKILL.md` | 原样保留 | 内容与源文件一致。 |
| `.agents/skills/submit-pr/agents/openai.yaml` | 原样保留 | 内容与源文件一致。 |
| `.agents/skills/submit-pr/references/workflow.md` | 原样保留 | 内容与源文件一致。 |
| `.agents/skills/submit-pr/scripts/submit_pr.py` | 原样保留 | 内容与源文件一致。 |
| `.agents/skills/submit-pr/tests/test_submit_pr.py` | 必要适配 | 唯一测试适配：仓库文件模板改为测试内置示例，断言与运行脚本不变。 |
| `.agents/skills/worktree-rebase-merge/SKILL.md` | 原样保留 | 内容与源文件一致。 |
| `.codex/agents/planner.toml` | 原样保留 | 内容与源文件一致。 |
| `.codex/agents/reviewer.toml` | 原样保留 | 内容与源文件一致。 |
| `.codex/agents/tester.toml` | 原样保留 | 内容与源文件一致。 |
| `.codex/config.toml` | 原样保留 | 内容与源文件一致。 |
| `AGENTS.md` | 必要适配 | 项目介绍、README、发布路由和中文规则；保留全部通用路由与行为。 |
| `docs/agents/README.md` | 必要适配 | 公开入口改为根 README；中文治理；省去专属 release，PR 参数由目标仓库发现。 |
| `docs/agents/build-and-test.md` | 必要适配 | 示例工程与测试路径、SwiftPM 命令、真实权限依赖；不假定已安装 xcbeautify/formatter。 |
| `docs/agents/code-quality.md` | 必要适配 | 保留通用全文，补充当前仓库语言要求。 |
| `docs/agents/execution-safety.md` | 原样保留 | 内容与源文件一致。 |
| `docs/agents/git-workflow.md` | 必要适配 | 只替换源仓库专属 PR 参数；目标仓库动态发现拓扑，使用通用 neutral 策略。 |
| `docs/agents/localization.md` | 必要适配 | 条件式说明当前没有 Catalog；不引用 Easydict 翻译指南，保留通用本地化规则。 |
| `docs/agents/request-boundary.md` | 原样保留 | 内容与源文件一致。 |
| `docs/agents/response-conventions.md` | 必要适配 | 用户明确指定中文治理与英文代码注释，上游镜像保留原文。 |
| `docs/agents/swift-xcode.md` | 必要适配 | SwiftPM/示例工程路径、部署可用性；移除未使用的 SFSafeSymbols/Alamofire/Defaults；补充实际测试边界。 |
| `docs/architecture/README.md` | 必要适配 | 链接当前已有的 selected-text-flow.md。 |
| `docs/design-docs/README.md` | 必要适配 | 项目名称。 |
| `docs/design-docs/agent-documentation-structure.md` | 必要适配 | 项目名称、日期、根 README 入口与批准的本地适配说明。 |
| `docs/exec-plans/README.md` | 必要适配 | 去掉不存在的 Swift migration 路线图例外；中文治理要求。 |
| `docs/exec-plans/templates.md` | 原样保留 | 内容与源文件一致。 |
| `docs/histories/README.md` | 必要适配 | 中文治理要求。 |
| `docs/histories/template.md` | 原样保留 | 内容与源文件一致。 |
| `docs/references/README.md` | 必要适配 | 引用本次 Easydict 来源与当前项目名称。 |
| `docs/references/astra-agent-guidance.md` | 必要适配 | 项目名称；省去未移植的 release issue-followup 场景。 |
| `.agents/skills/fireworks-tech-graph/LICENSE` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/README.md` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/README.zh.md` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/SKILL.md` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/agentloop-core.svg` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/agents/openai.yaml` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/fixtures/agent-memory-types-style4.json` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/fixtures/api-flow-style7.json` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/fixtures/mem0-style1.json` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/fixtures/microservices-style3.json` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/fixtures/multi-agent-style5.json` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/fixtures/system-architecture-style6.json` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/fixtures/tool-call-style2.json` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/package.json` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/references/icons.md` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/references/style-1-flat-icon.md` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/references/style-2-dark-terminal.md` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/references/style-3-blueprint.md` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/references/style-4-notion-clean.md` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/references/style-5-glassmorphism.md` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/references/style-6-claude-official.md` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/references/style-7-openai.md` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/references/style-diagram-matrix.md` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/references/svg-layout-best-practices.md` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/scripts/README.md` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/scripts/generate-diagram.sh` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/scripts/generate-from-template.py` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/scripts/test-all-styles.sh` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/scripts/validate-svg.sh` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/templates/agent-architecture.svg` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/templates/architecture.svg` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/templates/comparison-matrix.svg` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/templates/data-flow.svg` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/templates/er-diagram.svg` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/templates/flowchart.svg` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/templates/sequence.svg` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/templates/state-machine.svg` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/templates/timeline.svg` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/templates/use-case.svg` | 原样镜像 | 含上游文档、代码、模板与许可证；保留源语言。 |
| `.agents/skills/fireworks-tech-graph/assets/samples/sample-style1-flat.png` | 原样镜像 | 按字节核对样例资源。 |
| `.agents/skills/fireworks-tech-graph/assets/samples/sample-style2-dark.png` | 原样镜像 | 按字节核对样例资源。 |
| `.agents/skills/fireworks-tech-graph/assets/samples/sample-style3-blueprint.png` | 原样镜像 | 按字节核对样例资源。 |
| `.agents/skills/fireworks-tech-graph/assets/samples/sample-style4-notion.png` | 原样镜像 | 按字节核对样例资源。 |
| `.agents/skills/fireworks-tech-graph/assets/samples/sample-style5-glass.png` | 原样镜像 | 按字节核对样例资源。 |
| `.agents/skills/fireworks-tech-graph/assets/samples/sample-style6-claude.png` | 原样镜像 | 按字节核对样例资源。 |
| `.agents/skills/fireworks-tech-graph/assets/samples/sample-style7-openai.png` | 原样镜像 | 按字节核对样例资源。 |

## 保留的目标项目事实

- `docs/architecture/overview.md`、`docs/architecture/selected-text-flow.md` 保留当前
  SelectedTextKit 架构事实；不复制 Easydict 的产品实现。
- 根 `README.md` 继续作为公开 Package 文档，不搬运 Easydict 用户指南。
- `.claude/CLAUDE.md -> ../AGENTS.md` 与 `.claude/skills -> ../.agents/skills` 保持共享入口。
- 用户删除的 `.claude/settings.local.json` 不恢复。
- 同任务 plan、history 记录本项目执行过程，不复制源项目的完成记录。

## 明确排除

- `.agents/skills/release-easydict/` 及其发布脚本、fixture：绑定 Easydict 应用发布链，
  本项目没有对应发布资源；不把它伪装成通用 Package 发布技能。
- Easydict 的产品架构正文、旧 plans/histories、用户指南和运行时资源：内容描述其他产品，
  不适用于 SelectedTextKit；保留通用分层规则、索引职责和模板。
- `docs/exec-plans/active/swift-migration.md`：源产品的 Objective-C 迁移路线图。
- 源参考文件 `easydict-agent-documentation-port.md` 的 Scoco 迁移历史：由本文件记录
  本次真实来源，不能把源项目的来源关系当成本项目执行历史。
- `.DS_Store`、缓存与未跟踪的本地文件：不是源仓库受版本管理的技能资源。

## 验收方式

1. 对每个原样文件按字节比较，并检查脚本执行权限；必要适配文件逐项审查 diff。
2. 检查 Markdown 本地链接、TOML、技能 frontmatter、脚本语法和现有 helper 测试。
3. 走读已有 staged、空索引、跨轮禁止提交、验证失败、PR latest-base、线程状态变化、
   脏目标 worktree 和缺少 PR 模板等场景，检查原有条件与恢复路径完整。
4. 上游镜像内部已有的缺陷单独记录，不以迁移名义静默重写其内容。
5. 由独立 reviewer 复核最终差异与场景；验证结果写入同任务 history。

## 本轮核对结果

- 91 条映射全部存在：74 个原样文件逐字节一致，17 个适配文件均经过独立 diff 复核。
- 文件执行权限与源版本一致；六个通用技能正文与四个 Codex 配置原样恢复。
- 上游绘图镜像 7 个文件含既有空白提示，保留原文；相关事实与验证限制详见
  [同任务 history](../histories/2026-09/2026-09-06-selectedtextkit-agent-rules-port.md)。

## 重新评估条件

源规则、目标项目结构或用户偏好改变时，按本清单核对差异。源文件更新不等于自动授权
同步本项目，更不能作为执行真实 GitHub mutation 的请求。
