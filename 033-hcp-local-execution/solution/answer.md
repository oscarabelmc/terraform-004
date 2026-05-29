# Explanation

The correct answer is **A**.

> HCP Terraform only stores and syncs the workspace's state file, while you run plan and apply locally on your own machine.

---

## Why A Is Correct

In **local execution mode**, HCP Terraform functions as a **remote state backend** — it handles the state layer while the compute layer stays on your machine:

```
┌─────────────────────────────────────────────────┐
│                  Your Machine                    │
│  ┌──────────┐    ┌──────────┐    ┌───────────┐  │
│  │ terraform │    │ terraform │    │ terraform │  │
│  │   init    │    │   plan    │    │   apply   │  │
│  └──────────┘    └──────────┘    └───────────┘  │
│       │               │               │          │
└───────┼───────────────┼───────────────┼──────────┘
        │               │               │
        ▼               ▼               ▼
┌─────────────────────────────────────────────────┐
│                HCP Terraform                     │
│  ┌──────────────────────────────────────────┐   │
│  │            State Storage                  │   │
│  │  ● Store state after apply               │   │
│  │  ● Provide state before plan/apply       │   │
│  │  ● Lock/unlock during operations         │   │
│  │  ● Version history with diffs            │   │
│  └──────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
```

HCP Terraform handles:
- **State storage** — centralized, secure
- **State versioning** — every apply creates a versioned snapshot
- **State locking** — prevents concurrent writes
- **State sync** — provides the latest state before each operation

Your machine handles:
- `terraform plan` — computed locally
- `terraform apply` — executed locally
- Provider plugin execution — runs on your machine
- Module resolution — done locally

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — HCP runs plan/apply remotely | That's **remote execution mode**, not local. In local mode, the compute stays on your machine. |
| C — Only stores provider plugins | Provider plugins are never stored in HCP Terraform. They're downloaded locally via `terraform init`. |
| D — Disables remote functionality | HCP Terraform still stores and versions state. It doesn't "revert to local" — it selectively manages state only. |
| E — Plan locally, apply remotely | Not a supported mode. Execution is either all local or all remote. |

## Use Cases for Local Execution

| Scenario | Why Local Execution Works |
|----------|--------------------------|
| **Hybrid migration** | Move state to HCP Terraform without changing local workflows |
| **Air-gapped compute** | Resources must be created from a specific network/location |
| **Custom tooling** | CI pipeline needs to install custom plugins or run local scripts |
| **Developer preference** | Team wants HCP state benefits but CLI-driven workflow |
