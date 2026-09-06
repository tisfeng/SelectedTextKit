# submit-pr 工作流契约

## 拓扑

Helper 接受 GitHub SSH 或 HTTPS remotes，并按顺序解析：

1. base repository：显式参数、`GH_REPO`，或 remote fork 网络中的唯一根仓库；
2. base remote：显式参数或唯一匹配 remote；
3. base branch：显式参数、branch 配置或 GitHub 默认 branch；
4. head remote：显式 push 配置、fork 拓扑、upstream 或 base remote；
5. head repository 身份及其 fork network membership。

候选存在歧义时停止。显式参数只能解决歧义，不能绕过身份验证。

## Branch 与工作树

- Base/default branch 和显式 protected branch 都属于保护分支。
- 当前位于保护分支或 branch 不符合 Conventional 格式时，需要 `--head-branch <type>/<kebab-case-summary>`。
- Helper 可以在冻结 HEAD 创建或复用该 ref，但不切换 checkout，也不移动当前分支。
- Detached HEAD 时停止。
- `plan` 只执行 Git 读取，不 fetch，也不创建临时文件。
- `apply` 要求工作树完全干净，并且不运行 `git add`、`git commit`、rebase 或 history rewrite。

## 正文

最终正文只包含一组按顺序排列的规范段落：

1. `## 变更说明 / Summary`
2. `## 关联 Issue / Linked Issues`
3. `## 验证 / Verification`
4. `## 截图 / Screenshots`

Helper 映射常见 template 标题，保留有意义的提示和 checklist，并追加项目专属段落。Summary 和 Verification 不能为空。Issue 引用不会自动获得 closing keyword。

`--issue-policy neutral` 不增加关闭行为；`allow` 允许 closing keyword；`forbid` 拒绝正文和 commit range 中的 closing keyword，并验证 GitHub 没有报告 closing issue references。

## Apply 与幂等

`apply` fetch 准确 base，要求它是冻结 head 的 ancestor，并要求 range 至少包含一个 commit。使用准确 refspec push 冻结 SHA，并为 `gh pr create` 显式提供 repository、base、head、title 和 body。

创建前查询相同 base/head 的开放 PR。恰好一个且完全匹配时复用；存在多个或不匹配时停止。验证最终 state、base、head、SHA、repositories、title、body、draft flag 和 issue policy。验证失败不授权创建第二个 PR 或自动覆盖。
