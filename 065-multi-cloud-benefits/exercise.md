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

   This single configuration defines resources across **three cloud providers**:

   | Provider | Resource | Language |
   |----------|----------|----------|
   | AWS | `aws_vpc`, `aws_subnet`, `aws_instance` | HCL |
   | Azure | `azurerm_resource_group`, `azurerm_virtual_network` | HCL |
   | GCP | `google_compute_network`, `google_compute_subnetwork` | HCL |

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
   resource "aws_instance" "web" {
     ami           = "ami-0c55b159cbfafe1f0"
     instance_type = "t2.micro"
   }

   # Azure — same HCL syntax
   resource "azurerm_linux_virtual_machine" "web" {
     size = "Standard_B2s"
   }

   # GCP — same HCL syntax
   resource "google_compute_instance" "web" {
     machine_type = "e2-micro"
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

- `main.tf` — multi-cloud config with AWS, Azure, and GCP resources
- `outputs.tf` — output values
- `solution/` — reference implementation

