# Module Output Reference Exercise

**Exam Question:** In the snippet below, where does the value for `vpc_security_group_ids` come from?

```hcl
module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.3.0"

  name            = "pr0d-east-app"
  instance_count  = 2
  ami             = "ami-0c5204531f799e5-2"
  instance_type   = "t3.micro"

  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = { Owner = "ref-team", Env = "pr0d-east" }
}
```

## Background

Modules in Terraform can **output** values that other parts of the configuration (including other modules) can reference. These outputs are accessed using the syntax `module.<module_name>.<output_name>`. This enables data flow between modules without tight coupling.

## Steps

### Part 1 — Examine the module references

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   Two modules are defined:

   ```hcl
   module "vpc" { ... }          # Creates VPC + subnets + security groups
   module "ec2_instances" { ... } # Creates EC2 instances
   ```

   The EC2 module references values from the VPC module:

   ```hcl
   vpc_security_group_ids = [module.vpc.default_security_group_id]
   subnet_id              = module.vpc.public_subnets[0]
   ```

### Part 2 — How module outputs work

2. **The VPC module exports outputs:**

   Inside `terraform-aws-modules/vpc/aws`, the module defines:

   ```hcl
   # (inside the VPC module's outputs.tf)
   output "default_security_group_id" {
     value = aws_vpc.main.default_security_group_id
   }

   output "public_subnets" {
     value = aws_subnet.public[*].id
   }
   ```

   These outputs make internal resource attributes available to consumers.

3. **The EC2 module consumes those outputs:**

   ```hcl
   module "ec2_instances" {
     # ...
     vpc_security_group_ids = [module.vpc.default_security_group_id]
     #                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
     #                                    module output reference
   }
   ```

   The reference `module.vpc.default_security_group_id` reads:
   - `module.vpc` → the VPC module instance
   - `.default_security_group_id` → the output named `default_security_group_id` from that module

### Part 3 — The data flow

4. **Visualizing module data flow:**

   ```
   ┌─────────────────────┐         ┌─────────────────────────┐
   │  module "vpc"       │         │  module "ec2_instances" │
   │                     │         │                         │
   │  output             │         │  vpc_security_group_ids │
   │  "default_security_ │  ──────→│  = [module.vpc.         │
   │   group_id" {       │  reads  │      default_security_  │
   │     value = ...     │         │      group_id]          │
   │  }                  │         │                         │
   │                     │         │  subnet_id              │
   │  output             │  ──────→│  = module.vpc.          │
   │  "public_subnets"   │  reads  │      public_subnets[0]  │
   │     value = ...     │         │                         │
   └─────────────────────┘         └─────────────────────────┘
   ```

### Part 4 — Dependencies created by module references

5. **Implicit dependencies across modules:**

   By referencing `module.vpc.default_security_group_id`, the EC2 module creates an **implicit dependency** on the VPC module:

   ```
   Plan order:
   1. module.vpc (all resources)         ← no dependencies on ec2
   2. module.ec2_instances (all resources) ← depends on vpc outputs
   ```

   Terraform ensures the VPC module is fully created before the EC2 module starts provisioning resources.

### Put It Together

In the snippet below, where does the value for `vpc_security_group_ids` come from?

```hcl
module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.3.0"

  name            = "pr0d-east-app"
  instance_count  = 2
  ami             = "ami-0c5204531f799e5-2"
  instance_type   = "t3.micro"

  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = { Owner = "ref-team", Env = "pr0d-east" }
}
```

- A. A hardcoded string in the configuration
- B. An attribute from a data source
- C. The output of another module
- D. A variable defined in the same configuration
- E. A resource attribute from a resource in the same module

## Files

- `main.tf` — config with two modules referencing each other
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
