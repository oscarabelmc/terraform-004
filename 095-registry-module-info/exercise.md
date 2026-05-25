# Terraform Registry Module Information Exercise

**Exam Question:** You discovered a module on the Terraform Registry that will provision the resources you need. What other information can you find on the Terraform Registry to help you quickly use this module? (Select three.)

## Background

The [Terraform Registry](https://registry.terraform.io/) is the primary source for public modules. Each module page provides structured information to help you understand and use the module without reading its full source code.

## Steps

### Part 1 — Examine a registry module usage

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   This uses the `terraform-aws-modules/vpc/aws` module from the registry. The information needed to write this config came from the module's registry page.

### Part 2 — What the registry page provides

2. **Required input variables:**

   Every module page lists **inputs** with:
   - Variable name
   - Type (string, number, bool, list, map, etc.)
   - Required vs optional
   - Default value (if any)
   - Description

   ```hcl
   # From the registry page, you learn you need:
   name = "my-vpc"
   cidr = "10.0.0.0/16"
   azs  = ["us-east-1a", "us-east-1b"]
   ```

3. **Outputs:**

   The registry shows what values the module **returns** so you know what you can reference:

   ```hcl
   # From the registry outputs list, you learn you can access:
   module.vpc.vpc_id
   module.vpc.public_subnets
   module.vpc.private_subnets
   module.vpc.default_security_group_id
   ```

4. **Dependencies:**

   The registry page lists:
   - **Required providers** (e.g., AWS provider `~> 5.0`)
   - **Terraform version** requirements
   - **Related modules** that may be needed together

   ```hcl
   # The registry tells you this module needs:
   required_providers {
     aws = {
       source  = "hashicorp/aws"
       version = ">= 4.0"
     }
   }
   ```

### Part 3 — What the registry does NOT provide

5. **No download button for usage:**

   You don't download registry modules as ZIP files. Instead:

   ```hcl
   # You reference the module in code, and terraform init handles it:
   module "vpc" {
     source  = "terraform-aws-modules/vpc/aws"
     version = "~> 5.0"
   }
   ```

   ```
   ❌ "Download button" is not the way to use registry modules.
   ✅ Just add source and version to your code, then terraform init.
   ```

### Part 4 — Registry page sections

6. **Typical registry module page layout:**

   ```
   ┌───────────────────────────────────────────────┐
   │  Module: terraform-aws-modules/vpc/aws        │
   │  Version: 5.0.0                               │
   ├───────────────────────────────────────────────┤
   │  README          — Overview, usage examples   │
   │  Inputs          — Required + optional vars   │ ← ✅
   │  Outputs         — Values returned            │ ← ✅
   │  Dependencies    — Providers, Terraform ver   │ ← ✅
   │  Resources       — What resources it creates  │
   │  Requirements    — Provider versions needed   │
   └───────────────────────────────────────────────┘
   ```

### Put It Together

You discovered a module on the Terraform Registry that will provision the resources you need. What other information can you find on the Terraform Registry to help you quickly use this module? (Select three.)

- A. Dependencies to use the module
- B. A download button to quickly get the module code
- C. A list of outputs
- D. Required input variables

## Files

- `main.tf` — config using a registry module
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
