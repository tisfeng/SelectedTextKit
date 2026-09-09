# 移植外部 Agent 资产治理

- 日期：2026-09-09。
- 状态：completed。
- 关联计划：[执行计划](../../exec-plans/completed/2026-09-09-external-agent-assets-port.md)。

## 目标与实际变更

按批准方案采用 Easydict `602c56b2` 五专题治理结构，完整安装 `tisfeng/skills v0.3.0`
六个技能与四个子代理，fireworks 固定到独立上游 `31fea364`，生成双 lock。
删除已归并的五份旧规则和两份 overlay；历史可从 Git 恢复。
保留中文宿主文档、SwiftPM/示例工程及动态 PR 参数，未修改产品代码、全局配置、
项目 `.codex/config.toml` 或 Claude 软链接。旧迁移参考保留为历史并指向当前映射。

完整路径分类与适配原因见 [迁移映射](../../references/external-agent-assets-port.md)。

## 安装与验证

- 使用 `skills@1.5.24` 安装完整技能快照。
- 使用 `@tisfeng/codex-agents@0.3.0` 首次接管四个目标并生成 agent lock；使用一次性
  `--force`，没有手改 hash。
- 六个通用技能共 23 文件与 `v0.3.0` 逐字节一致；四个 Agent 同时匹配 tag 和 lock 哈希。
- fireworks 140 个文件集合及 Git blob hash 与独立上游固定 commit 一致，包括源项目
  tracked tree 遗漏的云图标 manifest。保留完整上游资源，不复制遗漏。
- Python 3.14.7 下执行 `PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -v`
  （分别位于四个 Skill 根目录）：git-commit 19、review-pr 27、submit-pr 21 项通过；
  fireworks 141 项中 136 通过、5 跳过。总计 208 项，203 通过、5 跳过，无失败。
- 跳过的是 3 个需显式开启的 Chromium 渲染回归和 2 个 payload 不包含的上游仓库 workflow
  检查；未运行会生成 test-output 的样式渲染脚本。未产生字节码或测试输出目录。
- JSON/TOML、git diff --check 及受保护路径不变检查通过；13 份现行文档的 25 个相对链接
  及锚点通过检查。32 个 Python、4 个 Shell、3 个 JavaScript 文件语法检查通过。
- 独立 reviewer 核对源规则、23 个通用技能文件、四个子代理、140 个 fireworks 文件、
  宿主链接和删除文件，无阻塞 finding；未重跑测试，不混淆审查与测试证据。

## 交付边界

初始 HEAD 为 `40ffa178a5ba5f49d634d76c6a5906005ac83269`，工作树和索引干净。
内容验证完成，计划已归档。按 auto-local-commit 门禁由 git-delivery 串行完成本地交付，
实际提交哈希与消息以包含本记录的 Git 提交和最终回执为准，不 push。
未运行 Swift/Xcode 构建；尚未验证新会话自动发现子代理，不将配置解析当作运行时成功。
