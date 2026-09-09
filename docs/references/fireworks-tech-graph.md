# `fireworks-tech-graph` 来源参考

- 核对日期：2026-09-09。
- 来源：`https://github.com/yizhiyanhua-ai/fireworks-tech-graph`。
- Skill 路径：`skills/fireworks-tech-graph`。
- 采用 ref/commit：`31fea364eda5f1852b1175f3d9e29ea31d22dcb4`。
- 安装器：`skills@1.5.24`。

## 采用范围

完整同步上游 Skill 目录，包括 `SKILL.md`、references、scripts、tests、schemas、fixtures、
templates、examples 和必要静态资源。该 Skill 不属于 `tisfeng/skills`，不接受本地内容修改。
旧 `.agents/overrides/` 随外部资产治理迁移删除，不再叠加本地规则。

## 同步形式

从项目根目录执行，固定到 Easydict 记录的同步 commit，不跟随移动的 `main`：

```bash
npx -y skills@1.5.24 add \
  https://github.com/yizhiyanhua-ai/fireworks-tech-graph/tree/31fea364eda5f1852b1175f3d9e29ea31d22dcb4/skills/fireworks-tech-graph \
  --skill fireworks-tech-graph --agent codex --yes --copy --full-depth
```

命令只选择该来源和 Skill；同步后检查完整目录和 `skills-lock.json` 对应条目。
不要用跨来源的整项目更新代替此步骤，也不要手工调整 computed hash。

## 重新核对条件

- 用户明确要求同步新 commit。
- 上游发布稳定 tag，或移动/拆分 Skill 路径。
- 安装器改变复制内容、hash 或 lock 字段。
