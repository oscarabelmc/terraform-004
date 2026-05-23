# State Drift Exercise

**Exam Question:** In Terraform, what does "drift" mean in the context of a workspace's state?

## Steps

### Part 1 — Establish baseline

1. **Initialize and apply** to create a known-good state:

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

2. **Verify state matches reality:**

   ```bash
   terraform state show local_file.info
   cat *.txt
   ```

   The state file and the real file both show the same content.

### Part 2 — Simulate drift

3. **Modify the resource outside Terraform** (simulate someone editing the file directly):

   ```bash
   echo "\nALERT: Unauthorized modification" >> *.txt
   ```

4. **Read the file to confirm the change:**

   ```bash
   cat *.txt
   ```

   The real file now differs from what Terraform recorded in state — this is **drift**.

### Part 3 — Detect drift

5. **Run `terraform plan`:**

   ```bash
   terraform plan
   ```

   Terraform detects the drift and shows an in-place update (`~`) to restore the file content to what the config declares.

6. **Run `terraform plan -refresh-only`:**

   ```bash
   terraform plan -refresh-only
   ```

   This shows the state update needed to match reality, without proposing any config changes.

### Part 4 — Recovery options

7. **Option A — Reconcile by applying the config** (restores desired state):

   ```bash
   terraform apply -auto-approve
   cat *.txt
   ```

   The file is restored to match the configuration. Drift is resolved.

8. **Option B — Update state to match reality** (if the manual change was intentional):

   ```bash
   terraform apply -refresh-only -auto-approve
   terraform state show local_file.info
   ```

   State now records the modified content. The manual change is accepted.

### Put It Together

In Terraform, what does "drift" mean in the context of a workspace's state?

- A. An error in the configuration syntax that prevents Terraform from running.
- B. A planned change that has been approved but not yet applied.
- C. Real infrastructure has changed outside Terraform and no longer matches the desired state.
- D. The state file contains more resources than the configuration defines.
- E. A resource failed during the last `terraform apply` and must be re-created.

## Files
- `main.tf` — creates a local file you can edit to simulate drift
- `solution/answer.md` — explanation and exam tips
