# Module Reuse via Variables Exercise

**Exam Question:** A module creates VMs with the vSphere provider. It includes arguments such as `datastore = "DS1"`, `network_label = "VM Network"`, and `folder = "Dev/Apps"`. You need the same module to work in Lab, QA, and Prod vCenter environments without code changes.

What is the most appropriate change to enable the reuse of this module?

## Background

Modules with **hardcoded values** are tied to a single environment. To make a module reusable across environments (Lab, QA, Prod), you must:

1. Replace hardcoded values with **input variables**
2. Provide environment-specific values via **`tfvars` files** or **variable sets**
3. No code changes needed between environments — only variable values change

## Steps

### Part 1 — The problem: hardcoded values

1. **Before — hardcoded module (not reusable):**

   ```hcl
   # ❌ Tied to one environment
   module "vm" {
     source = "./modules/vsphere-vm"
     datastore     = "DS1"
     network_label = "VM Network"
     folder        = "Dev/Apps"
   }
   ```

   To deploy in Lab vs QA vs Prod, you'd need to edit the code each time — error-prone and not scalable.

### Part 2 — The solution: parameterize with variables

2. **After — parameterized module (reusable):**

   ```hcl
   # ✅ Same code works everywhere
   module "vm" {
     source = "./modules/vsphere-vm"
     datastore     = var.datastore
     network_label = var.network_label
     folder        = var.folder
   }
   ```

3. **Root module declares input variables:**

   ```hcl
   variable "datastore"     { type = string }
   variable "network_label" { type = string }
   variable "folder"        { type = string }
   ```

### Part 3 — Provide environment-specific values

4. **Per-environment tfvars files:**

   ```bash
   # Lab deployment:
   terraform plan -var-file="lab.tfvars"

   # QA deployment:
   terraform plan -var-file="qa.tfvars"

   # Prod deployment:
   terraform plan -var-file="prod.tfvars"
   ```

   Each tfvars file contains the values for that environment:

   ```hcl
   # lab.tfvars
   datastore     = "DS-Lab"
   network_label = "VM Network Lab"
   folder        = "Lab/Apps"
   ```

5. **Or use variable sets in HCP Terraform:**

   In HCP Terraform, create a variable set per environment and apply to the relevant workspaces — no need for tfvars files.

### Part 4 — The data flow

6. **How values flow through the parameterized module:**

   ```
   lab.tfvars              Root Module                  Child Module
   ┌──────────────┐       ┌──────────────┐            ┌──────────────────┐
   │ datastore    │ ───→  │ var.datastore│ ───→       │ var.datastore    │
   │   = "DS-Lab" │       │              │            │                  │
   │ network_label│ ───→  │ var.network  │ ───→       │ var.network_label│
   │   = "Lab Net"│       │   _label     │            │                  │
   │ folder       │ ───→  │ var.folder   │ ───→       │ var.folder       │
   │   = "Lab"    │       │              │            └──────────────────┘
   └──────────────┘       └──────────────┘
   ```

   No code changes — only the `.tfvars` file changes between environments.

### Put It Together

A module creates VMs with the vSphere provider. It includes arguments such as `datastore = "DS1"`, `network_label = "VM Network"`, and `folder = "Dev/Apps"`. You need the same module to work in Lab, QA, and Prod vCenter environments without code changes.

What is the most appropriate change to enable the reuse of this module?

- A. Copy the module into separate directories for each environment
- B. Convert the hardcoded values to input variables and provide environment-specific settings via tfvars or variable sets at plan/apply
- C. Use environment variables with the `TF_VAR_` prefix for each environment
- D. Create separate provider configurations for each environment
- E. Use `terraform workspace` to manage environment-specific values

## Files

- `main.tf` — root module with parameterized variables
- `modules/vsphere-vm/main.tf` — child module with variables instead of hardcoded values
- `lab.tfvars` — Lab environment values
- `qa.tfvars` — QA environment values
- `prod.tfvars` — Prod environment values
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
