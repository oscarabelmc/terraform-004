# Explanation

The correct answer is **C**.

> Postcondition in the lifecycle block.

---

## Why C Is Correct

A **postcondition** validates a resource's attributes **after** it has been created or updated:

```hcl
lifecycle {
  postcondition {
    condition     = self.network_interface[0].access_config[0].nat_ip != ""
    error_message = "Instance did not receive a public IP address."
  }
}
```

### Why postcondition is the right tool

| Requirement | How postcondition satisfies it |
|-------------|-------------------------------|
| Check after creation | ✅ `postcondition` runs after the resource is created |
| Validate runtime attribute | ✅ `nat_ip` is assigned by GCP at creation time |
| Fail on violation | ✅ Postcondition failures **block further execution** |
| Uses `self` | ✅ `self` refers to the resource's post-creation attributes |

### Execution flow

```
terraform apply
  │
  ├── 1. Create google_compute_instance.web
  │
  ├── 2. Run postcondition
  │      └── self.network_interface[0].access_config[0].nat_ip != ""
  │
  ├── ✅ Condition true: "10.0.0.1" != "" → continue
  │
  └── ❌ Condition false: "" != "" → ERROR, stop apply
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Variable validation | Validates **input variables** before plan/apply. Cannot validate runtime-assigned attributes like public IP, which is determined by the provider during creation. |
| B — Precondition | Runs **before** creating/updating the resource. Cannot validate the result of an operation that hasn't happened yet. |
| D — Check block | Check blocks are **informational only** — they report failures but **do not block** apply. The question requires Terraform to "fail with an error," which check blocks don't do. |
| E — `terraform validate` | Runs offline, checks syntax and schema. It cannot validate runtime attributes that are only known after resource creation. |

## Validation Mechanisms Comparison

| Mechanism | When triggered | Blocks apply? | Use case |
|-----------|---------------|---------------|----------|
| **Variable validation** | During `plan` | ✅ Yes | Validate input values |
| **Check blocks** | During `apply` | ❌ No (warning only) | Informational assertions |
| **Precondition** | Before create/update | ✅ Yes | Validate assumptions before action |
| **Postcondition** | After create/update | ✅ Yes | Verify result of action |
| **`terraform validate`** | Standalone | ✅ Yes (blocks plan) | Syntax and schema checks |

## Postcondition Syntax

```hcl
resource "aws_instance" "example" {
  # ... resource configuration

  lifecycle {
    postcondition {
      condition     = <boolean expression>
      error_message = "<descriptive error message>"
    }
  }
}
```

### Key points

- `condition` must evaluate to `true` or `false`
- `error_message` is shown when the condition fails
- `self` refers to the resource's post-creation attributes
- You can have multiple postconditions
- Postconditions apply to `create`, `read`, and `update` operations
