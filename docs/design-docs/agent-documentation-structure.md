# Agent 文档结构设计

- 状态：adopted
- 初次记录：2026-09-06

## 背景

Agent 需要一个小而可靠的当前约束入口，维护者则需要分别记录规则、实现事实、设计理由、进行中工作、完成结果和外部来源。把这些内容集中在一个文件中会让入口不断膨胀，并产生重复权威来源。

## 目标

- 保持唯一、简短且稳定的任务入口。
- 让每类知识拥有一个权威位置。
- 只加载当前任务需要的规则。
- 让路径、链接、命名和结构能够低成本验证。
- 通过兼容入口让 Codex 与 Claude 共用一套规则和 skills。

## 非目标

- 不把全部详细规则写入 `AGENTS.md`。
- 不创建多个任务路由索引。
- 不持续镜像 Easydict 或其他仓库。
- 不让设计文档替代当前规则或架构事实。

## 设计决策

| 位置 | 权威内容 |
| --- | --- |
| `AGENTS.md` | 唯一入口和任务路由 |
| `docs/agents/` | 当前仓库规则 |
| `docs/architecture/` | 当前实现事实 |
| `docs/design-docs/` | 长期设计理由 |
| `docs/exec-plans/` | 已授权多步骤 implementation 进度 |
| `docs/histories/` | 已完成 implementation 记录 |
| `docs/references/` | 精选外部和跨仓库证据 |
| `.agents/skills/` | 仓库维护的可执行工作流 |
| `.codex/agents/` | 项目 Agent 角色配置 |
| `README.md` | 公开 Package 文档 |

根文件只路由，不复制详细流程。每个规则文件只负责一个主要职责。外部参考只有经过本地评估并写入权威规则后，才成为仓库约束。

## SelectedTextKit 本地适配

SelectedTextKit 保留自身 Swift Package 和示例工程构建边界，使用 `main` 作为当前默认分支，并要求 Git mutation 获得明确授权。不会继承 Easydict 的 release、localization、产品 UI 或 Objective-C migration 规则。

## 重新评估条件

- 根入口再次承载大量详细流程。
- 同一规则在多个文件中被视为权威。
- Agent 经常漏读必要路由。
- 新的长期知识类别无法归入现有分层。
- 路径和链接无法继续低成本验证。
