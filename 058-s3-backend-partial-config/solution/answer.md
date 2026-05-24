# Answer

The correct answer is **B**.

> Define the backend block with only the type, then pass the bucket and region values using the `-backend-config` flag during `terraform init`.

---

## Why B Is Correct

Partial backend configuration separates **what** (backend type) from **the details** (sensitive values):

```
main.tf (committed to VCS):
  backend "s3" {}
  ▲ Only the type is declared

terraform init -backend-config="bucket=my-bucket" \
               -backend-config="region=us-east-1"
  ▲ Sensitive values supplied at runtime
```

Terraform merges the partial block in code with CLI/supplemental config at init time. This:

- ✅ Keeps bucket names, keys, and regions out of version control
- ✅ Allows different backend config per environment (dev/staging/prod)
- ✅ Enables CI/CD pipelines to inject secrets without modifying code
- ✅ Follows security best practices (no secrets in Git history)

### How the merge works

```
┌─────────────────────┐     ┌────────────────────────┐
│  Code (main.tf)     │     │  -backend-config flags │
│                     │     │                        │
│  backend "s3" {}    │  +  │  bucket = "my-bucket"  │
│  (type only)        │     │  key   = "demo/state"  │
│                     │     │  region = "us-east-1"  │
└─────────┬───────────┘     └──────────┬─────────────┘
          │                            │
          └─────────┬──────────────────┘
                    ▼
          ┌─────────────────────┐
          │  Effective config   │
          │                     │
          │  backend "s3" {     │
          │    bucket = "..."   │
          │    key    = "..."   │
          │    region = "..."   │
          │  }                  │
          └─────────────────────┘
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Full backend block in code | Puts sensitive values in version control — defeats the purpose. Anyone with repo access sees bucket names, keys, regions. |
| C — Omit backend entirely | Technically possible but impractical: every `terraform init` would require re-specifying the backend type. The type itself is not sensitive and should be in code. |
| D — `terraform.tfvars` with `sensitive = true` | **Variables cannot be used in backend blocks.** Backend configuration is processed before variables are loaded. `sensitive = true` also does not prevent writing to state — it only hides output. |
| E — Placeholder values with `sed` | Fragile, error-prone, and breaks automation. Terraform's built-in `-backend-config` mechanism is the correct approach. |

## Partial Backend Configuration Methods

| Method | Command | Use Case |
|--------|---------|----------|
| **CLI flags** | `terraform init -backend-config="key=val"` | CI/CD pipelines, ad-hoc |
| **Config file** | `terraform init -backend-config=file.tfbackend` | Team development, multiple environments |
| **Combined** | `-backend-config` flag + partial block | Most flexible — type in code, details in flags |

## Exam Tips

- **Backend blocks cannot reference variables** — use `-backend-config` instead
- The **backend type** (e.g., `s3`, `azurerm`, `gcs`) is not sensitive and can stay in code
- Partial config supports multiple `-backend-config` flags — they merge
- Common exam trap: thinking `terraform.tfvars` or `variable` blocks can be used in backend configuration (they cannot — backends are processed before variables)
- `terraform init -reconfigure` discards existing backend config and re-initializes
- `terraform init -migrate-state` copies existing state to the new backend
