# Explanation

The three correct answers are: **A, B, and C**.

> **A** — Apply the variable set to the project.
>
> **B** — Group the team's workspaces into a project.
>
> **C** — Create a variable set that includes the third-party credentials.

---

## Why A, B, and C Are Correct

These three steps work together to share credentials across workspaces without duplication:

```
┌─────────────────────────────────────────────────────────────┐
│                   HCP Terraform Setup                        │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  Step 1: Group workspaces into a project                     │
│  ┌──────────────────────────────────────────────────┐       │
│  │  Project: "app-team-project"                     │       │
│  │  ├── Workspace: app-dev                          │       │
│  │  ├── Workspace: app-stg                          │       │
│  │  └── Workspace: app-prod                         │       │
│  └──────────────────────────────────────────────────┘       │
│                                                               │
│  Step 2: Create a variable set                                │
│  ┌──────────────────────────────────────────────────┐       │
│  │  Variable Set: "third-party-credentials"         │       │
│  │  ├── API_TOKEN = xxx (sensitive)                 │       │
│  │  └── API_SECRET = yyy (sensitive)                │       │
│  └──────────────────────────────────────────────────┘       │
│                           │                                   │
│  Step 3: Apply to project │                                   │
│  ─────────────────────────┘                                   │
│                                                               │
│  Result: All 3 workspaces inherit the credentials             │
└─────────────────────────────────────────────────────────────┘
```

### A — Apply the variable set to the project

Once a variable set is created, it must be **scoped** to where it's needed. Applying it to the project makes it available to all workspaces within that project.

### B — Group workspaces into a project

Projects are the organizational unit for workspace grouping. Without a project, you'd have to attach the variable set to each workspace individually — which defeats the purpose of sharing.

### C — Create a variable set

A variable set bundles related variables (like third-party credentials) into a reusable package. Variables in a set can be marked as **sensitive** to protect their values.

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| D — Store credentials in each workspace's individual variables | This is **manual duplication** — you'd have to enter the same credentials in every workspace. Error-prone and hard to rotate credentials. |
| E — Hardcode credentials in each workspace's Terraform config | Hardcoding secrets in config violates security best practices (secrets in VCS). Also requires changing every workspace's code to rotate credentials. |
| F — Separate organization per workspace | Organizations are for **team/account isolation**, not for individual workspaces. This would create extreme administrative overhead with no benefit. |

## Variable Set Scope Levels

| Level | Applies to | Configuration |
|-------|-----------|---------------|
| **Project** (best for this scenario) | All workspaces in a project | `tfe_project_variable_set` |
| **Specific workspaces** | Listed workspaces only | `tfe_workspace_variable_set` |
| **All workspaces** | Every workspace in the org | `var_set.workspaces = ["*"]` or global toggle in UI |

## Sensitive Variables in Sets

Variable sets support the **sensitive** flag:

```hcl
resource "tfe_variable" "api_token" {
  key          = "API_TOKEN"
  value        = var.third_party_api_token
  category     = "terraform"
  sensitive    = true    # ← Hides value in UI and API responses
  variable_set_id = tfe_variable_set.third_party_creds.id
}
```

Sensitive variables:
- Are masked in the HCP Terraform UI
- Are not shown in run output
- Can still be referenced in configuration
- Are stored encrypted at rest

## Benefits of This Approach

| Benefit | How it's achieved |
|---------|------------------|
| **No duplication** | One variable set, many workspaces |
| **Centralized management** | Update credentials in one place |
| **Easy rotation** | Change the variable set value, all workspaces pick it up |
| **Security** | Sensitive flag masks values; no hardcoding in config |
| **Isolation** | Different projects can have different credential sets |
