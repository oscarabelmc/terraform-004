# Backend Reconfigure Exercise

**Exam Question:** You've decided to change your backend configuration from S3 to HCP Terraform. After updating the backend block, you run `terraform init`. Which flag should you use to reconfigure the backend without copying the existing state?

## Steps

### Part 1 — Initial setup with local backend

1. **Initial setup uses `backend "local"`:**

   ```bash
   cat main.tf | head -12
   ```

   The backend is configured as `local` with a state file path.

2. **Initialize with the local backend:**

   ```bash
   terraform init
   ```

3. **Apply to create state:**

   ```bash
   terraform apply -auto-approve
   ```

### Part 2 — Simulate changing the backend

4. **Swap to the HCP Terraform backend configuration:**

   ```bash
   cp solution/backend-hcp-terraform.tf backend-hcp-terraform.tf
   ```

   Remove the local backend from `main.tf` (comment out the `backend "local"` block or swap the file).

### Part 3 — Try `terraform init` without flags

5. **Run `terraform init` without flags:**

   ```bash
   terraform init
   ```

   Error message:

   ```
   The backend configuration has changed...
   If you want to change the backend configuration, use the `-reconfigure` or `-migrate-state` flag.
   ```

   Terraform **refuses** to change backends without an explicit flag.

### Part 4 — Use `-reconfigure` (the correct answer)

6. **Reconfigure without copying state:**

   ```bash
   terraform init -reconfigure
   ```

   This switches the backend to HCP Terraform **without copying** the existing local state. The local `terraform.tfstate` is left behind — the new backend starts fresh.

7. **Restore the original backend to clean up:**

   ```bash
   rm backend-hcp-terraform.tf
   # restore main.tf to use backend "local"
   ```

### Part 5 — Compare `-migrate-state` (the alternative)

8. **If the question said "copy state to new backend":**

   ```bash
   # After swapping to HCP backend config again:
   terraform init -migrate-state
   ```

   This prompts: "Do you want to copy existing state to the new backend?" This is the right flag when you **do** want to preserve state history.

### Put It Together

You've decided to change your backend configuration from S3 to HCP Terraform. After updating the backend block, you run `terraform init`. Which flag should you use to reconfigure the backend **without** copying the existing state?

- A. `terraform init`
- B. `terraform init -reconfigure`
- C. `terraform init -migrate-state`
- D. `terraform apply -reconfigure`
- E. `terraform backend -reconfigure`

## Files
- `main.tf` — configuration with local backend (starting point)
- `solution/backend-hcp-terraform.tf` — alternative backend config for HCP Terraform
- `solution/answer.md` — explanation and exam tips
