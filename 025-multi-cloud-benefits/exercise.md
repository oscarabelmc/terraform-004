# Multi-Cloud Benefits Exercise

**Exam Question:** Why is using a single tool like Terraform for multi-cloud deployments more beneficial than using separate tools and workflows for each cloud?

## Background

Organizations often adopt multiple cloud providers (AWS, Azure, GCP) to leverage best-of-breed services, reduce vendor lock-in, or meet geographic/data residency requirements. Without a unified tool, each cloud requires its own workflow, CLI, templating language, and CI/CD setup.

Terraform's HCL provides a **cloud-agnostic** configuration language. The same workflow (`init` → `plan` → `apply`), the same module structure, and the same CI/CD pipeline can target any cloud provider.

## Steps

### Part 1 — Explore a multi-cloud configuration

1. **Open `main.tf`** and examine the providers:

   ```bash
   cat main.tf
   ```

   The same `main.tf` declares resources in **both AWS and Azure** — the same workflow, same file, same tool.

2. **Initialize both providers:**

   ```bash
   terraform init
   ```

   Terraform downloads provider plugins for both AWS and Azure in a single step.

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

   This `naming` module generates a consistent naming convention. Because it only uses Terraform's built-in functions (no cloud-specific resources), it works for **any provider**.

5. **Use the module for both clouds** — the module is called twice in `main.tf`, once for AWS and once for Azure, with different inputs.

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

### Put It Together

Why is using a single tool like Terraform for multi-cloud deployments more beneficial than using separate tools and workflows for each cloud?

- A. It provides a common workflow and reusable modules, enabling consistent CI/CD and policy across clouds
- B. It automatically syncs resources between clouds
- C. It eliminates the need for cloud provider expertise
- D. It runs faster than cloud-native tools
- E. It requires fewer lines of code than any cloud-native template

## Files

- `main.tf` — multi-cloud configuration (AWS + Azure)
- `modules/naming/main.tf` — reusable naming module (cloud-agnostic)
- `variables.tf` — input variables
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
