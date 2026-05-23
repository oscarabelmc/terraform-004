# Sensitive Data and State Exercise

**Exam Question:** Which statements about sensitive data and Terraform state are correct? (Select two.)

## Steps

### Part 1 — Set up with a sensitive value

1. **Initialize and apply with a sensitive variable:**

   ```bash
   terraform init
   TF_VAR_db_password="MyS3cret!" terraform apply -auto-approve
   ```

2. **Observe the CLI output:**

   Notice the `db_password` output shows `(sensitive)` — Terraform redacts it from the terminal.

### Part 2 — Prove sensitive values are in state

3. **Inspect the state file directly:**

   ```bash
   cat terraform.tfstate | grep -A2 db_password
   ```

   **The plaintext value `MyS3cret!` is right there in the state file.** The `sensitive = true` flag only affects display — it does not prevent the value from being written to state.

4. **Inspect the generated config file:**

   ```bash
   cat *.cfg
   ```

   The file also contains the password because `var.db_password` was used in the resource configuration.

### Part 3 — Why this matters

5. **Local state is plaintext by default:**

   ```bash
   cat terraform.tfstate | head -5
   ```

   The state file is standard JSON — no encryption, no obfuscation. Anyone with access to the file can read all values, including those marked `sensitive = true`.

6. **Try reading the output via CLI:**

   ```bash
   terraform output db_password
   ```

   Output: `(sensitive)` — redacted in terminal, but still visible in the raw state file.

### Put It Together

Which statements about sensitive data and Terraform state are correct? (Select two.)

- A. Sensitive outputs are never stored in state, only displayed at apply time.
- B. The state file can contain sensitive values in plaintext by default.
- C. Using local state automatically encrypts secrets on disk without extra steps.
- D. Marking a variable `sensitive = true` does not prevent it from being written to state.

## Files
- `main.tf` — uses the sensitive variable in resources
- `variables.tf` — declares `db_password` with `sensitive = true`
- `outputs.tf` — declares `db_password` output with `sensitive = true`
- `solution/answer.md` — explanation and exam tips
