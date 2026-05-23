# VCS-Driven Workflow Exercise

**Exam Question:** You are using an HCP Terraform workflow that is connected to a VCS repository (VCS-driven workflow) and want to deploy a new resource. Which sequence of steps follows the recommended workflow?

## Background

HCP Terraform offers three workflow types:

| Workflow | Trigger | Plan & Apply | Best for |
|----------|---------|-------------|----------|
| **VCS-driven** | Git push / PR | Automated in HCP Terraform | Team collaboration, CI/CD |
| **CLI-driven** | Local `terraform plan` | Manual `apply` on local machine | Ad-hoc, development |
| **API-driven** | API call | Automated via API | Custom pipelines, integrations |

This exercise covers the **VCS-driven workflow** — the most common for team environments.

## The VCS-Driven Workflow

### Step 1 — Edit the configuration

A developer clones the repo, edits `main.tf` to add a new resource, and pushes to a feature branch:

```bash
git checkout -b feature/add-bucket
# edit main.tf — add resource "random_pet" "bucket" { ... }
git add main.tf
git commit -m "Add new random_pet resource for bucket naming"
git push origin feature/add-bucket
```

### Step 2 — Open a pull request

The developer opens a PR against `main`. HCP Terraform automatically detects the PR and queues a **speculative plan** — a plan that shows what would happen if the change were applied, without actually applying it.

This plan appears as a comment on the PR and in the HCP Terraform UI.

### Step 3 — Review the plan

Team members review:

- The **code changes** in the PR (traditional code review)
- The **speculative plan output** in HCP Terraform (infrastructure diff)

They discuss and iterate on feedback.

### Step 4 — Approve and apply

Once the plan is approved:

1. The PR is **merged** to `main`
2. HCP Terraform detects the merge event
3. HCP Terraform queues a **new run** with `plan` and `apply` stages
4. If auto-apply is enabled, infrastructure is updated automatically
5. If auto-apply is **disabled**, a user clicks **"Confirm & Apply"** in the HCP Terraform UI

### Diagram

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐     ┌──────────────┐
│ Edit config │ ──> │ Open PR      │ ──> │ Review plan │ ──> │ Merge &      │
│ git push    │     │ (spec plan)  │     │ on PR/UI    │     │ auto-apply   │
└─────────────┘     └──────────────┘     └─────────────┘     └──────────────┘
```

### Put It Together

You are using an HCP Terraform workflow that is connected to a VCS repository (VCS-driven workflow) and want to deploy a new resource. Which sequence of steps follows the recommended workflow?

Select the correct order:

- A. Open a PR → merge → run `terraform apply` locally
- B. Add the resource to the config → open a PR → approve the apply after the plan is generated
- C. Run `terraform plan` locally → open a PR → run `terraform apply` locally
- D. Add the resource to the config → run `terraform apply` → open a PR afterward
- E. Open a PR → add the resource to the config → approve the apply

## Files
- `main.tf` — example configuration (simulates a repo with a workspace)
- `solution/answer.md` — explanation and exam tips
