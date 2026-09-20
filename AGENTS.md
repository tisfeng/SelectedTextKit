# AGENTS.md

SelectedTextKit 是一个 Swift Package，通过 Accessibility、AppleScript、菜单操作和
键盘快捷键等策略获取 macOS 选中文本。

`AGENTS.md` 维护 Agent 的通用约束和唯一任务路由。现行详细规则位于 `docs/agents/`，每项
规则只维护一个权威来源。

## 任务模式

### 计划模式

- 用户要求方案、分析、解释或评估时，只读取和检查现状并给出答复，不修改文件、Git 或外部服务。

### 执行模式

用户要求修改、修复、更新或执行时，按执行前、实现与验证、Review、交付的顺序完成；默认只做本地交付，
push、Pull Request、发布及其他外部写入必须得到明确授权。

## 始终阅读

- 每个任务先读取当前任务需要的专题规则，先确定请求语义、写入授权和任务模式。
- 除非用户明确要求其他语言，否则使用简体中文沟通；仓库治理文档、计划、history、参考资料
  和项目维护的配置使用中文，源码注释使用英文。外部受管快照保留上游原文；代码标识、API
  名称、命令、路径、品牌名称和固定输出契约保留原文。
- 再按当前任务读取下方最小必要规则，不通过其他 README 或索引进行二次路由。

## 任务路由

- 构建、测试、工程文件与资源、Xcode 验证：[`build-and-test.md`](docs/agents/build-and-test.md)。
- 跨语言代码质量、Swift、Objective-C、SwiftUI、API 和本地化：
  [`coding-guidelines.md`](docs/agents/coding-guidelines.md)。
- 计划与 history 记录：[`exec-plans/README.md`](docs/exec-plans/README.md) 与
  [`histories/README.md`](docs/histories/README.md)。
- 参考资料与外部证据：[`references/README.md`](docs/references/README.md)。
- 外部 Skills 和同步边界：[`skills.md`](docs/agents/skills.md)。
- 产品代码、跨功能行为或模块边界：`docs/architecture/overview.md`。
- 公共使用或贡献者文档：根目录 `README.md`。
- 具体 Skill：执行前读取 `.agents/skills/<skill>/SKILL.md`。
- 创建 GitHub PR：`.agents/skills/submit-pr/SKILL.md`。
- OpenAI API、ChatGPT Apps SDK、Codex 或相关开发工具：优先使用 OpenAI 开发者文档
  MCP server；不可用时访问官方文档网页，并说明实际来源。
- 应用内置 Agent 文档、运行时资源或后端契约：读取其自身权威来源。

## Review 路由

- 本地任务、工作树、提交/range、文件或模块审查：`.agents/skills/review/SKILL.md`。
- GitHub PR review：`.agents/skills/review-pr/SKILL.md`；默认不授权产品修复、发布评论、
  approve、关闭 PR 或 push。

## 回复与交付表达

- 先说明真实结果，再给必要证据、修改范围、已执行/未执行验证和外部交付状态；只有需要用户
  决策时才提出问题。
- 因规则暂停或留下未完成工作时，链接实际权威条款，区分明确要求与 Agent 推断，不重复询问
  已有授权。
- 不从材料复制无关要求，不把计划写成完成结果，也不把静态检查写成构建或运行测试。标题、
  提交信息和 PR 描述优先表达实际新增、修复、保留或验证的行为。

## 维护约束

- 保留工作树中与当前任务无关的 staged、unstaged 和 untracked 变更。
- `skills-lock.json` 管理外部受管 Skill 快照；普通项目任务不得直接修改，项目专属例外和同步边界见
  [`docs/agents/skills.md`](docs/agents/skills.md)。
