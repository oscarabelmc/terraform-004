# Answer

The correct answer is **B**.

> Terraform creates an execution plan and determines what changes are required to achieve the desired state in the configuration files.

---

## Why B Is Correct

`terraform plan` is the **read-only preview** step in the Terraform workflow:

```
┌──────────────────────────────────────────────────────────┐
│                   terraform plan                          │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  1. Parse configuration files                            │
│  2. Read current state (local or remote backend)         │
│  3. Read provider schemas                                │
│  4. Compare config (desired) vs state (current)          │
│  5. Generate execution plan:                             │
│     ├── Resources to create (+)                          │
│     ├── Resources to update (~)                          │
│     └── Resources to destroy (-)                         │
│  6. Output the plan                                      │
│                                                          │
│  ⚠️  NO changes are made to infrastructure              │
│  ⚠️  NO changes are made to state                        │
│  ⚠️  NO confirmation prompt (that's apply)               │
└──────────────────────────────────────────────────────────┘
```

### The execution plan

The plan output answers three questions:

| Question | How plan answers |
|----------|-----------------|
| **What will change?** | Lists every resource action (create/update/destroy/replace) |
| **Why will it change?** | Shows attribute-level diffs (old → new values) |
| **How many changes?** | Summary: "Plan: X to add, Y to change, Z to destroy" |

### With remote state

When using a remote backend (S3, HCP Terraform, etc.), `terraform plan` with default settings:
1. Reads the **remote state file** (e.g., from S3)
2. Performs a **refresh** — queries provider APIs to get current resource attributes
3. Compares the refreshed state with the configuration
4. Produces the execution plan

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Immediately applies changes | That's `terraform apply`, not `plan`. Plan is a preview — it never applies anything. |
| C — Destroys and recreates | Plan only **shows** what would be destroyed/recreated — it doesn't execute those actions. Only apply does. |
| D — Updates state | Plan is **read-only** with respect to state. It reads state but does not modify it. `terraform refresh` syncs state without changing config. |
| E — Prompts for confirmation and applies | Confirmation prompts are part of `terraform apply`, not `plan`. Plan exits without any prompt. |

## Plan Output Examples

**Initial plan (all creates):**
```
Plan: 4 to add, 0 to change, 0 to destroy.
```

**After modifying `instance_type` from `t2.micro` to `t3.medium`:**
```
Plan: 0 to add, 2 to change, 0 to destroy.

  # aws_instance.web[0] will be updated in-place
  ~ resource "aws_instance" "web" {
      ~ instance_type = "t2.micro" -> "t3.medium"
    }

  # aws_instance.web[1] will be updated in-place
  ~ resource "aws_instance" "web" {
      ~ instance_type = "t2.micro" -> "t3.medium"
    }
```

**After removing a resource from config:**
```
Plan: 0 to add, 0 to change, 1 to destroy.

  # aws_subnet.public will be destroyed
  - resource "aws_subnet" "public" {
      - cidr_block = "10.0.1.0/24"
    }
```

## Saving and Applying a Plan

```bash
# Save plan to a file (for review or apply later)
terraform plan -out=plan.tfplan

# Apply a saved plan
terraform apply plan.tfplan
```

This is useful for:
- Reviewing plans in CI/CD pipelines
- Ensuring the exact reviewed plan is applied
- Passing plans between team members

## Objective Reference

This question tests the fundamental understanding of the **Plan** step in the Terraform core workflow (Objective 3a).

## Exam Tips

- `terraform plan` = **read-only preview** — never modifies anything
- Plan compares **config (desired)** vs **state (current)**
- Plan output shows `+` (create), `~` (update), `-` (destroy), `-/+` (replace)
- With default settings, plan includes a **refresh** (queries provider APIs)
- Plan does NOT require confirmation
- Plan does NOT modify state
- Common exam trap: thinking plan applies changes or modifies state
- Another trap: confusing plan with apply or refresh
