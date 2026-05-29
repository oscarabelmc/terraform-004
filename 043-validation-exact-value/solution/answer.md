# Explanation

The correct answer is **A**.

> Add a validation block that checks the variable equals 2 and provides an error message if it does not.

---

## Why A Is Correct

A **variable validation block** is the right tool for enforcing exact values because:

1. **Checked early** — validation runs during `terraform validate` and `terraform plan`, before any resources are created
2. **Clear error message** — you provide a descriptive message explaining the requirement
3. **Enforced programmatically** — cannot be bypassed (unlike documentation or conventions)

```hcl
variable "instance_count" {
  type = number

  validation {
    condition     = var.instance_count == 2     # ← exact value check
    error_message = "This module requires exactly 2 instances."  # ← clear message
  }
}
```

Any caller that sets `instance_count` to anything other than `2` gets an immediate error:

```
$ terraform plan -var="instance_count=3"

│ Error: Invalid value for variable
│
│   on variables.tf line 1, in variable "instance_count":
│    1: variable "instance_count" {
│     ├────────────────
│     │ var.instance_count is 3
│
│ This module requires exactly 2 instances.
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — Hardcode `count = 2` and remove variable | This works technically, but removing the variable makes the module **rigid and non-obvious**. A variable with validation is more transparent and self-documenting. |
| C — Add a comment in the README | Documentation is **unenforceable** — users can skip reading it. Validation catches mistakes programmatically before any resources are created. |
| D — Use `depends_on` to ensure exactly 2 instances | `depends_on` controls **ordering**, not **quantity**. It has no effect on how many instances are created. |
| E — Set `default = 2` and rely on users | A default value is **just a default** — users can override it. Validation is the only way to **enforce** that the value stays at 2. |

## Validation for Exact Values vs Allowed Sets

| Constraint | Condition Pattern | Example |
|-----------|------------------|---------|
| **Exact value** | `==` | `var.count == 2` |
| **Exact string** | `==` | `var.env == "production"` |
| **Allowed values** | `contains()` | `contains(["dev", "prod"], var.env)` |
| **Numeric range** | `&&` | `var.count >= 1 && var.count <= 10` |
| **Length check** | `length()` | `length(var.name) > 3` |
| **Pattern match** | `can(regex())` | `can(regex("^[a-z]+$", var.name))` |

## Module Design Best Practices

When building modules with enforced values:

```hcl
variable "instance_count" {
  type = number
  # No default — caller must provide it
  # Validation enforces the exact value

  validation {
    condition     = var.instance_count == 2
    error_message = "This module requires exactly 2 instances."
  }
}
```

**Why use validation instead of hardcoding?**
- The module interface clearly documents the requirement
- Callers get a clear error instead of mysteriously seeing only 2 instances
- The module remains flexible for future updates (change validation constraint instead of refactoring)
- You can add more validations alongside the exact value check
