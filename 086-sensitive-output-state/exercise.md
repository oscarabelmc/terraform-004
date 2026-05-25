# Sensitive Outputs and State Exercise

**Exam Question:** True or False? Marking an output as `sensitive` does not prevent its value from being stored in the Terraform state file.

## Background

The `sensitive = true` attribute on Terraform outputs is often misunderstood. It only affects **display** — the value is hidden in CLI output and logs, but is **still stored in plain text** in the state file.

## Steps

### Part 1 — Examine the config

1. **Open `main.tf` and `outputs.tf`:**

   ```bash
   cat main.tf
   cat outputs.tf
   ```

   The `db_password` output is marked `sensitive = true`.

### Part 2 — Apply and observe

2. **Apply the configuration:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

   Output:

   ```
   Outputs:

   db_password = <sensitive>     ← Hidden from CLI
   vpc_id = "vpc-0a1b2c3d"      ← Shown normally
   ```

### Part 3 — The value is still in state

3. **Verify the password is in state:**

   ```bash
   terraform state show random_password.db_master
   ```

   Output includes the full password in plain text:

   ```
   # random_password.db_master:
   resource "random_password" "db_master" {
       id       = "none"
       length   = 24
       result   = "p@ssw0rd!secret123..."   ← Plain text in state!
       special  = true
   }
   ```

4. **Inspect the raw state file:**

   ```bash
   terraform state pull | grep -A 3 "random_password"
   ```

   The state JSON contains `"result": "p@ssw0rd!secret123..."` regardless of `sensitive = true`.

### Part 4 — What sensitive actually does

5. **`sensitive = true` affects:**

   - ✅ CLI output — shows `<sensitive>` instead of the value
   - ✅ `terraform output` — shows `<sensitive>`
   - ✅ Logs — value is redacted

6. **`sensitive = true` does NOT affect:**

   - ❌ State file — value is still in plain text
   - ❌ `terraform state show` — value is visible
   - ❌ `terraform state pull` — value is visible
   - ❌ API access to remote backend — value is visible

### Put It Together

True or False? Marking an output as `sensitive` does not prevent its value from being stored in the Terraform state file.

- A. True
- B. False

## Files

- `main.tf` — config with random_password
- `outputs.tf` — outputs including sensitive one
- `solution/answer.md` — explanation and exam tips
