# Module Provider Configurations Exercise

**Domain:** Modules
**Topic:** Provider configurations in modules — inheritance, explicit passing, restrictions

## Description

Which statements are true about provider configurations in modules? (Select three.)

## Learning Objectives

- Default provider inheritance
- Explicit provider passing with `providers` argument
- Provider blocks in modules
- When to use each approach
- Verify with the config

## Background

Provider configuration in modules follows specific rules:

- Child modules **inherit** default provider configurations from the parent
- The `providers` argument in a `module` block allows **explicit** passing of provider configurations
- Modules that contain `provider` blocks **cannot** be used with `for_each`, `count`, or `depends_on`

These rules enable flexible provider management while maintaining module reusability.

## Steps

### Part 1 — Default provider inheritance

1. **Examine the root module:**

   ```bash
   cat main.tf
   ```

   The root module defines a default `aws` provider:

   ```hcl
   provider "aws" {
     region = "us-east-1"
   }

   module "vpc" {
     source = "./modules/vpc"
   }
   ```

2. **Examine the child module:**

   ```bash
   cat modules/vpc/main.tf
   ```

   The child module does **not** define a `provider` block. It uses the `aws` provider automatically inherited from the root.

   ```hcl
   resource "aws_vpc" "main" {
     cidr_block = "10.0.0.0/16"
   }
   ```

   **Automatic inheritance:** child modules automatically receive the default provider configuration from their parent. No explicit passing needed.

### Part 2 — Explicit provider passing with `providers` argument

3. **Examine the multi-region config:**

   ```bash
   cat modules/vpc-us-east/main.tf
   cat modules/vpc-us-west/main.tf
   ```

   Two child modules need different provider configurations (different regions):

   ```hcl
   # Root module
   provider "aws" {
     alias  = "east"
     region = "us-east-1"
   }

   provider "aws" {
     alias  = "west"
     region = "us-west-2"
   }

   module "vpc_east" {
     source    = "./modules/vpc"
     providers = {
       aws = aws.east
     }
   }

   module "vpc_west" {
     source    = "./modules/vpc"
     providers = {
       aws = aws.west
     }
   }
   ```

   The `providers` argument maps provider configuration names in the child module to specific provider configurations in the parent.

### Part 3 — Provider blocks in modules

4. **Examine a module with its own provider block:**

   ```bash
   cat modules/provider-child/main.tf
   ```

   ```hcl
   # modules/provider-child/main.tf
   terraform {
     required_providers {
       aws = {
         source  = "hashicorp/aws"
         version = "~> 5.0"
       }
     }
   }

   provider "aws" {
     region = "eu-west-1"
   }

   resource "aws_instance" "web" {
     ami = "ami-abc123"
   }
   ```

5. **Understand the restriction:**

   A module containing `provider` blocks is **not compatible** with `count`, `for_each`, or `depends_on`:

   ```hcl
   # This will NOT work:
   module "multi" {
     source    = "./modules/provider-child"
     for_each  = var.regions    # ❌ Error
     providers = {
       aws = aws.each.value     # ❌ Would need this
     }
   }
   ```

   Why? Because Terraform needs to resolve provider configurations at graph construction time. When a module contains its own `provider` blocks, the provider cannot be configured dynamically per-instance. The provider is fixed to whatever the module defines, making it incompatible with meta-arguments that create multiple instances.

### Part 4 — When to use each approach

6. **Decision flow:**

   ```
   Does the child module need a non-default provider?
        │
        ├── No  → Rely on automatic inheritance (no changes needed)
        │
        └── Yes → Use the `providers` argument in the module block
                    │
                    ├── Does the child module HAVE provider blocks?
                    │     ├── Yes → It CANNOT use for_each/count/depends_on
                    │     │          Refactor: remove provider blocks,
                    │     │          pass via `providers` argument instead
                    │     └── No  → Use `providers` with aliased provider configs
                    │
                    └── Can also configure providers only in root
                        and inherit everywhere
   ```

### Part 5 — Verify with the config

7. **Initialize and plan the working examples:**

   ```bash
   terraform init
   terraform plan
   ```

   Both the inherited and explicitly-passed provider configurations work correctly.

## Files

- `main.tf` — root module showing default + explicit provider passing
- `modules/child/main.tf` — child module without provider blocks (inherits from parent)
- `modules/provider-child/main.tf` — child module WITH provider blocks (incompatible with for_each)
- `outputs.tf` — output values
- `solution/` — reference implementation

