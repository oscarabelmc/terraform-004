# Explanation

The correct answer is **C**.

> The output of another module.

---

## Why C Is Correct

The expression `module.vpc.default_security_group_id` is a **module output reference**:

```hcl
vpc_security_group_ids = [module.vpc.default_security_group_id]
                          │         │
                          │         └── Output name from the VPC module
                          └── Module identifier
```

This syntax accesses the **output** named `default_security_group_id` that was exported by the `module "vpc"` block. Module outputs are defined in the module's `outputs.tf`:

```hcl
# Inside terraform-aws-modules/vpc/aws (outputs.tf):
output "default_security_group_id" {
  description = "The ID of the security group created by default"
  value       = aws_vpc.main.default_security_group_id
}
```

### The reference chain

```
module "vpc" defines:
  output "default_security_group_id" {
    value = aws_vpc.main.default_security_group_id  ← resource attribute
  }

module "ec2_instances" references:
  module.vpc.default_security_group_id              ← module output
```

Terraform resolves this at plan time:
1. Provisions the VPC module's resources
2. Reads the output value from the VPC module
3. Passes that value as the `vpc_security_group_ids` argument to the EC2 module
4. Provisions the EC2 module's resources

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Hardcoded string | The value is dynamically read from another module, not hardcoded. Hardcoding would be `vpc_security_group_ids = ["sg-12345"]`. |
| B — Data source attribute | A data source reference uses `data.<type>.<name>.<attribute>` syntax (e.g., `data.aws_security_group.default.id`). This is a module reference, not a data source. |
| D — Variable in same config | Variable references use `var.<name>` syntax. This uses `module.vpc.<output>`, which is a module output reference. |
| E — Resource attribute from within the same module | Resources within the same module use `<type>.<name>.<attribute>` syntax (e.g., `aws_vpc.main.id`). The `module.` prefix makes it an inter-module reference. |

## Module Output Reference Syntax

```
module.<MODULE_NAME>.<OUTPUT_NAME>

Examples:
module.vpc.vpc_id                         # String output
module.vpc.public_subnets                 # List(string) output
module.vpc.public_subnets[0]              # First element of list output
module.vpc.default_security_group_id      # String output
module.sg.security_group_arn              # String output
module.s3.bucket_id                       # String output
```

## Module Data Flow Patterns

```
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│  module "vpc"    │     │  module "sg"     │     │  module "ec2"    │
│                  │     │                  │     │                  │
│  vpc_id ─────────┼───→ │ vpc_id (input)   │     │ sg_id (input)    │
│  default_sg ─────┼───→ │                  │───→ │ subnet_id (input)│
│  subnets ────────┼───→ │                  │     │                  │
└──────────────────┘     └──────────────────┘     └──────────────────┘
```

### Implicit dependency chain

```hcl
module "vpc" { ... }           # Level 0: no module dependencies
module "sg" {                  # Level 1: depends on module.vpc
  vpc_id = module.vpc.vpc_id
}
module "ec2" {                 # Level 2: depends on module.sg + module.vpc
  sg_id    = module.sg.sg_id
  subnet_id = module.vpc.public_subnets[0]
}
```

Terraform builds a dependency graph across modules and creates resources in the correct order.
