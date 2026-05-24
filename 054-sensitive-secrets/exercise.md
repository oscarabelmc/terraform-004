# Sensitive Input Values Exercise

**Exam Question:** The security team requires that you protect sensitive input values, such as API keys or passwords, in Terraform. Which methods follow Terraform guidance for reducing accidental exposure of secrets? (Select two.)

## Background

Terraform configurations often need secrets — database passwords, API tokens, SSH keys, etc. Best practices for handling secrets in Terraform focus on **reducing exposure** through:

1. **Avoiding static secrets in code** — never hardcode in `.tf` files
2. **Marking variables as `sensitive`** — redacts values from CLI output
3. **Using external secret stores** — Vault, AWS Secrets Manager, etc.
4. **Using `.tfvars` files with proper permissions** — never commit to VCS

## Steps

### Part 1 — Examine the wrong approach (hardcoded secrets)

1. **Open `main-hardcoded.tf`:**

   ```bash
   cat main-hardcoded.tf
   ```

   This demonstrates what **not** to do — secrets hardcoded directly in the config:

   ```hcl
   provider "aws" {
     access_key = "AKIAIOSFODNN7EXAMPLE"
     secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
   }
   ```

### Part 2 — Mark variables as sensitive

2. **Open `variables.tf`:**

   ```bash
   cat variables.tf
   ```

   The `sensitive = true` argument marks the variable so Terraform redacts its value:

   ```hcl
   variable "db_password" {
     type        = string
     sensitive   = true
     description = "Database password"
   }
   ```

3. **Test sensitive redaction:**

   ```bash
   terraform init
   terraform plan -var="db_password=my-secret-pass"
   ```

   The output shows:

   ```
   # output.db_password will be known after apply
   # (sensitive value)
   ```

   Instead of displaying the actual password, Terraform shows `(sensitive value)`.

### Part 3 — Use external secrets at runtime

4. **Examine the Vault data source approach:**

   ```hcl
   # Fetch secret from Vault at runtime — no static value in code
   data "vault_generic_secret" "db" {
     path = "secret/data/database"
   }

   resource "aws_db_instance" "main" {
     password = data.vault_generic_secret.db.data["password"]
   }
   ```

   The secret is fetched **at plan/apply time** from Vault. It never exists in the `.tf` file or in version control.

5. **Alternative: environment variables:**

   ```bash
   export TF_VAR_db_password="my-secret-pass"
   terraform plan
   ```

   The value is passed at runtime via `TF_VAR_` prefix — never saved in a file.

### Part 4 — What NOT to do

6. **Avoid these patterns:**

   ```hcl
   # ❌ Hardcoded in config
   password = "super-secret-123"

   # ❌ In default values
   variable "password" {
     default = "super-secret-123"
   }

   # ❌ In .tfvars committed to VCS
   password = "super-secret-123"  # terraform.tfvars should be in .gitignore
   ```

### Put It Together

The security team requires that you protect sensitive input values, such as API keys or passwords, in Terraform. Which methods follow Terraform guidance for reducing accidental exposure of secrets? (Select two.)

- A. Provide secrets as short-lived, ephemeral values from an external system (e.g., Vault) at runtime instead of hardcoding static credentials in version-controlled Terraform files
- B. Mark variables as `sensitive` so Terraform redacts their values in CLI output and logs, limiting accidental disclosure during plan and apply
- C. Store all secrets in a `.tfvars` file committed to the repository for easy access
- D. Use hardcoded default values in variable declarations so they are never visible in plan output
- E. Set the `TF_SECRETS` environment variable to automatically encrypt all sensitive values in state

## Files

- `main.tf` — config using sensitive variable + state inspection
- `variables.tf` — sensitive variable declaration
- `outputs.tf` — sensitive output
- `main-hardcoded.tf` — example of what NOT to do
- `solution/answer.md` — explanation and exam tips
