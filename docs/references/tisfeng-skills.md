# `tisfeng/skills` 来源参考

- 核对日期：2026-09-09。
- 来源：`https://github.com/tisfeng/skills`。
- 采用版本：`v0.3.0`。
- peeled commit：`ccc74f119f61d672cfd0cb57c07a259b7bc78614`。
- Skills 安装器：`skills@1.5.24`。
- Codex 子代理安装器：`@tisfeng/codex-agents@0.3.0`。

## 采用范围

同步 `code-simplifier`、`git-commit`、`review`、`review-pr`、`submit-pr` 与
`worktree-rebase-merge` 六个完整 Skill 目录，以及 `planner`、`reviewer`、`tester` 与
`git-delivery` 四个子代理。

`code-simplifier v0.3.0` 同时包含 `electron-typescript.md` 与 `swift-xcode.md` 条件规则。
SelectedTextKit 不删减不适用的 Electron reference；具体任务只按 Skill 路由读取适用内容。
`submit-pr` 已使用独立模板 fixture，无需保留旧迁移的本地测试补丁。

## 已核验安装形式

`skills@1.5.24` 没有 `--cwd` 选项，项目安装必须从目标仓库根目录执行；不要把未知参数当作
临时目录或目标目录覆盖。以下命令更新当前仓库的 `.agents/skills/` 和 `skills-lock.json`：

```bash
npx -y skills@1.5.24 add \
  https://github.com/tisfeng/skills/tree/v0.3.0 \
  --skill code-simplifier git-commit review review-pr submit-pr worktree-rebase-merge \
  --agent codex --yes --copy --full-depth

npx -y @tisfeng/codex-agents@0.3.0 add 'tisfeng/skills#v0.3.0' \
  --agent planner --agent reviewer --agent tester --agent git-delivery
```

首次接管已有且尚无 lock 的不同 agent TOML 时，在冻结并核对目标后为该次命令增加
`--force`；本次首次安装使用该方式。以后升级不默认强制覆盖。

Skills lock 记录 tag、入口路径和内容哈希；agents lock 额外记录精确 revision 与文件哈希。
两种 lock 的重装和更新语义不能互相推导，实际字段以安装器输出为准。

`submit-pr v0.3.0` 使用 `zip(..., strict=True)`，需要 Python 3.10 或更高版本。
解释器选择规则见 [`git-workflow.md`](../agents/git-workflow.md)，不通过本地修改受管脚本
绕过该边界。本项目验证结果见本次 history，不将 Easydict 的测试记录当成本项目结果。

## 版本选择与重新核对条件

上游已发布 `v0.3.1`，本次按批准方案复现 Easydict 的 `v0.3.0` 基线，不混入升级。
发布新版本、安装器或 lock 格式变化、宿主规则不能表达必要差异时重新评估；行为修改先在
上游完成并发布，再显式同步。不要直接修改已安装副本。
