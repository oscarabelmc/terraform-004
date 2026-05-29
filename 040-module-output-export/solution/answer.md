# Explanation

The correct answer is **A**.

> The network module did not define an output block that exports the VPC ID, resulting in the error.

---

## Why A Is Correct

Terraform modules have a **strict access boundary**:

```
┌──────────────────────────────────────┐
│         Root Module                  │
│                                      │
│  module.network.vpc_id   ← ─ ─ ─ ─ ┐│  ✗ Cannot access without output
│                                      │
└──────────────────────────────────────┘
         ▲
         │ Only outputs cross this boundary
         │
┌──────────────────────────────────────┐
│     Child Module (network)          │
│                                      │
│  resource "aws_vpc" "main" {         │
│    id = "vpc-..."        ← internal │
│  }                                   │
│                                      │
│  output "vpc_id" {                   │
│    value = aws_vpc.main.id  ← ─ ─ ─ ┘│  ✅ Exported
│  }                                   │
└──────────────────────────────────────┘
```

**Module outputs are the ONLY way to pass values from a child module to the root module.** Without an output block, the VPC's `id` attribute remains internal to the module.

To fix the error, the network module must export the VPC ID:

```hcl
# In modules/network/outputs.tf
output "vpc_id" {
  value = aws_vpc.main.id
}
```

Then the root module can reference it:

```hcl
# In root main.tf
vpc_id = module.network.vpc_id  # ✅ Now works
```

## Module Access Rules

| Access Pattern | Works? | Reason |
|---------------|--------|--------|
| `module.network.vpc_id` | ✅ | If `vpc_id` is declared as an output in the module |
| `module.network.vpc_id` | ❌ | If `vpc_id` is NOT declared as an output |
| `module.network.aws_vpc.main.id` | ❌ | Resources are private to the module — cannot be referenced directly |
| `module.network.*` | ❌ | Modules don't expose wildcard access to all internals |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — VPC resource doesn't have an `id` attribute | Every `aws_vpc` resource has a computed `id` attribute. This is a fundamental AWS provider attribute. |
| C — Root module needs `depends_on` | `depends_on` controls creation **ordering**, not value accessibility. Module outputs are accessible regardless of `depends_on`. |
| D — Module source is incorrect | A bad source would cause a "module not found" error during `terraform init`, not an "unsupported attribute" error during `plan`. |
| E — Module block needs `version` | The `version` argument is optional. Even without it, module outputs would still work. This error is unrelated to versioning. |

## Output Best Practices

```hcl
# Each output should have:
output "vpc_id" {
  description = "The ID of the VPC"     # ← Always document
  value       = aws_vpc.main.id          # ← The actual value
  sensitive   = false                    # ← Mark true if contains secrets
}
```

**Rule of thumb:** Export anything the root module (or other modules) might need:
- Resource IDs and ARNs
- DNS names and endpoints
- Subnet and security group IDs
- Connection strings and credentials (marked `sensitive = true`)
