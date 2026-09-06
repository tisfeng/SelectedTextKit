# Easydict Agent 文档移植参考

## 来源

本次语义移植于 2026-09-06 基于本地 Easydict 仓库 `origin/dev` commit `608d1f18c416d02338aaa7cf3eb13299f89c9740` 进行评估。源 checkout 的相关治理路径与该基线一致。

## 采用范围

- 唯一根 Agent 入口和按任务路由。
- 分离现行规则、架构事实、设计理由、执行计划、历史和参考资料。
- 明确的请求/证据边界和写入前变更门禁。
- 项目 planner、reviewer 和 tester 配置。
- 通用代码简化、commit、review、PR 和 worktree skills。
- 每个产生仓库差异的 implementation 使用一条同任务 history。

## SelectedTextKit 本地差异

- 新建或修改的仓库治理文档、skill 和 Agent 配置使用中文；代码注释使用英文。
- Git stage、commit、integration、push 和远程 mutation 需要用户明确授权。
- PR 工作流动态发现仓库实际默认分支，不硬编码 Easydict 的 `dev` 或 release 参数。
- 构建和测试规则使用 SwiftPM 与 `SelectedTextKitExample.xcodeproj`。
- 不移植源仓库的 release、String Catalog、公开 user-doc 分层、migration roadmap、产品 UI 和应用专属依赖规则。
- 不重复引入全局已经可用的 `fireworks-tech-graph` skill。

## 重新评估条件

当任一仓库改变请求边界、变更门禁、文档分层、skill 契约或构建拓扑时，重新评估本次移植。
