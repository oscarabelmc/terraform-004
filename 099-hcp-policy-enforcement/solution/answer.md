# Answer

The correct answer is **B**.

> Configure different enforcement levels for each policy set and apply them to the appropriate workspaces or projects.

---

## Why B Is Correct

HCP Terraform allows you to create **multiple policy sets**, each with its own **enforcement level**:

| Policy Set | Enforcement Level | Scope | Behavior on violation |
|------------|:-----------------:|-------|-----------------------|
| `cost-tags-advisory` | `advisory` | Sandbox workspaces | Warning only — run continues |
| `security-mandatory` | `hard-mandatory` | Production workspaces | Run blocked, no override |
| `compliance-flexible` | `soft-mandatory` | Staging workspaces | Run blocked, but overridable |

This design lets you:
- Apply **advisory** policies to non-critical projects (recommendations, cost tracking)
- Apply **hard-mandatory** policies to security-sensitive projects (no exceptions)
- Apply **soft-mandatory** policies where guardrails are needed but exceptions are possible

### How it works

```
HCP Terraform Organization
│
├── Policy Set: "security-mandatory"  (hard-mandatory)
│   └── Attached to: Project "production"
│       └── Workspaces: app-prod, db-prod, net-prod
│
├── Policy Set: "cost-tags-advisory"  (advisory)
│   └── Attached to: Workspaces tagged "cost-tracked"
│       └── Workspaces: dev-*, test-*, sandbox-*
│
└── Policy Set: "encryption-required" (soft-mandatory)
    └── Attached to: Project "staging"
        └── Workspaces: app-staging, db-staging
```

Each policy set runs only on the workspaces it's scoped to, with its configured enforcement level.

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Single mandatory policy set for all workspaces | This would block all runs on all workspaces for any violation. Sandbox projects would be forced to meet production-level compliance, creating unnecessary friction. |
| C — `terraform plan -policy` flag | **No such flag exists.** Policy evaluation in HCP Terraform is configured at the policy set level, not via CLI flags on `terraform plan`. |
| D — Enforcement level in Sentinel file | Sentinel policies do **not** declare their own enforcement level. The enforcement level is set on the **policy set** in HCP Terraform's UI/API, not in the policy code itself. |
| E — Separate organizations per enforcement level | Organizations are for **team/account separation**, not for enforcement levels. You would never create multiple orgs just to vary enforcement — use policy sets within a single org. |

## Enforcement Levels in Detail

| Level | Run blocked? | Overridable? | Use case |
|-------|:-----------:|:-----------:|----------|
| `advisory` | ❌ | N/A | Cost optimization hints, naming convention suggestions, best-practice recommendations |
| `soft-mandatory` | ✅ | ✅ (authorized users can override) | Compliance with exception process, pre-production guardrails |
| `hard-mandatory` | ✅ | ❌ (no override) | Security controls, regulatory compliance (PCI-DSS, HIPAA), data residency rules |

### Soft-mandatory override workflow

```
1. Run triggers policy violation
2. Run is blocked
3. Authorized user reviews violation
4. User clicks "Override & Continue"
5. Run proceeds (override is logged in audit trail)
```

## Exam Tips

- **Policy set** = group of policies with a shared enforcement level and scope
- **Enforcement level** is configured on the **policy set** in HCP Terraform, not in the policy code
- Multiple policy sets can be attached to the same workspace (all are evaluated)
- Policy sets can be scoped to: **specific workspaces**, **projects**, or **entire organization**
- Key phrase: **"varying requirements"** → indicates different enforcement levels are needed
- Common exam trap: thinking enforcement level is set inside the Sentinel policy file
- Another trap: confusing policy sets (compliance checks) with run tasks (external tool integration, exercise #072)
- For the exam, remember the three levels: `advisory`, `soft-mandatory`, `hard-mandatory`
