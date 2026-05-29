# Explanation

The correct answer is **A**.

> During `terraform validate` or `terraform plan`, before attempting to create any resources.

---

## Why A Is Correct

Variable validation is evaluated **during the planning phase**, which both `terraform validate` and `terraform plan` are part of:

```
Input (var.instance_count = 15)
  │
  ▼
Validate variable ────────────→ ❌ Error: "Instance count must be between 1 and 10."
  │
  ▼ (would continue if valid)
Load modules
  │
  ▼
Create dependency graph
  │
  ▼
Plan resources
  │
  ▼
Apply resources
```

The validation block is checked as soon as Terraform evaluates the variable value. This happens:

| Command | Validation Checked? | When |
|---------|-------------------|------|
| `terraform validate` | ✅ | During static validation |
| `terraform plan` | ✅ | Before building the execution plan |
| `terraform apply` | ✅ | Before creating resources (re-validates) |
| `terraform init` | ❌ | No variable evaluation during init |
| `terraform destroy` | ✅ | If variables are referenced during destroy |

The key point: **no resources are created or modified** before the validation runs. The error is reported early, preventing any infrastructure changes from being attempted with invalid inputs.

## How the Validation Block Works

```hcl
variable "instance_count" {
  type = number

  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}
```

| Element | Purpose |
|---------|---------|
| `condition` | Boolean expression — must evaluate to `true` for the value to be valid |
| `error_message` | Custom message shown when the condition is `false` |

Multiple validation blocks are allowed per variable — all conditions must pass:

```hcl
variable "name" {
  type = string

  validation {
    condition     = length(var.name) > 2
    error_message = "Name must be at least 3 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z]", var.name))
    error_message = "Name must start with a letter."
  }
}
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — During `terraform apply` | Validation runs **before** apply, during the planning phase. Apply never gets reached with an invalid value. |
| C — During `terraform destroy` | Destroy doesn't set new variable values (it uses the existing state). Validation applies to new inputs, not destroy operations. |
| D — During `terraform init` | `terraform init` initializes providers and modules — it doesn't evaluate variable values. No validation runs during init. |
| E — Only during `validate`, not `plan` | Validation runs during **both** `validate` and `plan`. Both commands evaluate variables and check conditions before proceeding. |

## Validation Function Reference

| Function | Purpose | Example |
|----------|---------|---------|
| `contains()` | Check value is in a list | `contains(["dev", "prod"], var.env)` |
| `length()` | Check string/list length | `length(var.name) > 3` |
| `can()` | Check expression succeeds | `can(regex("...", var.input))` |
| `try()` | Try expression, fallback on error | `try(var.input, "default")` |
| `regex()` | Match pattern | `regex("^[a-z]+$", var.name)` |
| `range()` | Check numeric range | `var.count >= 1 && var.count <= 10` |
