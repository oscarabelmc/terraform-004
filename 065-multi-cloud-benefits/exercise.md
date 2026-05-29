# Multi-Cloud Benefits Exercise

**Domain:** IaC Concepts
**Topic:** Multi-cloud benefits of Terraform

## Description

What benefits would you see by using a multi-cloud and provider-agnostic tool like Terraform? (Select two.)

## Learning Objectives

- Examine a multi-cloud config
- The consistent workflow
- Benefits of provider-agnostic IaC
- What Terraform does NOT do

## Background

Terraform is a **provider-agnostic** infrastructure as code tool. The same HCL syntax, the same CLI commands (`init`, `plan`, `apply`, `destroy`), and the same workflow work across all supported providers — AWS, Azure, GCP, and hundreds more.

## Steps

### Part 1 — Examine a multi-cloud config

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   This single configuration defines resources **conceptually representing** three cloud providers:

   | Provider | Resource | Language |
   |----------|----------|----------|
   | AWS | `random_pet.aws_vpc`, `random_pet.aws_subnet`, `random_pet.aws_instance` | HCL |
   | Azure | `random_pet.azure_rg`, `random_pet.azure_vnet` | HCL |
   | GCP | `random_pet.gcp_network`, `random_pet.gcp_subnet` | HCL |

   All use the **same HCL syntax**, the **same workflow**, and are managed by the **same tool**.

### Part 2 — The consistent workflow

2. **Same commands for every provider:**

   ```bash
   terraform init      # Downloads all provider plugins
   terraform plan      # Shows what will change across all clouds
   terraform apply     # Creates resources on all clouds
   terraform destroy   # Tears down everything
   ```

   Whether you're managing AWS, Azure, GCP, or all three, the commands are identical.

### Part 3 — Benefits of provider-agnostic IaC

3. **Benefit 1: Reduced operational overhead**

   - Single tool to learn → lower training costs
   - Consistent CI/CD pipelines across clouds
   - One set of governance policies (policy as code with Sentinel/OPA)
   - Teams can move between cloud projects without learning new IaC tools

4. **Benefit 2: Consistent declarative workflow**

   ```hcl
   # AWS — same HCL syntax
   resource "random_pet" "aws_instance" {
     prefix = "aws-web"
     length = 2
   }

   # Azure — same HCL syntax
   resource "random_pet" "azure_vnet" {
     prefix = "azure-vnet"
     length = 2
   }

   # GCP — same HCL syntax
   resource "random_pet" "gcp_network" {
     prefix = "gcp"
     length = 2
   }
   ```

   The **language** (HCL) and **workflow** (init/plan/apply) are identical. Only the resource types and provider-specific attributes change.

### Part 4 — What Terraform does NOT do

5. **Terraform does NOT standardize pricing or billing:**

   ```
   ❌ "Programmatically standardizes pricing and usage models across all clouds"
   ```

   Each provider has its own pricing model (on-demand, reserved, spot), billing structure, and cost calculations. Terraform does not abstract or standardize these.

6. **Terraform does NOT remove the need for provider credentials:**

   ```
   ❌ "Removes the need for provider-specific credentials or authentication flows"
   ```

   Each provider requires its own authentication:

   | Provider | Credential method |
   |----------|------------------|
   | AWS | `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` |
   | Azure | `ARM_CLIENT_ID` / `ARM_CLIENT_SECRET` |
   | GCP | `GOOGLE_APPLICATION_CREDENTIALS` |

   Terraform does not eliminate these — it expects them to be configured per provider.

## Files

- `main.tf` — multi-cloud config with simulated AWS, Azure, and GCP resources
- `outputs.tf` — output values
- `solution/` — reference implementation

