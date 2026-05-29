# Importing Existing Resources Exercise

**Domain:** IaC Workflow
**Topic:** Import existing resources — write config + import blocks + `apply`

## Description

You deployed resources using the CLI, but want to start managing them with Terraform moving forward. What steps are required to start managing resources with Terraform without impacting the resources themselves? (Select three.)

## Learning Objectives

- Simulate existing "CLI-created" resources
- Write matching config (Answer 3)
- Add import blocks (Answer 1)
- Run `terraform apply` to adopt (Answer 2)

## Background

The scenario: someone already created resources manually (or via CLI). These resources exist in the cloud/disk but **not** in Terraform state. To adopt them, you need to:

1. Write matching config (resource blocks)
2. Add import blocks to map config → real resources
3. Run `terraform apply` to import without changes

## Steps

### Part 1 — Simulate existing "CLI-created" resources

1. **First, create some resources outside of the root module** (simulating "already deployed by CLI"):

   ```bash
   cd modules/existing
   terraform init
   terraform apply -auto-approve
   cd ../..
   ```

2. **Note the resource IDs:**

   ```bash
   terraform output -state=modules/existing/terraform.tfstate server_id
   ```

   These resources exist in reality, but the root `main.tf` has no resource blocks for them.

### Part 2 — Write matching config (Answer 3)

3. **Examine the starter config:**

   ```bash
   cat main.tf
   ```

   It has provider declarations but no resource blocks yet.

4. **Write resource blocks matching the existing resources** — edit `main.tf` to add:

   ```hcl
   resource "random_pet" "server" {
     prefix = "existing"
     length = 2
   }

   resource "local_file" "config" {
     filename = "..."     # use the actual file path from step 2
     content  = "Server: ${random_pet.server.id}"
   }
   ```

   The config must **match** the existing resource's current settings. (For the exam, matching the key attributes is the point.)

### Part 3 — Add import blocks (Answer 1)

5. **Add import blocks** to `main.tf`:

   ```hcl
   import {
     to = random_pet.server
     id = "<actual-server-id-from-step-2>"
   }

   import {
     to = local_file.config
     id = "<actual-file-path>"
   }
   ```

   The `import` block tells Terraform: "There's an existing real resource with this ID; link it to this resource address."

### Part 4 — Run `terraform apply` to adopt (Answer 2)

6. **Initialize and apply:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

   Terraform reads the import blocks, fetches the real resources, writes them to state, and **does not modify them** — the config matches reality.

7. **Verify successful import:**

   ```bash
   terraform state list
   terraform plan
   ```

   The resources are now under Terraform management. `terraform plan` shows **no changes** because the config matches the real resources.

## Files
- `main.tf` — starter configuration (needs resource blocks + import blocks)
- `modules/existing/` — simulates resources created outside Terraform
- `modules/existing/main.tf` — the "manually deployed" resources
- `solution/` — reference implementation
- `solution/` — reference implementation

