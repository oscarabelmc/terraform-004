# Module Version Argument Exercise

**Domain:** Modules
**Topic:** `version` in module block is optional but recommended

## Description

You're using a module from the Terraform registry for your infrastructure. When defining the configuration, is it necessary to specify a version argument in the module block

## Learning Objectives

- Module block without version
- Add a version constraint
- Observe the effect of omitting version
- Version constraint syntax

## Background

When using a module from the Terraform Registry (or any external source), you can optionally pin a specific version. Without a version constraint, Terraform defaults to the **latest** version of the module, which may introduce unexpected changes on subsequent `terraform init` runs.

## Steps

### Part 1 — Module block without version

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   Notice the module block **does not** specify a `version` argument:

   ```hcl
   module "vpc" {
     source = "terraform-aws-modules/vpc/aws"
     # no version specified
   }
   ```

2. **Initialize:**

   ```bash
   terraform init
   ```

   Terraform downloads the **latest** version of the module from the registry. The resolved version is recorded in `.terraform.lock.hcl`.

### Part 2 — Add a version constraint

3. **Edit `main.tf` to add a version constraint:**

   ```hcl
   module "vpc" {
     source  = "terraform-aws-modules/vpc/aws"
     version = "~> 5.0"
   }
   ```

4. **Re-initialize:**

   ```bash
   terraform init -upgrade
   ```

   Terraform will download version matching `~> 5.0` (any 5.x release). Future `terraform init` calls will respect this constraint instead of upgrading to 6.x.

### Part 3 — Observe the effect of omitting version

5. **Simulate a module upgrade** — if you omit `version` and run `terraform init -upgrade` months later, you get the latest major version. This can include breaking changes.

   With `version = "~> 5.0"`, you stay on 5.x until you explicitly update the constraint.

### Part 4 — Version constraint syntax

6. **Common version constraint patterns:**

   ```hcl
   version = "5.0.0"        # Exact version
   version = ">= 5.0.0"     # Any version >= 5.0.0
   version = "~> 5.0"       # Any 5.x (pessimistic constraint)
   version = ">= 5.0, < 6" # Range
   version = "~> 5.0, < 5.2" # Combined
   ```

## Files

- `main.tf` — module block with and without version constraint
- `outputs.tf` — output values
- `solution/` — reference implementation

