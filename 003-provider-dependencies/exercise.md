# Provider Dependencies Exercise

**Domain:** IaC Workflow
**Topic:** Provider dependencies — three ways to establish

## Description

In Terraform, how can a dependency on a provider be established? (Select three.)

## Learning Objectives

- Provider declaration creates a dependency
- Resource/data blocks create dependencies
- State entries create dependencies

## Steps

### Part 1 — Provider declaration creates a dependency

1. **Review `main.tf`** — Note the `required_providers` block and the explicit `provider` blocks for both `random` and `local`.

2. **Initialize** — `terraform init` downloads both providers even before any resources exist. The declaration alone is enough.

3. **Comment out all resource blocks** — Temporarily comment out `random_pet.server` and `local_file.server_info`.

4. **Re-initialize** — `terraform init -reconfigure`. Both providers are still downloaded because `required_providers` and `provider` blocks declare the dependency.

5. **Un-comment the resources** before proceeding.

### Part 2 — Resource/data blocks create dependencies

6. **Run `terraform apply -auto-approve`** — Resources are created.

7. **Comment out the `local` resource block only** (`local_file.server_info`).

8. **Run `terraform plan`** — Notice Terraform no longer resolves the `local` provider as a dependency. Only the `random` provider is needed.

9. **Un-comment `local_file.server_info`** before proceeding.

### Part 3 — State entries create dependencies

10. **Run `terraform state list`** — Both `random_pet.server` and `local_file.server_info` are recorded in state.

11. **Remove the `local` provider** — Delete the `local` entry from `required_providers` and remove the `provider "local" {}` block. Then comment out the `local_file.server_info` resource.

12. **Run `terraform plan`** — Terraform still requires the `local` provider even though it's no longer in the config. Why? Because state still tracks `local_file.server_info`.

13. **Remove the resource from state** — `terraform state rm local_file.server_info`.

14. **Run `terraform plan` again** — Now the `local` provider is no longer needed, because no resource references it and nothing in state tracks it.

## Files
- `main.tf` — configuration with two providers and resources
- `solution/` — reference implementation

