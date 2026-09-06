# 变更历史

`docs/histories/` 记录每个最终产生仓库文件差异的 implementation 任务。

## 规则

- 每个 implementation 任务使用一条 history。
- 同一任务的后续轮次复用同一条记录。
- 仅修改 history 的任务不递归创建第二条 history。
- 总结用户请求时移除秘密、机器本地绝对路径和原始日志。
- 记录设计意图、受影响文件、实际验证、已知限制，以及存在时的 completed execution plan。
- 文件名使用 `YYYY-MM/YYYY-MM-DD-<kebab-case-slug>.md`。
- 没有仓库文件变化时不创建空 history。

新记录从 `template.md` 开始。
