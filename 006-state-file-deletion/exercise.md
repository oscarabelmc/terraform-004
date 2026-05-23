# State File Deletion Exercise

**Exam Question:** You are using a local backend and accidentally delete the `terraform.tfstate` file for your workspace. What is the most serious consequence?

## Steps

### Part 1 — Create resources and inspect state

1. **Initialize and apply:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

2. **Inspect the state file:**

   ```bash
   cat terraform.tfstate | head -30
   ```

   This JSON file contains the mapping between your configuration and real-world resources — resource types, instance IDs, attributes, and dependency information.

   Note that `terraform.tfstate.backup` was also created automatically.

### Part 2 — Simulate the deletion

3. **Delete the state file:**

   ```bash
   rm terraform.tfstate
   ```

4. **Run `terraform plan`:**

   ```bash
   terraform plan
   ```

   **Observe:** Every resource shows as **"create"** — Terraform has no memory of the existing resources. It wants to create everything from scratch.

5. **Try `terraform state list`:**

   ```bash
   terraform state list
   ```

   It fails because no state file exists.

### Part 3 — The dangerous consequence

6. **Run `terraform apply -auto-approve`:**

   ```bash
   terraform apply -auto-approve
   ```

   Terraform creates **new** resources — but the original resources from step 1 still exist on disk. You now have duplicates:

   - Original `web-xxx.txt` (from step 1) → orphaned, not tracked by any state
   - New `web-yyy.txt` (from step 6) → tracked in the new state file

7. **Run `terraform destroy -auto-approve`:**

   ```bash
   terraform destroy -auto-approve
   ```

   Only the **new** resources (from step 6) are destroyed. The original resources remain permanently orphaned.

### Part 4 — Recovery

8. **Restore from the backup file:**

   ```bash
   cp terraform.tfstate.backup terraform.tfstate
   terraform state list
   ```

   The original state is restored. You can now manage the original resources again.

### Put It Together

What is the most serious consequence of accidentally deleting the `terraform.tfstate` file when using a local backend?

- A. Terraform auto-recovers by regenerating the state from the configuration.
- B. Terraform prompts the user to confirm deletion, preventing the mistake.
- C. Terraform loses the mapping to existing resources, making them orphaned and unmanaged.
- D. Only the `.backup` file is affected; the primary state file is redundant.
- E. The next `terraform plan` will update the existing resources rather than recreate them.

## Files
- `main.tf` — creates a random pet name and a local file
- `outputs.tf` — outputs for verification
- `solution/answer.md` — explanation and exam tips
