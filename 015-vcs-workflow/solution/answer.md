# Answer

The correct sequence is **B**:

1. **Add the new resource block to the Terraform configuration in the repo**
2. **Open a pull request with the change**
3. **After the plan is generated, approve the apply in HCP Terraform**

This follows the standard VCS-driven workflow: **Code → PR (spec plan) → Review → Approve → Apply**.

## Step-by-Step Breakdown

| Order | Step | What happens |
|-------|------|-------------|
| **1** | Add resource block to config | Edit the Terraform files in the repository and commit/push to a feature branch |
| **2** | Open a pull request | HCP Terraform detects the new PR and automatically queues a **speculative plan** — a preview of what would change |
| **3** | Approve the apply after the plan is generated | Team reviews the speculative plan output, and once approved, the PR is merged. HCP Terraform then runs the apply (or prompts for confirmation if auto-apply is disabled) |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — PR → merge → `terraform apply` locally | Bypasses the VCS-driven workflow by running apply locally. HCP Terraform cannot track or audit local applies. |
| C — `terraform plan` locally → PR → `terraform apply` locally | This is the **CLI-driven workflow**, not VCS-driven. The question specifically says VCS-driven. The plan is not shared or reviewed in HCP Terraform. |
| D — Add resource → `terraform apply` → open PR | Applies **before** any code review or plan review. Destroys the purpose of having a PR-based workflow. |
| E — Open PR → add resource → approve | The resource must be added to the config **before** the PR is opened. You can't review code that doesn't exist yet. |

## Key Concepts for VCS-Driven Workflow

| Concept | Description |
|---------|-------------|
| **Speculative plan** | A plan run automatically by HCP Terraform when a PR is opened — shows the impact of changes without applying them |
| **Auto-apply** | When enabled, a run is automatically applied after merge without requiring manual confirmation |
| **PR comments** | HCP Terraform posts the speculative plan result directly as a comment on the PR |
| **VCS trigger** | HCP Terraform watches the connected repo for new commits and PRs |
| **Run trigger** | Different from VCS trigger — it's workspace-to-workspace, not code-to-workspace |

## Exam Tips

- The VCS-driven workflow is: **code → PR → speculative plan → review → merge → apply**
- Speculative plans are triggered by **PRs**, not by `terraform plan` locally
- In a VCS-driven workflow, you **never** need to run `terraform plan` or `terraform apply` locally — HCP Terraform handles everything
- If the question says "auto-apply is disabled", there's an explicit approval step after the plan
- The three workflow types: **VCS-driven**, **CLI-driven**, **API-driven** — know which is which
