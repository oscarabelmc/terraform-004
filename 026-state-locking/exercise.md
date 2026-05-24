# State Locking Exercise

**Exam Question:** Why is state locking necessary when using a remote backend?

## Background

When a team uses a remote backend (e.g., S3), two engineers could run `terraform apply` at the same time. Without state locking, the concurrent writes can corrupt the state file — Terraform may read stale data, apply conflicting changes, and write incomplete or inconsistent state.

State locking prevents this by allowing only one operation to hold the lock at a time. Other operations are blocked until the lock is released.

## Steps

### Part 1 — Understanding the remote backend config

1. **Open `main.tf`** and examine the backend configuration:

   ```bash
   cat main.tf
   ```

   The S3 backend includes a `dynamodb_table` argument. This is how Terraform manages state locking with S3 — the state lives in S3, and DynamoDB provides the locking mechanism.

### Part 2 — Simulate concurrent operations (conceptual)

2. **Open two terminals** in this directory:

   **Terminal 1:** Run `terraform apply` (this will acquire the lock):

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

   **Terminal 2 (while Terminal 1 is still applying):** Run another `terraform apply`:

   ```bash
   terraform apply -auto-approve
   ```

   The second terminal will block or fail with an error like:

   ```
   Acquiring state lock. This may take a few moments...
   Error: Error acquiring the state lock

   Lock Info:
     ID:        abc123
     Path:      terraform-004/terraform.tfstate
     Operation: OperationTypeApply
     Who:       user@hostname
     Version:   1.9.0
     Created:   2025-01-15 10:30:00
   ```

   This shows:
   - **Who** holds the lock
   - **What operation** is in progress
   - **When** the lock was acquired

### Part 3 — Inspect the lock info

3. If you see the lock error above, inspect the details:

   - **ID**: A unique identifier for this lock
   - **Path**: Which state file is locked
   - **Operation**: `Apply`, `Plan`, or `Destroy`
   - **Who**: Username/hostname of the operator
   - **Version**: Terraform version used
   - **Created**: Timestamp when the lock was acquired

### Part 4 — Force unlock (manual override)

4. If a lock is stuck (e.g., the operator was interrupted or the process crashed), you can force-unlock:

   ```bash
   terraform force-unlock <LOCK_ID>
   ```

   Terraform will prompt for confirmation before breaking the lock:

   ```
   Do you really want to force-unlock?
     Terraform will remove the lock on the remote state.
     This will allow local Terraform commands to modify this state.
   ```

   Only use force-unlock when you are certain no operation is in progress. Breaking a live lock can corrupt the state.

### Part 5 — Disabling locking (not recommended)

5. You can disable locking per-command with `-lock=false`:

   ```bash
   terraform apply -lock=false -auto-approve
   ```

   This bypasses the lock entirely and is **strongly discouraged** in team environments.

### Put It Together

Why is state locking necessary when using a remote backend?

- A. It prevents concurrent runs from writing to the same state at the same time, avoiding state corruption
- B. It encrypts the state file during transit
- C. It tracks who last modified the state file for auditing
- D. It automatically backs up the state before each change

## Files

- `main.tf` — remote backend config with DynamoDB state locking
- `solution/answer.md` — explanation and exam tips
