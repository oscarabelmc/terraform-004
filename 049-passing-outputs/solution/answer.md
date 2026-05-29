# Explanation

The correct answer is **A**.

> Add an output block to the subnet module and pass the value to the load balancer module using `module.subnets.subnet_id`.

---

## Why A Is Correct

Module outputs are the **only way** to pass data between modules. The flow is:

```
┌─────────────────────┐         ┌───────────────────────────┐
│  module.subnets     │         │  module.load_balancer    │
│                     │         │                           │
│  aws_subnet.main.id   │         │  variable "subnet_id" {  │
│        │            │         │    type = string         │
│        ▼            │         │  }                       │
│  output "subnet_id" │ ──────→ │                           │
│    value = ...main.id │         │  resource "aws_lb" {     │
│                     │         │    subnets = [var.s_id]  │
└─────────────────────┘         └───────────────────────────┘
```

### Step 1: Export from the creating module

```hcl
# modules/subnets/outputs.tf
output "subnet_id" {
  value = aws_subnet.main.id
}
```

This makes `module.subnets.subnet_id` available in the root module.

### Step 2: Reference in the root module

```hcl
# main.tf (root)
module "load_balancer" {
  source    = "./modules/load_balancer"
  subnet_id = module.subnets.subnet_id
}
```

This creates an **implicit dependency** — Terraform knows the subnet must be created before the load balancer.

### Step 3: Receive in the consuming module

```hcl
# modules/load_balancer/variables.tf
variable "subnet_id" {
  type = string
}
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — Reference `aws_subnet.main.id` directly | Resources inside a module are **private** — you cannot reference `aws_subnet.main.id` from outside the module. Modules only expose what they declare in `output` blocks. |
| C — Hardcode the subnet ID | Hardcoding creates a fragile, non-portable configuration. If the subnet changes, you must manually update the hardcoded value. |
| D — Use `terraform output` and env vars | This is a manual, error-prone workaround — not a Terraform-native solution. It bypasses Terraform's dependency graph and state management. |
| E — Create a data source | A data source would read an **already-existing** subnet from AWS, not the one created by the module. It also creates coupling to AWS resource names/tags. |

## The Data Flow Between Modules

```
Root Module
├── module "subnets"
│     ├── variable "vpc_cidr"        ← input
│     ├── variable "subnet_cidr"     ← input
│     ├── aws_vpc.main                 ← internal resource
│     ├── aws_subnet.main              ← internal resource
│     ├── output "vpc_id"            → module.subnets.vpc_id
│     └── output "subnet_id"         → module.subnets.subnet_id  ← used below
│
├── module "load_balancer"
│     ├── variable "vpc_id"     = module.subnets.vpc_id
│     ├── variable "subnet_id"  = module.subnets.subnet_id    ← from subnets module
│     ├── aws_lb.main
│     └── aws_security_group.lb_sg
│
└── output "lb_dns_name"  → root module output
```

**Key rules:**
- **Outputs** go up (child → root)
- **Variables** go down (root → child)
- Root module outputs are the only things visible to the outside (after apply)
- You cannot directly access another module's resources — only its outputs

## Module Output Syntax

```hcl
# Each output block has these elements:
output "<name>" {
  value       = <expression>    # Required: the value to export
  description = "<string>"      # Recommended: what this output represents
  sensitive   = true/false     # Optional: hide from CLI output
  depends_on  = [<resources>]  # Optional: explicit dependencies
}
```
