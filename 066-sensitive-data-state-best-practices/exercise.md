# Sensitive Data and State Best Practices Exercise

**Exam Question:** Your team uses Vault for short-lived credentials and stores Terraform state in a remote backend. Which statements reflect best practices for managing sensitive data and state? (Select four.)

## Background

Terraform state contains **all resource attributes** — including those that may be sensitive. Database passwords, private keys, and connection strings are all stored in plain text in the state file. Understanding how to protect this data is critical.

### What ends up in state?

| Sensitive value | Does it appear in state? |
|----------------|------------------------|
| `random_password` result | ✅ Yes — plain text |
| `aws_db_instance` password | ✅ Yes — plain text |
| `aws_iam_user_login_profile` password | ✅ Yes — plain text |
| `sensitive = true` outputs | ✅ Yes — still in state, only hidden from CLI |
| Vault-sourced secrets | ❌ Not if fetched at runtime via `vault` provider |

## Steps

### Part 1 — Examine sensitive data in config

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   Note two patterns that generate sensitive data:

   ```hcl
   # Pattern 1: Random provider generates a password
   resource "random_password" "db_master" {
     length  = 24
     special = true
   }

   # Pattern 2: Resource attribute contains the password
   resource "aws_db_instance" "main" {
     password = random_password.db_master.result
   }

   # Pattern 3: Output marked sensitive
   output "db_password" {
     value     = random_password.db_master.result
     sensitive = true
   }
   ```

### Part 2 — Understand what `sensitive = true` does and doesn't do

2. **`sensitive = true` on outputs:**

   ```bash
   terraform apply
   ```

   When the output is marked `sensitive = true`:
   - ✅ The value is **hidden** in CLI output (shows `<sensitive>`)
   - ❌ The value is **still stored in plain text** in the state file
   - ❌ The value is **still stored in plain text** in the state file on the remote backend

   ```bash
   # The password is still in state:
   terraform state show random_password.db_master
   # Shows the full password despite sensitive = true
   ```

### Part 3 — Compare local vs remote state security

3. **Local state (default, plain text):**

   ```bash
   cat terraform.tfstate | grep -A 5 "random_password"
   ```

   Local state is stored in **plain text JSON**. Anyone with filesystem access can read it.

4. **Remote backend with encryption:**

   The config uses `backend "s3"` with `encrypt = true`:

   ```hcl
   backend "s3" {
     encrypt = true
     # ...also uses DynamoDB for state locking
   }
   ```

   Remote backends provide:
   - **Encryption at rest** (S3 SSE, Azure Storage encryption, GCS encryption)
   - **Encryption in transit** (TLS)
   - **Access controls** (IAM policies, RBAC)
   - **Audit logging** (CloudTrail, Azure Monitor)

### Part 4 — State access best practices

5. **Restrict and audit state access:**

   Since state contains sensitive data:
   - Apply **least-privilege IAM policies** on the state backend
   - Enable **audit logging** to track who reads state
   - Use **state locking** to prevent concurrent modifications
   - Never commit state to VCS (Git history exposes secrets)

6. **HCP Terraform security features:**

   If using HCP Terraform:
   - State is encrypted **at rest** and **in transit**
   - **RBAC** controls who can read/update state
   - **Audit trails** track all state access
   - **Run history** stores all plan/apply outputs

7. **Vault integration:**

   Vault can provide short-lived credentials at runtime:

   ```hcl
   data "vault_generic_secret" "db_creds" {
     path = "secret/data/db"
   }
   ```

   However, even with Vault:
   - The **Vault data source result** is still stored in state
   - Additional state controls are **still required**
   - Vault reduces secret exposure but does not eliminate the need for state security

### Put It Together

Your team uses Vault for short-lived credentials and stores Terraform state in a remote backend. Which statements reflect best practices for managing sensitive data and state? (Select four.)

- A. Marking an output `sensitive = true` prevents its value from being stored in the state file.
- B. Terraform state can include sensitive data, so it is essential to restrict access to the state and audit any changes.
- C. A properly configured remote backend improves security via encryption and access controls.
- D. HCP Terraform encrypts state at rest (and in transit) and provides RBAC to restrict who can access state.
- E. Using Vault ensures that secrets never appear in state, so additional controls on state aren't required.
- F. When using local state, the state file is stored in plain text by default.

## Files

- `main.tf` — config with sensitive data (RDS password, IAM login profile)
- `outputs.tf` — outputs including sensitive values
- `solution/answer.md` — explanation and exam tips
