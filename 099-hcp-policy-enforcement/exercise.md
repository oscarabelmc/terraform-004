# HCP Terraform Policy Enforcement Levels Exercise

**Domain:** HCP Terraform
**Topic:** HCP Terraform policy enforcement levels — advisory vs mandatory

## Description

Your team has multiple infrastructure projects with different compliance requirements. Some projects require advisory policy checks while others need mandatory enforcement. How should you configure policies in HCP Terraform to meet these varying requirements

## Learning Objectives

- Understand policy sets and enforcement levels
- Apply policy sets to workspaces
- Example Sentinel policy with different enforcement
- Configure in HCP Terraform UI or API

## Background

HCP Terraform supports **Policy as Code** using Sentinel (or OPA) to enforce compliance. Policies are grouped into **policy sets**, and each policy set has an **enforcement level** that determines what happens when a policy is violated.

| Enforcement Level | Behavior | Run blocking? |
|------------------|----------|:---:|
| `advisory` | Violations shown as warnings | ❌ No |
| `soft-mandatory` | Violations block the run, authorized users can override | ✅ (overridable) |
| `hard-mandatory` | Violations block the run, **cannot** be overridden | ✅ (final) |

## Steps

### Part 1 — Understand policy sets and enforcement levels

1. **Create two policy sets** — one for advisory checks, one for mandatory enforcement:

   ```
   Policy Set: "cost-tags-advisory"
     │  Enforcement: advisory
     │  Policies: require-cost-center-tag.sentinel
     │  Scope: Workspaces tagged "cost-center-tracked"
     │
   Policy Set: "security-mandatory"
     │  Enforcement: hard-mandatory
     │  Policies: restrict-public-s3.sentinel, enforce-encryption.sentinel
     │  Scope: Workspaces tagged "production"
   ```

2. **How enforcement levels work:**

   - **Advisory** — the policy check runs and violations appear in the run output, but the run **continues**. Use for recommendations, best practices, or cost optimization hints.
   - **Soft-mandatory** — violations block the run, but a user with the "manage policies" permission can **override** the policy and continue the run. Use when exceptions are occasionally needed.
   - **Hard-mandatory** — violations block the run with **no override possible**. Use for security or compliance requirements that must never be bypassed.

### Part 2 — Apply policy sets to workspaces

3. **Scope policy sets to specific workspaces or projects:**

   HCP Terraform lets you attach a policy set to:
   - **Specific workspaces** (by name or tag)
   - **Entire projects** (all workspaces in a project)
   - **All workspaces** in the organization

   ```
   ┌─────────────────────────────────────────┐
   │           Organization                   │
   │  ┌─────────────────────────────────┐    │
   │  │  Project: "production"          │    │
   │  │  ├── Policy Set: "security"    │    │  ← hard-mandatory
   │  │  │   (applies to all workspaces│    │
   │  │  │    in this project)         │    │
   │  │  └── Workspaces: app, db, net  │    │
   │  └─────────────────────────────────┘    │
   │  ┌─────────────────────────────────┐    │
   │  │  Project: "sandbox"             │    │
   │  │  ├── Policy Set: "cost-tags"   │    │  ← advisory
   │  │  │   (applies to workspaces    │    │
   │  │  │    tagged "cost-tracked")   │    │
   │  │  └── Workspaces: dev-*, test-* │    │
   │  └─────────────────────────────────┘    │
   └─────────────────────────────────────────┘
   ```

### Part 3 — Example Sentinel policy with different enforcement

4. **Advisory policy — cost tags (warns but doesn't block):**

   ```sentinel
   # require-cost-center-tag.sentinel
   # Enforcement level: advisory

   import "tfplan"

   main = rule {
     all tfplan.resources as _, resource {
       resource.applied.tags contains "CostCenter"
     }
   }
   ```

   With `advisory` enforcement, a violation shows as:
   ```
   ✓ 1 policy passed
   ✗ 1 policy failed (advisory — run allowed)
   ```

5. **Hard-mandatory policy — no public S3 buckets (blocks the run):**

   ```sentinel
   # restrict-public-s3.sentinel
   # Enforcement level: hard-mandatory

   import "tfplan"

   main = rule {
     all tfplan.resources as _, resource {
       resource.type is not "aws_s3_bucket" or
       not resource.applied.acl contains "public-read"
     }
   }
   ```

   With `hard-mandatory` enforcement, a violation blocks the run:
   ```
   ✗ 1 policy failed (hard-mandatory — run blocked)
   ```

### Part 4 — Configure in HCP Terraform UI or API

6. **Via HCP Terraform UI:**
   - Settings → Policy Sets → Create policy set
   - Upload policy files (Sentinel/OPA)
   - Choose **Enforcement level**: advisory / soft-mandatory / hard-mandatory
   - Scope: attach to workspaces or projects
   - Enable policy set

7. **Via API or `tfe` provider (Terraform):**

   ```hcl
   resource "tfe_policy_set" "security" {
     name          = "security-mandatory"
     organization  = "my-org"
     enforcement_level = "hard-mandatory"
     policies      = [
       file("${path.module}/policies/restrict-public-s3.sentinel"),
       file("${path.module}/policies/enforce-encryption.sentinel"),
     ]
     workspace_ids = [tfe_workspace.prod.id]
   }

   resource "tfe_policy_set" "cost_tags" {
     name          = "cost-tags-advisory"
     organization  = "my-org"
     enforcement_level = "advisory"
     policies      = [
       file("${path.module}/policies/require-cost-center-tag.sentinel"),
     ]
     workspace_ids = [tfe_workspace.sandbox.id]
   }
   ```

## Files

- `main.tf` — Terraform config for a workspace that will have policies applied
- `policies/require-cost-center-tag.sentinel` — example advisory policy
- `policies/restrict-public-s3.sentinel` — example hard-mandatory policy
- `solution/` — reference implementation

