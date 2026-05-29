# Explanation

The correct answers are **A**, **B**, and **D**.

> **A.** All current and future workspaces and Stacks within a project using a variable set.
>
> **B.** Multiple workspaces with a variable set.
>
> **D.** A single workspace by defining variables directly in that workspace.

---

## Why A, B, and D Are Correct

HCP Terraform provides three levels of variable scope:

```
┌────────────────────────────────────────────────────────────┐
│               HCP Terraform Variable Scopes                 │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  D - Single Workspace                                      │
│  ┌────────────────────────────────────────────────────┐    │
│  │  Variables defined directly in workspace settings  │    │
│  │  Scope: one workspace only                         │    │
│  │  Example: environment = "production"               │    │
│  └────────────────────────────────────────────────────┘    │
│                                                            │
│  B - Variable Set (selected workspaces)                    │
│  ┌────────────────────────────────────────────────────┐    │
│  │  Variables grouped in a set, applied to specific   │    │
│  │  workspaces. Update once, affects all assigned.    │    │
│  │  Example: aws_region = "us-east-1"                 │    │
│  └────────────────────────────────────────────────────┘    │
│                                                            │
│  A - Global Variable Set (all workspaces in project)       │
│  ┌────────────────────────────────────────────────────┐    │
│  │  Variables applied to all current and future       │    │
│  │  workspaces in the project.                        │    │
│  │  Example: common_tags, provider credentials        │    │
│  └────────────────────────────────────────────────────┘    │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### A — Global variable set (all workspaces in a project)

Apply a variable set to **all current and future workspaces and Stacks** within a project:

```hcl
# In HCP Terraform UI:
# Settings → Variable Sets → "Apply globally"
#
# All workspaces in the project automatically get:
variable "common_tags" {
  default = {
    ManagedBy = "Terraform"
    Owner     = "platform-team"
   }
}
```

- New workspaces inherit these variables automatically
- Ideal for organization-wide defaults
- Scoped to a **single organization/project** — not across organizations

### B — Variable set (multiple selected workspaces)

Create a variable set and assign it to specific workspaces:

```
Variable Set: "AWS Region Config"
  aws_region = "us-east-1"

  Applied to:
  ├── dev
  ├── staging
  └── production
```

- Update the variable set → all assigned workspaces get the change
- Workspaces can be in different projects within the same organization

### D — Single workspace variables

Define variables directly in a workspace:

```
Workspace: production
  Variable: environment = "production"
  Variable: instance_type = "t3.large"
```

- Most specific scope
- Overrides any conflicting variable set values
- Not shared with other workspaces

## Why the Incorrect Option Is Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| C — All workspaces across multiple organizations | Variable sets are scoped to a **single organization**. You cannot apply a variable set across different HCP Terraform organizations. Each organization is an isolated boundary with its own settings, workspaces, and variable sets. |

## Variable Precedence

```
Highest priority
    │
    ▼
┌────────────────────────────────────┐
│  Workspace-level variables         │  ← Most specific
├────────────────────────────────────┤
│  Variable set (selected workspaces)│
├────────────────────────────────────┤
│  Global variable set (all worksp.) │  ← Most broad
└────────────────────────────────────┘
    │
    ▼
Lowest priority
```

## Variable Set Use Cases

| Scope | Use case | Example variables |
|-------|----------|-------------------|
| **Single workspace** | Environment-specific values | `environment = "prod"`, `instance_type` |
| **Variable set (multiple)** | Shared configuration | `aws_region`, `vpc_cidr`, `ssh_key` |
| **Global variable set** | Organization defaults | `common_tags`, `provider_credentials` |

## Objective Reference

**Objective 8c** — Describe how to organize and use HCP Terraform workspaces and projects.

HCP Terraform supports three variable scope levels:
1. Single workspace (direct)
2. Variable set (selected workspaces)
3. Global variable set (all workspaces in project)

Variables cannot span organizations.
