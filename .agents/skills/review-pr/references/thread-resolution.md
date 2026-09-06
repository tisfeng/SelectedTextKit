# 安全 Resolve Review Thread

Resolve review thread 会改变 GitHub 状态。该动作不发布 reply、不关闭 PR 或 issue、不 approve，也不 push。

## 收集与判定

```bash
python3 .agents/skills/review-pr/scripts/review_threads.py collect \
  --repo OWNER/REPO \
  --pr NUMBER
```

输出包含 PR 身份、`headRefOid`、完整 comments，以及每个 thread 的内容 fingerprint。必须人工评估每条开放 thread。

只有以下两种决定可以进入 apply plan：

- `fixed`：准确远程 head 已消除原问题。
- `not_applicable`：代码或需求的实质变化已消除该 concern，并且没有未回答的实质问题。

不能只因为 `isOutdated`、绿色 CI、作者声称已修复、本地未发布代码、作者身份或主观不同意就 resolve。证据不足、部分修复和需要产品决策的 thread 保持开放。

## Snapshot-Bound Plan

根据 collect 的真实值创建 plan：

```json
{
  "version": 1,
  "repo": "OWNER/REPO",
  "number": 123,
  "id": "PR_ID",
  "headRefOid": "REMOTE_HEAD_SHA",
  "decisions": [{
    "thread_id": "THREAD_ID",
    "fingerprint": "COLLECTED_FINGERPRINT",
    "assessment": "fixed",
    "evidence_head": "REMOTE_HEAD_SHA",
    "evidence": "消除问题的准确远程路径和行为",
    "permalink": "COMMENT_URL"
  }]
}
```

取得明确授权后执行：

```bash
python3 .agents/skills/review-pr/scripts/review_threads.py apply \
  --plan PLAN.json \
  --allow-resolve
```

Helper 在每次 mutation 前重新 collect，并核对 PR 身份、开放状态、head SHA、thread fingerprint 和 `viewerCanResolve`。谨慎处理部分失败和不确定响应，之后重新 collect；不得自动 unresolve 或盲目重试。
