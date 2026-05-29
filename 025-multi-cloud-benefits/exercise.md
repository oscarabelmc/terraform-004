# Multi-Cloud Benefits Exercise

**Domain:** IaC Concepts
**Topic:** Single tool for multi-cloud deployments

## Description

Why is using a single tool like Terraform for multi-cloud deployments more beneficial than using separate tools and workflows for each cloud

## Learning Objectives

- Explore a multi-cloud configuration
- Demonstrate reusable modules across clouds
- CI/CD consistency

## Background

Organizations often adopt multiple cloud providers (AWS, Azure, GCP) to leverage best-of-breed services, reduce vendor lock-in, or meet geographic/data residency requirements. Without a unified tool, each cloud requires its own workflow, CLI, templating language, and CI/CD setup.

Terraform's HCL provides a **cloud-agnostic** configuration language. The same workflow (`init` → `plan` → `apply`), the same module structure, and the same CI/CD pipeline can target any cloud provider.

## Steps

### Part 1 — Explore a multi-cloud configuration

1. **Open `main.tf`** and examine the providers:

   ```bash
   cat main.tf
   ```

   The same `main.tf` uses a `random` provider called from **two module instances** — the same workflow, same file, same tool.

2. **Initialize the provider:**

   ```bash
   terraform init
   ```

   Terraform downloads the provider plugin in a single step.

3. **Generate a plan:**

   ```bash
   terraform plan
   ```

   The plan shows resources across both clouds — a unified view of what would change.

### Part 2 — Demonstrate reusable modules across clouds

4. **Examine the shared module:**

   ```bash
   cat modules/naming/main.tf
   ```

   This `naming` module generates a consistent naming convention. Because it uses a cloud-agnostic `random_pet` resource, it works for **any provider**.

5. **Use the module for both clouds** — the module is called twice in `main.tf`, once for each environment, with different inputs.

### Part 3 — CI/CD consistency

6. **Build a common CI/CD workflow:**

   The same commands work for any cloud:

   ```bash
   terraform init      # install providers + modules
   terraform validate  # check syntax
   terraform plan      # preview changes
   terraform apply     # deploy
   ```

   Compare this to using separate tools: AWS CloudFormation requires a different pipeline than Azure Resource Manager templates or Google Cloud Deployment Manager.

## Files

- `main.tf` — multi-cloud configuration (AWS + Azure)
- `modules/naming/main.tf` — reusable naming module (cloud-agnostic)
- `variables.tf` — input variables
- `outputs.tf` — output values
- `solution/` — reference implementation

