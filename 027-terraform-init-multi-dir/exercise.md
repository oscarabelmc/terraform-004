# Terraform Init in Multiple Directories Exercise

**Domain:** IaC Workflow
**Topic:** `terraform init` in multi-directory environments

## Description

You have a Terraform project with multiple subdirectories: `/dev`, `/staging`, and `/prod`. Each directory contains a separate Terraform configuration for each different environment. Before deploying resources, where do you need to run `terraform init`

## Learning Objectives

- Examine the project structure
- Try running init only in the root
- Initialize each environment directory

## Background

`terraform init` initializes a **working directory** — it downloads provider plugins, installs modules, and configures the backend. It does **not** traverse into subdirectories. Each directory with its own `*.tf` files is a separate working directory with its own `.terraform/` folder and state.

This exercise demonstrates that pattern with three environments.

## Steps

### Part 1 — Examine the project structure

1. **List the directories:**

   ```bash
   ls -R
   ```

   ```
   .
   ├── main.tf
   ├── dev/
   │   └── main.tf
   ├── staging/
   │   └── main.tf
   └── prod/
       └── main.tf
   ```

   Each environment has its own `main.tf` with environment-specific resources.

2. **Read the environment configs:**

   ```bash
   cat dev/main.tf
   cat staging/main.tf
   cat prod/main.tf
   ```

   Each uses the `random_pet` provider but with environment-specific naming.

### Part 2 — Try running init only in the root

3. **Initialize only the root directory:**

   ```bash
   terraform init
   ```

   This creates `.terraform/` in the current directory only.

4. **Attempt to run `terraform plan` in a subdirectory without init:**

   ```bash
   cd dev
   terraform plan
   ```

   This will fail because `dev/` hasn't been initialized:

   ```
   │ Error: Inconsistent dependency lock file
   │
   │ The given plan file was generated with a different version of the
   │ dependency lock file .terraform.lock.hcl.
   ```

   or more commonly:

   ```
   │ Error: Could not load plugin
   │
   │ Plugin reinitialization required. Please run "terraform init".
   ```

### Part 3 — Initialize each environment directory

5. **Initialize and plan in each environment:**

   ```bash
   cd /home/terraform-004/027-terraform-init-multi-dir
   terraform init          # root
   cd dev && terraform init && terraform plan && cd ..
   cd staging && terraform init && terraform plan && cd ..
   cd prod && terraform init && terraform plan && cd ..
   ```

   Each `terraform init` creates a separate `.terraform/` directory with its own provider plugins and state.

## Files

- `main.tf` — root-level config
- `dev/main.tf` — dev environment
- `staging/main.tf` — staging environment
- `prod/main.tf` — prod environment
- `solution/` — reference implementation

