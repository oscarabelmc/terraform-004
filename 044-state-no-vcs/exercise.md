# State File — Version Control Exercise

**Exam Question:** Why should users not commit the `terraform.tfstate` file to version control? (Select two.)

## Background

Terraform state files contain sensitive information about your infrastructure. Despite looking like simple JSON, state files can include passwords, access keys, private IPs, and detailed resource metadata. Committing them to version control creates security and operational risks.

## Steps

### Part 1 — Examine what a state file contains

1. **Apply the config to generate a state file:**

   ```bash
   cd /home/terraform-004/044-state-no-vcs
   terraform init
   terraform apply -auto-approve
   ```

2. **Examine the state file:**

   ```bash
   cat terraform.tfstate | head -60
   ```

   You'll see:
   - The `random_password` resource's **plaintext result** (the generated password)
   - The `local_sensitive_file` resource's **plaintext content**
   - Resource metadata: types, names, attributes
   - The Terraform version used
   - The serial number (version of the state)

### Part 2 — Understand the security risk

3. **Imagine this state file in a public repo:**

   The `random_password` value is stored in plaintext. If you commit this to GitHub (even a private repo), anyone with repo access can see the password. Even if you delete it later, **commit history** preserves it forever.

4. **Check what sensitive data looks like:**

   ```bash
   cat terraform.tfstate | grep -i "result\|password\|secret\|content"
   ```

   The sensitive values are stored in plaintext despite the `sensitive = true` flag on the resource. The `sensitive` flag only controls CLI output — it does **not** prevent values from being written to state.

### Part 3 — Understand the locking risk

5. **Simulate concurrent runs:**

   Version control systems (Git, SVN) do **not** provide state locking. If two team members run `terraform apply` simultaneously:

   ```
   User A: terraform apply → writes state → git commit
   User B: terraform apply → writes state → git commit (overwrites A's changes)
   ```

   The last commit wins, overwriting the other user's state changes. This corrupts the state — it no longer accurately reflects real infrastructure.

### Part 4 — Examine proper .gitignore

6. **Check the project's .gitignore:**

   ```bash
   cat ../.gitignore 2>/dev/null || echo "No project .gitignore found"
   ```

   The standard Terraform `.gitignore` entries:

   ```
   .terraform/
   *.tfstate
   *.tfstate.backup
   crash.log
   ```

### Put It Together

Why should users not commit the `terraform.tfstate` file to version control? (Select two.)

- A. State can include plaintext secrets and detailed resource data; commit history can expose them
- B. VCS provides no state locking, so concurrent runs can cause conflicting commits and corrupt state
- C. State files are too large to be stored in version control
- D. Terraform cannot read state files from a version control system
- E. State files are only readable by the Terraform binary and cannot be viewed

## Files

- `main.tf` — config that generates sensitive values in state
- `variables.tf` — input variables
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
