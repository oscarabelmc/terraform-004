# Terraform Import CLI — Write Config First Exercise

**Domain:** IaC Workflow
**Topic:** Before `terraform import`, write matching resource blocks first

## Description

You want to start managing resources that were not originally provisioned through infrastructure as code. Before you can import the resources, what must you do before running the `terraform import` command

## Learning Objectives

- Understand the legacy import workflow
- Simulate existing resources
- Write matching configuration (the required first step)
- Run `terraform import` CLI
- Compare legacy CLI vs config-driven import

## Background

The `terraform import` CLI command (available since Terraform 0.7+) is the legacy way to bring existing resources under Terraform management. Unlike the modern config-driven approach with `import` blocks, the CLI command is a standalone, imperative operation.

**Critical rule:** Before running `terraform import <resource_type>.<name> <id>`, you must first write a matching `resource` block in your configuration. Without it, the import command has nowhere to store the imported state.

## Steps

### Part 1 — Understand the legacy import workflow

1. **The two-step process for `terraform import` CLI:**

   ```
   Step 1: Write resource blocks matching existing resources ← THIS MUST COME FIRST
   Step 2: Run terraform import <address> <id>
   ```

   The `resource` block tells Terraform what type and name to use for the resource in state. Without it, Terraform doesn't know *where* to import the resource.

2. **What happens if you skip Step 1:**

   ```bash
   terraform import random_pet.server existing-abc123
   ```

   If no `resource "random_pet" "server"` block exists in your config, Terraform returns:
   ```
   Error: resource address "random_pet.server" does not exist in the configuration.
   ```

### Part 2 — Simulate existing resources

3. **Create resources outside of Terraform (simulated):**

   ```bash
   cd modules/existing
   terraform init
   terraform apply -auto-approve
   cd ../..
   ```

4. **Note the resource IDs:**

   ```bash
   terraform output -state=modules/existing/terraform.tfstate
   ```

   You'll need these IDs for the import command.

### Part 3 — Write matching configuration (the required first step)

5. **Examine the root config:**

   ```bash
   cat main.tf
   ```

   It has provider declarations but no resource blocks yet.

6. **Add resource blocks matching the existing resources — edit `main.tf`:**

   ```hcl
   resource "random_pet" "server" {
     prefix = "existing"
     length = 2
   }

   resource "local_file" "config" {
     filename = "${path.module}/server-config.txt"
     content  = "Server: ${random_pet.server.id}"
   }
   ```

   The config must **match** the existing resource's settings. If it doesn't, Terraform will plan changes after import.

### Part 4 — Run `terraform import` CLI

7. **Initialize Terraform:**

   ```bash
   terraform init
   ```

8. **Run `terraform import` for each resource:**

   ```bash
   terraform import random_pet.server <server-id-from-step-4>
   terraform import local_file.config <file-path-from-step-4>
   ```

   Unlike config-driven import, the CLI command:
   - Imports **immediately** — no plan preview
   - Must be run **once per resource** — no batching
   - Does **not** prompt for confirmation

9. **Verify the import:**

   ```bash
   terraform state list
   terraform plan
   ```

   `terraform plan` should show **no changes** because the config matches reality.

### Part 5 — Compare legacy CLI vs config-driven import

10. **Key differences:**

    | Aspect | Legacy `terraform import` CLI | Config-driven `import` block |
    |--------|------------------------------|------------------------------|
    | **Config first?** | Yes — must write resource blocks first | Yes — resource + import block both in config |
    | **Command** | `terraform import <addr> <id>` | `terraform plan` then `terraform apply` |
    | **Review before import?** | No — imports immediately | Yes — plan previews the import |
    | **Repeatable?** | No — ephemeral CLI command | Yes — block is version-controlled |
    | **Granularity** | One resource per command | Multiple resources in one apply |
    | **Terraform version** | 0.7+ (legacy) | 1.5+ (modern, preferred) |

## Files

- `main.tf` — starter configuration (needs resource blocks)
- `outputs.tf` — output values
- `modules/existing/` — simulates resources created outside Terraform
- `modules/existing/main.tf` — the "manually created" resources
- `solution/` — reference implementation

