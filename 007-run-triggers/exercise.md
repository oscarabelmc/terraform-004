# Run Triggers Exercise

**Exam Question:** In HCP Terraform, what is the purpose of using a run trigger?

## Background

In real-world environments, infrastructure is often split across multiple workspaces:

```
networking ──> app ──> data
```

Changes in upstream workspaces (e.g., a new VPC) often require downstream workspaces (e.g., app servers) to update. Run triggers automate this chain.

## Steps

### Part 1 — Understand the workspace relationship

1. **Examine the upstream workspace** — `main.tf` declares a `cloud {}` block pointing to the "networking" workspace. It creates a `random_pet` and exposes it as an output.

2. **Examine the downstream workspace** — `downstream/main.tf` targets the "app" workspace. It uses `data "terraform_remote_state" "networking"` to read the upstream outputs.

### Part 2 — Without run triggers

Without a run trigger, applying the networking workspace does nothing to the app workspace. You must:

- Notice a change was made (manual check or notification)
- Navigate to the "app" workspace
- Click "Start new run" manually
- Wait for it to plan and apply

This is fragile and easy to forget in production.

### Part 3 — With run triggers

When a run trigger is configured from "networking" → "app":

```
networking apply succeeds
       │
       ▼
   app run is automatically queued
       │
       ▼
   app plan + apply
```

To configure this in HCP Terraform:

1. Go to **Workspace** → **networking** → **Settings** → **Run Triggers**
2. Select the **app** workspace as a downstream target
3. Save — every successful apply on networking now queues a new run on app

### Part 4 — Key details

- Run triggers fire only on **successful applies**, not on plans or discarded runs
- Run triggers are independent of VCS triggers — you can have one, both, or neither
- Multiple downstream workspaces can be triggered from a single upstream workspace
- A downstream workspace can have multiple upstream triggers

### Put It Together

What is the purpose of a run trigger in HCP Terraform?

- A. To automatically queue a new run in a downstream workspace after another workspace applies successfully
- B. To trigger a workspace run when a Git push is made to the repository
- C. To re-run a workspace's last plan at a scheduled interval
- D. To send a webhook notification when a run completes
- E. To lock a workspace when a dependent workspace has a run in progress

## Files
- `main.tf` — upstream workspace config (networking)
- `downstream/main.tf` — downstream workspace config (app)
- `solution/answer.md` — explanation and exam tips
