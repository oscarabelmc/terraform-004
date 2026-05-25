# Answer

The correct answer is **B — 1**.

> In HCP Terraform, a workspace can be mapped to only one VCS repository.

---

## Why the Answer Is 1

HCP Terraform's workspace-to-VCS mapping is **one-to-one**:

```
┌─────────────────────────┐     ┌──────────────────────────┐
│ HCP Terraform Workspace │ ──→ │ Single VCS Repository    │
│                         │     │                          │
│ e.g., "production"      │     │ github.com/org/infra     │
│                         │     │                          │
│ Queues runs on push     │     │ Only ONE repo per        │
│ Shows plan in PRs       │     │ workspace                │
└─────────────────────────┘     └──────────────────────────┘
```

### Why this limit exists

| Reason | Explanation |
|--------|-------------|
| **Workspace identity** | Each workspace represents one environment/config — one repo is the single source of truth |
| **Run determinism** | If a push comes from which repo? Ambiguity is avoided with a single mapping |
| **PR integration** | HCP Terraform comments plan results on PRs — this works with one repo per workspace |

### If you need multiple repos

| Need | Solution |
|------|----------|
| Separate networking and app repos | Create two workspaces, each linked to one repo |
| Shared modules repo | No workspace needed — modules are referenced via `source` in config |
| CI/CD triggers from another repo | Use the API or CLI-driven runs instead of VCS integration |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — 0 | Possible if you use CLI-driven or API-driven runs, but when VCS-connected, there's always exactly 1 VCS repo. The question assumes a VCS-connected workspace. |
| C — 5 | No — a workspace cannot be mapped to multiple repos. |
| D — Unlimited | No — there's a hard limit of one repo per workspace. |

## Exam Tips

- HCP Terraform workspace = **1 VCS repository**
- Multiple repos → multiple workspaces
- Workspace can also be **VCS-independent** (CLI-driven or API-driven)
- Common exam trap: thinking a workspace can link to multiple repos
