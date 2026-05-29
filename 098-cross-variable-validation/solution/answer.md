# Explanation

The correct answer is **B**.

> A validation block on `cluster_endpoint` requires a non-empty value when `create_cluster=false`, so input evaluation failed and Terraform cannot produce a plan.

---

## Why B Is Correct

The `cluster_endpoint` variable has a **validation block** that references `var.create_cluster`:

```hcl
variable "cluster_endpoint" {
  type    = string
  default = ""

  validation {
    condition     = var.create_cluster == false ? length(var.cluster_endpoint) > 0 : true
    error_message = "You must specify a value for cluster_endpoint if create_cluster is false."
  }
}
```

When `create_cluster = false` and `cluster_endpoint = ""`:

1. Terraform evaluates both input variables
2. The validation condition runs: `false ? length("") > 0 : true` → `false ? false : true` → evaluates to `false`
3. Terraform raises the validation error immediately
4. **Plan generation never starts** — the process halts during input evaluation

### Validation evaluation order

```
User provides/omits variable values
        │
        ▼
Terraform evaluates all input variables
        │
        ▼
Validation blocks are checked          ← Error caught here
        │
        ▼
❌ terraform plan / validate fails
   (No plan produced)
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — No default value | `cluster_endpoint` **does** have a default value (`""`). The default is empty, which is a valid string — it just doesn't pass the validation condition when `create_cluster = false`. |
| C — `create_cluster` must be `true` | Setting `create_cluster = true` is one way to avoid the error, but it's not **required**. You can also provide a non-empty `cluster_endpoint` while keeping `create_cluster = false`. |
| D — Requires resource blocks | The config already has resource blocks (`random_pet.cluster`). The error is from variable validation, not missing resources. |
| E — Failed provider API call | The error is a **variable validation error**, not a provider error. No provider API calls are made during input evaluation. |

## Cross-Variable Validation Explained

Validation blocks can reference any variable in the same module using `var.<name>`:

```hcl
variable "password" {
  type      = string
  sensitive = true

  validation {
    condition     = var.create_user ? length(var.password) >= 8 : true
    error_message = "Password must be at least 8 characters when create_user is true."
  }
}
```

This is powerful but has an important constraint:

> **All variables referenced in a validation block must be evaluated before the validation can run.** Terraform evaluates all input variables together, then checks all validation blocks.

### Common patterns

| Pattern | Example |
|---------|---------|
| **Required if** | `var.create ? length(var.value) > 0 : true` |
| **Must match** | `var.enable_https ? var.protocol == "HTTPS" : true` |
| **Mutually exclusive** | `var.use_custom ? var.custom_name != "" : var.default_name != ""` |
| **Range depends on flag** | `var.scaling ? var.max_capacity > var.min_capacity : true` |
