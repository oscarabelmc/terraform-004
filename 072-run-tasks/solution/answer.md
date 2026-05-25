# Answer

The correct answer is **B**.

> Run tasks

---

## Why B Is Correct

**Run tasks** are an HCP Terraform feature that integrates external tools into the workflow **between the plan and apply phases**:

```
┌──────────────────────────────────────────────────────┐
│              HCP Terraform Run Lifecycle              │
├──────────────────────────────────────────────────────┤
│                                                      │
│  Plan ──→ Run Tasks ──→ Manual Confirm ──→ Apply     │
│             │                              ▲         │
│             ▼                              │         │
│     ┌──────────────┐                      │         │
│     │ External     │  PASS ────────────────┘         │
│     │ Tool (Snyk,  │                                 │
│     │ Checkov,     │  FAIL ───→ Block apply,         │
│     │ tfsec, etc.) │           notify team           │
│     └──────────────┘                                 │
└──────────────────────────────────────────────────────┘
```

### How run tasks work

1. Terraform generates a plan
2. HCP Terraform serializes the plan to JSON
3. The JSON plan is sent to the run task endpoint (a URL you configure)
4. The external tool analyzes the plan for security, cost, or compliance issues
5. The tool returns `PASS`, `FAIL`, or `ERROR` to HCP Terraform
6. HCP Terraform enforces the result — only proceeding to apply if all tasks pass

### Key characteristics

| Aspect | Details |
|--------|---------|
| **Timing** | After plan completes, before apply begins |
| **Input** | Plan JSON (full resource diffs) |
| **Output** | Pass, fail, or error with optional messages |
| **Endpoint** | External HTTP endpoint (SaaS or self-hosted) |
| **Integration** | Configured per workspace or globally in HCP Terraform |
| **Outcome** | Blocks apply if any task fails |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Sentinel policies | Sentinel runs **during** plan evaluation (policy as code), not between plan and apply. It uses HashiCorp's policy language, not external tools. |
| C — State versioning | State versioning tracks state history — it has nothing to do with gating plans or integrating external tools. |
| D — Workspace variables | Variables provide input to configurations — they are not a mechanism for running external checks during the workflow. |
| E — Module registry | The module registry stores and versions modules — it does not interact with the plan/apply workflow at all. |

## HCP Terraform Gating Mechanisms

```
Before Plan ──→ Sentinel Policies (policy as code)

During Plan ──→ (no gating — plan is generated)

After Plan ──→ Run Tasks (external tool integration)
     │
     ▼
Before Apply ──→ Manual Confirm (human approval)

After Apply ──→ Post-apply webhooks (notifications)
```

| Feature | When | What |
|---------|------|------|
| **Sentinel** | During plan evaluation | Built-in policy engine |
| **Run tasks** | After plan, before apply | External tool integration |
| **Manual confirm** | Before apply | Human review |
| **Webhooks** | After apply | Notifications |

## Objective Reference

This question tests understanding of HCP Terraform features — specifically run tasks as the mechanism for integrating external security/compliance tools into the plan-review-apply workflow.

## Exam Tips

- **Run tasks** = external tools between plan and apply
- **Sentinel** = policy as code during plan evaluation (built-in, not external)
- Run tasks receive **plan JSON** and return **pass/fail**
- Security scanners (Snyk, Checkov, tfsec) are common run task integrations
- Cost estimators (Infracost) also use run tasks
- Multiple run tasks can run sequentially or in parallel
- A failing run task **blocks apply** completely
- Common exam trap: confusing run tasks with Sentinel policies (Sentinel is built-in policy engine, run tasks are for external tools)
