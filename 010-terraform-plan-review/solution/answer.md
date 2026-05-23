# Answer

The correct answer is **B — `terraform plan`**.

## Why

`terraform plan` creates an **execution plan** — a detailed diff showing exactly what Terraform will create, modify, replace, or destroy. This output is the primary artifact for infrastructure change review:

- **Team members can review the diff** before any changes are applied
- **Unexpected changes are caught early** (e.g., a stateful resource being replaced when only a trivial change was intended)
- **The plan is deterministic** — given the same state and config, the plan will be identical
- **HCP Terraform formalizes this** with a Plan → Review → Confirm → Apply workflow where runs can be shared, commented on, and approved/rejected in the UI

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — `terraform apply` | This is the **deployment** step, not a review step. Apply executes the plan — by then it's too late for review. |
| C — `terraform validate` | Only checks syntax and config validity. Does not connect to providers, read state, or show what will actually happen to infrastructure. |
| D — `terraform init` | Downloads provider plugins and modules. No review value — it's a prerequisite step. |
| E — `terraform fmt` | Fixes code formatting (indentation, alignment). Does not touch infrastructure or show any changes. |

## Plan Output Review Checklist

When reviewing a `terraform plan` output, look for:

| Symbol | Meaning | Watch out for |
|--------|---------|--------------|
| `+` (green) | Resource will be **created** | Is this resource already deployed outside Terraform? |
| `-` (red) | Resource will be **destroyed** | Is this a stateful resource (database, volume)? |
| `-/+` (yellow) | Resource will be **replaced** (destroy then create) | Can this resource handle replacement gracefully? |
| `~` (blue) | Resource will be **updated in-place** | Are the attribute changes correct? |
| `<nothing>` | No change | Expected? |

## Exam Tips

- `terraform plan` is the **review** step in the standard Terraform workflow: `init → plan → review → apply`
- In HCP Terraform, the plan is called a **"speculative plan"** when triggered by a PR — it allows review without any risk
- The key differentiator: plan shows **what will happen** to infrastructure, not just what the code looks like
- Traditional code review (PR comments on `.tf` files) is good for code style and logic, but `plan` is essential for understanding the **infrastructure impact**
