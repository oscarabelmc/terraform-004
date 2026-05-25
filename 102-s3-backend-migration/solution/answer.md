# Answer

The correct answer is **A**.

> Define the S3 backend in the `terraform` block using a `backend` block, then run `terraform init` to migrate your local state.

---

## Why A Is Correct

The process has two steps:

### Step 1 — Define the backend

Add a `backend "s3"` block inside the `terraform` block:

```hcl
terraform {
  backend "s3" {
    bucket = "my-company-terraform-state"
    key    = "projects/my-project/terraform.tfstate"
    region = "us-east-1"
  }
}
```

### Step 2 — Run `terraform init`

When you run `terraform init`, Terraform detects that the backend configuration has changed. It prompts:

```
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local"
  backend to the newly configured "s3" backend.

  Enter a value: yes
```

Type `yes` and Terraform:

1. Copies the local `terraform.tfstate` to the S3 bucket at the specified key
2. Backs up local state as `terraform.tfstate.backup`
3. Records the backend configuration in `.terraform/terraform.tfstate`
4. All subsequent `plan`/`apply` commands read from and write to S3

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — Terraform auto-detects S3 | Terraform does **not** auto-detect remote storage. You must explicitly configure the `backend` block and run `init`. |
| C — `terraform apply -backend=s3` | **No such flag exists.** `-backend` is not a valid option for `apply`. Backend configuration changes happen during `init`, not `apply`. |
| D — Backend in separate `backend.tf` file + `terraform plan` | While you **can** put the backend block in a separate `.tf` file, `terraform plan` does **not** handle backend migration. Only `terraform init` does. |
| E — `TF_BACKEND` environment variable | **No such environment variable exists.** Terraform has `TF_LOG`, `TF_VAR_*`, etc., but no `TF_BACKEND`. |

## Backend Migration Process

```
Before:                         After:
┌──────────────┐               ┌──────────────────┐
│  Local State │    terraform   │   S3 Bucket      │
│  terraform   │ ──── init ──► │   my-company-     │
│  .tfstate    │    (migrate)  │   terraform-state │
└──────────────┘               │   /projects/...   │
                               │   .tfstate        │
                               └──────────────────┘
                                        │
                               terraform plan/apply
                               reads/writes via S3
```

### What happens to the local state file

| File | After migration |
|------|----------------|
| `terraform.tfstate` | Renamed to `terraform.tfstate.backup` |
| `.terraform/terraform.tfstate` | Updated to point to the S3 backend |
| S3 object at `key` path | New state storage location |

## Common Backend Configurations

| Backend | Block syntax | State locking |
|---------|-------------|:-------------:|
| **S3** | `backend "s3" { bucket, key, region }` | ✅ (with DynamoDB) |
| **AzureRM** | `backend "azurerm" { storage_account_name, container_name, key }` | ✅ (built-in) |
| **GCS** | `backend "gcs" { bucket, prefix }` | ✅ (built-in) |
| **Local** | No block (default) | ❌ |

## Exam Tips

- **Two steps only:** `backend` block → `terraform init`
- `terraform init` is the **only** command that handles backend configuration and migration
- The `-migrate-state` flag auto-confirms the migration prompt
- The `-reconfigure` flag discards current backend config without copying state
- Terraform prompts for confirmation before migrating (unless `-migrate-state` is used)
- The original local state is always backed up (`.backup` suffix)
- Key phrase: **"moving a project to a remote backend"** → implies existing state needs migration
- Common exam trap: thinking you can run `apply` or `plan` to switch backends
- Another trap: thinking Terraform auto-discovers S3 buckets
