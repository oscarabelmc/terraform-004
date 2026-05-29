# Selective Resource Removal Exercise

**Domain:** IaC Workflow
**Topic:** Selective resource decommission — remove from config, then `apply`

## Description

Your organization manages a Google Cloud project with 50 resources across multiple services. You need to decommission only the Cloud SQL database instance and its backup policy while keeping all other infrastructure running. What is the most appropriate approach

## Learning Objectives

- Baseline: multiple resources managed
- Remove the database resources from config
- Run `terraform apply` (the correct approach)
- Compare with other approaches (why they're wrong)

## Steps

### Part 1 — Baseline: multiple resources managed

1. **Inspect the configuration:**

   ```bash
   cat main.tf
   ```

   The config manages 5 resources:
   - `random_pet.database` and `random_password.db_backup_policy` — target for removal
   - `random_pet.server`, `random_pet.cache`, `random_pet.queue`, `local_file.inventory` — keep these

2. **Apply to establish state:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

3. **Verify all resources exist in state:**

   ```bash
   terraform state list
   ```

### Part 2 — Remove the database resources from config

4. **Remove the database blocks:**

   Edit `main.tf` and delete the `random_pet.database` and `random_password.db_backup_policy` resource blocks. Also remove the database entry from `local_file.inventory` content.

   (Or use the pre-prepared version:)

   ```bash
   cp solution/after-removal.tf main.tf
   ```

### Part 3 — Run `terraform apply` (the correct approach)

5. **See the plan:**

   ```bash
   terraform plan
   ```

   The plan shows:
   - `random_pet.database` will be **destroyed** (`-`)
   - `random_password.db_backup_policy` will be **destroyed** (`-`)
   - `local_file.inventory` will be **updated** (`~`) — content no longer references database
   - Everything else: **no changes**

6. **Apply to decommission:**

   ```bash
   terraform apply -auto-approve
   ```

   Only the database and its backup policy are destroyed. The server, cache, queue, and inventory remain intact.

7. **Confirm:**

   ```bash
   terraform state list
   ```

   The database and backup resources are gone from state and from real infrastructure.

### Part 4 — Compare with other approaches (why they're wrong)

| Approach | Why it's wrong |
|----------|---------------|
| `terraform destroy` | Destroys **everything**, not just the database |
| `terraform state rm` on database | Removes from state but **real resource still exists** (orphaned) |
| Manually delete in cloud console | Works but Terraform state is now **out of sync** — next plan will try to recreate |
| Restore from backup | Doesn't address the decommission requirement |

## Files
- `main.tf` — configuration with 5 resources (database + others)
- `solution/` — reference implementation
- `solution/` — reference implementation

