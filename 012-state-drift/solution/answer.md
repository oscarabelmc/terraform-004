# Explanation

The correct answer is **C — Real infrastructure has changed outside Terraform and no longer matches the desired state.**

## Why

**Drift** occurs when someone or something modifies the real-world infrastructure outside of Terraform's workflow. The three states involved are:

```
Configuration (desired) ──apply──> Real infrastructure ──state──> State file
                                      │
                                      │ (manual edit, CLI, cloud console, etc.)
                                      ▼
                                  Drift detected!
```

When you run `terraform plan`, Terraform:
1. Refreshes state by reading the real infrastructure
2. Compares real infrastructure to the configuration
3. Reports any differences — this is drift

## Key Characteristics of Drift

| Aspect | Detail |
|--------|--------|
| **Cause** | Changes made outside Terraform (cloud console, CLI, API, another tool) |
| **Detection** | `terraform plan` or `terraform plan -refresh-only` |
| **Impact** | State becomes stale — it no longer reflects reality |
| **Resolution A** | `terraform apply` — restores real infra to match the config |
| **Resolution B** | `terraform apply -refresh-only` — updates state to match real infra |
| **Resolution C** | Manual revert — undo the outside change |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Syntax error in config | That's a **validation error**, caught by `terraform validate`. Drift is about infrastructure, not configuration. |
| B — Approved but unapplied plan | That's a **pending plan** or **speculative plan**. Drift specifically refers to unmanaged changes to real resources. |
| D — State has more resources than config | That's a **state-to-config mismatch**, not necessarily drift. Drift means real infra has changed, not just the config. |
| E — Resource failed during apply | That's an **apply failure**. Drift can happen at any time (even long after a successful apply). |
