## 2026-09-06 | 任务：移植 Agent 规则与 Skills

**Links:** [执行计划](../../exec-plans/completed/2026-09-06-selectedtextkit-agent-rules-port.md)；
[移植清单](../../references/easydict-agent-documentation-port.md)；
首次提交 `b0e75efd4101eef78fdee7b1bcb23ac150b5e309`。

### 用户请求

将 Easydict 的 Agent 规则、docs、Codex 配置和 skills 移植到 SelectedTextKit，通过
Claude 软连接共享一套规则。用户要求中文，并纠正首次迁移的过度精简和行为改写：
尽可能保持原文、完整规则与资源，只做必要项目适配。用户批准修订方案及 submit-pr
测试自带模板的独立性调整。

### 变更

- 首次提交引入六个技能及文档结构，但错误删减了通用工作流，本轮按源版本恢复。
- 完整恢复六个通用技能正文、references、运行脚本和配套配置。
- submit-pr 仅保留测试内置示例模板，不要求使用它的仓库创建 PR 模板文件。
- 恢复自动本地交付、显式 staged 交付、protected 边界、线程维护和完整报告。
- 恢复 planner、reviewer、tester 完整配置，网络配置恢复为 `true`。
- 补齐 fireworks-tech-graph 镜像、许可证、样例和 overlay。
- 恢复文档生命周期、模板和相关参考，增加逐文件适配清单。
- 保留 SelectedTextKit 的架构事实、SwiftPM/示例工程路径、中文治理文档和 Claude 软连接。

### 设计意图

本轮采用完整源文件和显式差异清单，避免在摘要中丢失行为、保护条件和恢复路径。
源仓库专属发布、依赖、Catalog 路径与旧产品记录单独说明排除原因。运行脚本和通用
技能不绑定 SelectedTextKit；架构和构建事实按目标项目核对。

### 验证

- 首次迁移：60 项 helper 测试通过，但不能据此证明文档无遗漏。
- 首次提交的 whitespace 检查存在 9 个文件末尾空行；旧记录笼统写为通过不准确。
- 91 条映射：74 个文件逐字节一致，17 个必要适配；没有缺失或执行权限差异。
- 六个通用技能正文、references、运行脚本与四个 Codex 配置均与源文件一致。
- fireworks-tech-graph：46 个文件完整镜像，包含 7 个样例图片。
- git-commit：19 项测试通过；review-pr：24 项通过；submit-pr：17 项通过。
- 无 PR 模板的运行时回退：通过；显式指定不存在模板：按预期报错。
- 7 个技能通过 quick_validate；归档后 47 条 Markdown 本地链接有效；TOML、Python、Shell、JSON 检查通过。
- 本轮自维护变更的 whitespace 检查通过；完整上游镜像有 7 个文件保留源版本的
  trailing whitespace，已按字节证明是继承内容，作为原样迁移例外记录，不宣称全量无警告。
- 独立 reviewer 核对全部映射、17 处适配 diff、资源权限与项目事实，没有有效 finding。
- 独立场景走读覆盖显式 staged 交付、空索引一次暂存、跨轮禁止提交、验证失败后修复、
  缺少 PR 模板、latest-base 的远程／本地快照，以及脏目标 worktree 恢复。
- 未执行 Swift/Xcode build、绘图运行或真实 GitHub 操作：本轮为治理恢复与原样资源迁移，
  上述运行能力不在本轮验证范围内。

### 受影响文件

- `AGENTS.md`
- `.agents/skills/`、`.agents/overrides/`
- `.codex/`
- `docs/agents/`、`docs/architecture/README.md`、`docs/design-docs/`
- `docs/exec-plans/`、`docs/histories/`、`docs/references/`

### 后续事项

无遗留实施事项。首次迁移已显式提交，上述 b0e75efd 不属于自动交付；本轮修订及本记录
按批准方案进入首次自动本地交付，实际提交信息由 Git 历史保存。此前“当前未执行
commit”的描述已纠正；不改写首次提交。上游原有空白和未执行的运行验证见上节。
