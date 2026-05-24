# Answer

The correct answers are **A** and **B**.

> A. Provide secrets as short-lived, ephemeral values from an external system (e.g., Vault) at runtime instead of hardcoding static credentials in version-controlled Terraform files.
>
> B. Mark variables as `sensitive` so Terraform redacts their values in CLI output and logs, limiting accidental disclosure during plan and apply.

---

## Why A and B Are Correct

### A — External Secrets at Runtime

Instead of hardcoding secrets in `.tf` files, fetch them from a secrets management system at runtime:

```hcl
# ✅ Good: Fetch from Vault at runtime
data "vault_generic_secret" "db" {
  path = "secret/data/database"
}

resource "aws_db_instance" "main" {
  password = data.vault_generic_secret.db.data["password"]
}
```

Other runtime methods:
- **Vault data source** — `data.vault_generic_secret`
- **AWS Secrets Manager** — `data.aws_secretsmanager_secret`
- **Azure Key Vault** — `data.azurerm_key_vault_secret`
- **GCP Secret Manager** — `data.google_secret_manager_secret`
- **Environment variables** — `TF_VAR_` prefix for variable values

| Method | Secret in Code? | Secret in State? |
|--------|----------------|-----------------|
| Hardcoded | ✅ Yes | ✅ Yes |
| Vault data source | ❌ No | ✅ Yes |
| Environment variable | ❌ No | ✅ Yes |
| `.tfvars` (not committed) | ❌ No | ✅ Yes |

### B — Mark Variables as Sensitive

```hcl
variable "db_password" {
  type        = string
  sensitive   = true  # ← Redacts from CLI output
}
```

When `sensitive = true`:
- `terraform plan` output shows `(sensitive value)` instead of the actual value
- `terraform apply` output redacts the value
- Outputs marked `sensitive` are also redacted

```hcl
output "db_password" {
  value     = var.db_password
  sensitive = true
}
```

**Important limitation:** `sensitive` only redacts from **CLI output and logs**. The value is still stored in **plaintext in the state file**. This is why combining with external secret stores (option A) is essential.

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| C — Store secrets in a committed `.tfvars` file | `.tfvars` files committed to VCS expose secrets to anyone with repo access. They should be in `.gitignore`. |
| D — Use hardcoded defaults in variable declarations | Default values are part of the `.tf` file, which goes into version control — visible to everyone. |
| E — Set `TF_SECRETS` environment variable | No such environment variable exists. Terraform has no built-in mechanism to encrypt state values automatically. |

## Secret Exposure Points

Understanding where secrets can appear:

```
Configuration (.tf) ──→ Version Control ──→ Visible to all with repo access
         │
         ▼
    terraform plan  ──→ CLI output ──→ Logs, CI/CD output
         │
         ▼
    terraform apply ──→ State file ──→ Backend storage (S3, etc.)
         │                         ──→ Plaintext JSON
         ▼
    Resource (AWS, etc.) ──→ Cloud console, logs
```

`sensitive = true` protects the **CLI output** path. External secret stores protect the **configuration/VCS** path. State file protection requires backend encryption (S3 SSE, etc.).

## Secret Management Best Practices

| Practice | What It Protects |
|----------|-----------------|
| Use external secret store (Vault, etc.) | Config files, VCS |
| Mark variables `sensitive = true` | CLI output, logs |
| Use encrypted remote backend | State file at rest |
| Never commit `.tfvars` with secrets | VCS history |
| Use `TF_VAR_` for ad-hoc values | Config files |
| Rotate secrets regularly | All exposure points |

## Exam Tips

- **Two correct methods**: external runtime secrets + `sensitive = true`
- `sensitive = true` redacts from CLI/logs but **not** from state
- State stores all values in **plaintext** regardless of `sensitive`
- Hardcoding secrets in `.tf` files or `.tfvars` (committed) is wrong
- External secret stores (Vault, AWS Secrets Manager, etc.) keep secrets out of code
- `TF_VAR_` prefix passes secrets at runtime without saving to files
- Common exam trap: thinking `sensitive = true` encrypts values in state — it doesn't
- Common exam trap: thinking default values in variables are safe — they're in code, visible in VCS
