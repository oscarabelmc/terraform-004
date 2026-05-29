# Explanation

The correct answer is **A — To automatically queue a new run in a downstream workspace after another workspace applies successfully.**

## Why

Run triggers create a **dependency chain** between workspaces. When the upstream workspace completes a successful apply, HCP Terraform automatically queues a new plan in every downstream workspace configured as a trigger target.

This eliminates the need for manual orchestration in multi-workspace environments.

## Key Details

| Aspect | Behavior |
|--------|----------|
| **When it fires** | Only on **successful applies** |
| **When it does NOT fire** | Plans, discarded runs, errored runs, canceled runs |
| **Direction** | Upstream → Downstream (one-way) |
| **Configuration** | Workspace → Settings → Run Triggers |
| **Multiple targets** | One upstream can trigger many downstream workspaces |
| **Independent from VCS** | Works without any VCS connection |
| **Workspace type** | Both CLI-driven and VCS-driven workspaces support run triggers |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — Trigger on Git push | That's a **VCS trigger**, not a run trigger. VCS triggers react to code changes; run triggers react to workspace completion. |
| C — Scheduled re-run | That's a **schedule trigger**. Run triggers are not time-based. |
| D — Webhook notification | That's a **notification/webhook**. Run triggers actually queue a new run — they don't just send a message. |
| E — Lock dependent workspace | That's **run queue concurrency control**, not a run trigger. Run triggers queue new runs; they don't block existing runs. |
