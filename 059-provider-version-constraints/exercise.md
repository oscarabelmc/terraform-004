# Provider Version Constraints Exercise

**Exam Question:** Why should a user specify provider version constraints in their Terraform configuration?

## Background

Providers are developed and released **independently** of Terraform Core. Hashicorp and third-party providers publish new versions on their own schedules. Without version constraints, `terraform init` downloads the **latest** provider version — which may contain breaking changes that break your configuration.

| Concept | Terraform Core | Providers |
|---------|---------------|-----------|
| **Release schedule** | Independent | Independent |
| **Versioning** | 1.x, 2.x | Each provider has its own version (e.g., AWS provider 4.x, 5.x) |
| **Breaking changes** | Major version bumps | Major version bumps, but also minor changes can affect behavior |

## Steps

### Part 1 — Examine version constraints in code

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   Notice the `required_providers` block with version constraints:

   ```hcl
   required_providers {
     aws = {
       source  = "hashicorp/aws"
       version = "~> 5.0"
     }
     random = {
       source  = "hashicorp/random"
       version = "~> 3.5"
     }
   }
   ```

   The `~> 5.0` constraint means "any 5.x version but not 6.0" — a pessimistic version constraint.

### Part 2 — See what happens with and without constraints

2. **Remove the version constraints and observe:**

   Temporarily comment out the `version` lines in `main.tf`, then run:

   ```bash
   terraform init
   ```

   Without a version constraint, Terraform downloads the **latest** provider. If a new major version was released (e.g., AWS provider 6.0), it could introduce changes that break your configuration.

3. **Restore the version constraint and re-init:**

   ```bash
   # Uncomment the version lines, then:
   terraform init -upgrade
   ```

   With the constraint `~> 5.0`, Terraform will only install versions `>= 5.0` and `< 6.0`, protecting against breaking changes in 6.x.

### Part 3 — Understand the version constraint syntax

4. **Common version constraints:**

   | Constraint | Meaning | Example |
   |-----------|---------|---------|
   | `= 5.0.0` | Exact version only | `= 1.2.3` |
   | `~> 5.0` | Any 5.x (>= 5.0, < 6.0) | `~> 5.0` allows 5.1, 5.25, not 6.0 |
   | `~> 5.1` | Any 5.1.x (>= 5.1, < 6.0) | `~> 5.1` allows 5.1.0, 5.1.5, not 5.0 |
   | `>= 5.0, < 6.0` | Range | Explicit lower and upper bound |
   | `>= 5.0` | Minimum version | Any version 5.0 or higher |

5. **Check which providers were installed:**

   ```bash
   ls .terraform/providers/
   ```

   Each provider has a directory named by its source and version number.

### Part 4 — Why separate release schedules matter

6. **Providers evolve independently:**

   - The AWS provider has had major versions 1 through 5+, each with breaking changes
   - Terraform Core went from 0.12 → 0.15 → 1.x
   - A provider may release a new major version that changes resource schemas, attribute names, or required fields

7. **Without version constraints, a repeatable `terraform init` could produce different results over time:**

   ```
   Month 1: terraform init → downloads AWS provider 5.0.0  ✅ Works
   Month 2: terraform init → downloads AWS provider 6.0.0  ❌ Breaks config
   ```

   With version constraints (`~> 5.0`), both months download the latest 5.x version — safe from 6.x breakage.

### Put It Together

Why should a user specify provider version constraints in their Terraform configuration?

- A. Providers require version constraints because they cannot be downloaded without them
- B. Providers are released on a separate schedule from Terraform itself; therefore, a newer version could introduce breaking changes
- C. Version constraints improve the performance of `terraform plan` by reducing API calls
- D. Terraform Core requires all providers to use the same version number
- E. Version constraints are only needed for third-party providers, not official HashiCorp providers

## Files

- `main.tf` — config with version constraints for AWS and random providers
- `outputs.tf` — output values including the constraints
- `solution/answer.md` — explanation and exam tips
