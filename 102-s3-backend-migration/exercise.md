# S3 Backend Migration Exercise

**Domain:** State Management
**Topic:** S3 backend configuration and state migration

## Description

You're moving a project to a remote backend so the state is stored in Amazon S3. How do you correctly configure and initialize the backend

## Learning Objectives

- Examine the starting config (local state)
- Add the S3 backend configuration
- Run `terraform init` to migrate
- Understand what `init` does with backends
- Other backend initialization flags

## Background

By default, Terraform stores state locally in `terraform.tfstate`. To use a remote backend (like S3), you must:

1. Add a `backend "s3"` block inside the `terraform` block
2. Run `terraform init` — which detects the change and offers to **migrate** the state

```
Current: local backend (terraform.tfstate)
            │
            │  Add backend "s3" { ... } block
            │  Run terraform init
            ▼
New: S3 backend (bucket: my-company-terraform-state)
```

## Steps

### Part 1 — Examine the starting config (local state)

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   Initially, there is **no** `backend` block. Terraform uses the **local backend** by default, storing state in `terraform.tfstate` in this directory.

2. **Initialize and apply to create local state:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

   A `terraform.tfstate` file is created locally.

### Part 2 — Add the S3 backend configuration

3. **Edit `main.tf` to add the S3 backend block:**

   ```hcl
   terraform {
     backend "s3" {
       bucket = "my-company-terraform-state"
       key    = "projects/my-project/terraform.tfstate"
       region = "us-east-1"
     }
   }
   ```

   The `backend` block tells Terraform:
   - `bucket` — which S3 bucket to store state in
   - `key` — the path/object key within the bucket
   - `region` — the AWS region of the bucket

   For production, you'd also add:
   - `dynamodb_table` — for state locking (see exercise #084)
   - `encrypt = true` — for encryption at rest

### Part 3 — Run `terraform init` to migrate

4. **Run init:**

   ```bash
   terraform init
   ```

   Terraform detects the backend configuration change:

   ```
   Initializing the backend...

   Do you want to copy existing state to the new backend?
     Pre-existing state was found while migrating the previous "local"
     backend to the newly configured "s3" backend. No changes were made
     to the existing state. You can undo this action by running
     terraform init again.

     Enter a value: yes
   ```

   Type `yes` to **migrate** the local state to S3.

5. **Verify the migration:**

   ```bash
   terraform state list
   ```

   The resources are still tracked — they're now managed via the S3 backend.

6. **Check that local state is backed up:**

   ```bash
   ls terraform.tfstate* 
   ```

   The original `terraform.tfstate` is backed up as `terraform.tfstate.backup`. The active state now lives in S3.

### Part 4 — Understand what `init` does with backends

7. **The backend initialization process:**

   ```
   terraform init
        │
        ├── 1. Detects backend block in config (or lack thereof)
        ├── 2. Compares with current backend in .terraform/ 
        ├── 3. If different: asks about migration
        │         ├── Yes → copies state to new backend
        │         └── No  → aborts, no change
        └── 4. Saves backend config in .terraform/terraform.tfstate
   ```

   **Key detail:** `terraform init` is the **only** command that can change backend configuration. You cannot change backends with `plan` or `apply`.

### Part 5 — Other backend initialization flags

8. **Related flags:**

   | Scenario | Command |
   |----------|---------|
   | Initial setup or migration | `terraform init` (prompts for migration) |
   | Skip migration prompt | `terraform init -migrate-state` (auto-confirms) |
   | Reconfigure without copying | `terraform init -reconfigure` (discards current backend) |
   | Partial config + CLI values | `terraform init -backend-config="key=value"` |

## Files

- `main.tf` — config that starts with local backend, then adds S3 backend block
- `outputs.tf` — output values
- `solution/` — reference implementation

