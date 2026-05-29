# S3 Partial Backend Configuration Exercise

**Domain:** State Management
**Topic:** S3 partial backend configuration

## Description

You're configuring an S3 backend for your Terraform project. You want to keep sensitive values, such as the bucket name and region, out of version control while keeping other backend configuration in your code. Which approach correctly implements partial backend configuration

## Learning Objectives

- Examine the partial backend config
- Initialize with partial config
- Alternative: partial config file
- Why partial configuration matters

## Background

Terraform supports **partial backend configuration** — declaring the backend type in code while supplying sensitive or environment-specific values externally. This keeps secrets like bucket names, access keys, and regions out of version control.

| Approach | Backend type in code? | Sensitive values in code? | Use case |
|----------|-----------------------|---------------------------|----------|
| **Full config** | Yes | Yes | Single-team, proof-of-concept |
| **Partial config** | Yes | **No** (passed at init) | Team/CI with secrets management |
| **No config** | No — all passed via `-backend-config` | No | Dynamic environments |

## Steps

### Part 1 — Examine the partial backend config

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   Notice the backend block:

   ```hcl
   backend "s3" {}
   ```

   Only the **type** (`s3`) is declared. No bucket, key, or region — those will be supplied at initialization time via `-backend-config` flags or a separate configuration file.

### Part 2 — Initialize with partial config

2. **Initialize Terraform with inline backend config:**

   ```bash
   terraform init \
     -backend-config="bucket=terraform-state-$(whoami)" \
     -backend-config="key=partial-demo/terraform.tfstate" \
     -backend-config="region=us-east-1"
   ```

   The `-backend-config` flag fills in the missing values. Terraform merges:
   - Config file: `backend "s3" {}` (type only)
   - CLI flags: `bucket`, `key`, `region`
   - Result: a complete backend configuration

3. **Verify the backend config was applied:**

   ```bash
   cat .terraform/terraform.tfstate | head -20
   ```

   The local `.terraform/terraform.tfstate` now contains the full backend configuration, including the values passed via `-backend-config`.

### Part 3 — Alternative: partial config file

4. **Create a `.tfbackend` file (alternative to CLI flags):**

   Create `config.dev.s3.tfbackend`:

   ```hcl
   bucket = "terraform-state-dev"
   key    = "partial-demo/terraform.tfstate"
   region = "us-east-1"
   ```

5. **Initialize using the config file:**

   ```bash
   terraform init -reconfigure -backend-config=config.dev.s3.tfbackend
   ```

   This achieves the same result — the backend block in code provides the type, and the separate file provides the sensitive/environment-specific values.

### Part 4 — Why partial configuration matters

6. **Security benefits:**

   With partial backend configuration:
   - `main.tf` can be committed to version control — it contains only the backend type
   - Sensitive values are supplied at runtime via:
     - CLI flags (CI/CD pipelines)
     - `.tfbackend` files (not committed to VCS)
     - Environment variables or secrets manager scripts
   - No hardcoded bucket names, keys, or regions in the codebase

7. **CI/CD integration example:**

   ```bash
   # In CI/CD pipeline:
   terraform init \
     -backend-config="bucket=$TF_STATE_BUCKET" \
     -backend-config="region=$TF_REGION" \
     -backend-config="dynamodb_table=$TF_LOCK_TABLE"
   ```

   Environment variables injected by the CI/CD system provide the sensitive values, while the backend type remains in the committed code.

## Files

- `main.tf` — config with partial S3 backend declaration (type only)
- `outputs.tf` — output values
- `solution/` — reference implementation

