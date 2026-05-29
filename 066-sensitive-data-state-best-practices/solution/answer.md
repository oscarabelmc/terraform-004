# Explanation

The correct answers are **B**, **C**, **D**, and **F**.

> **B.** Terraform state can include sensitive data, so it is essential to restrict access to the state and audit any changes.
>
> **C.** A properly configured remote backend improves security via encryption and access controls.
>
> **D.** HCP Terraform encrypts state at rest (and in transit) and provides RBAC to restrict who can access state.
>
> **F.** When using local state, the state file is stored in plain text by default.

---

## Why B, C, D, and F Are Correct

### B — Restrict access and audit state

State contains **all resource attributes** in plain text — including passwords, connection strings, and private keys:

```json
{
  "resources": [{
    "type": "random_password",
    "name": "db_master",
    "instances": [{
      "attributes": {
        "result": "p@ssw0rd!secret123"  ← plain text in state
      }
    }]
  }]
}
```

Best practices:
- Apply least-privilege IAM/RBAC policies on the state backend
- Enable audit logging (CloudTrail, Azure Monitor, etc.)
- Use state locking to prevent concurrent corruption

### C — Remote backend improves security

Remote backends (S3, Azure Storage, GCS, HCP Terraform) provide:

```
┌──────────────────────────────────────────────┐
│         Remote Backend Security              │
├──────────────────────────────────────────────┤
│ • Encryption at rest (AES-256, SSE, etc.)    │
│ • Encryption in transit (TLS)                │
│ • Access controls (IAM policies, RBAC)       │
│ • Audit logging (who accessed state, when)   │
│ • State locking (prevent concurrent writes)  │
│ • Versioning (recover previous states)       │
└──────────────────────────────────────────────┘
```

### D — HCP Terraform encryption and RBAC

HCP Terraform provides built-in security for state:
- **Encryption at rest** — state files are encrypted before storage
- **Encryption in transit** — all API calls use TLS
- **RBAC** — granular permissions (read, write, admin) per workspace
- **Audit trails** — full history of state access and modifications

### F — Local state is plain text

When using the default local backend:

```bash
cat terraform.tfstate
# Output: human-readable JSON with all secrets in plain text
```

Local state:
- No encryption (unless filesystem-level)
- No access controls beyond OS permissions
- No audit logging
- Easily committed to VCS by accident (exposes secrets forever)

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — `sensitive = true` prevents state storage | ❌ **False.** `sensitive = true` only **masks the value in CLI output and logs**. The value is still written to state in plain text. Anyone with state access can read it. |
| E — Vault eliminates need for state controls | ❌ **False.** While Vault helps manage secrets, data sources from Vault can still have their results cached in state. Even with Vault, you must secure state with encryption, access controls, and auditing. |

## Summary: What protects sensitive data

| Protection | What it does | Limitation |
|-----------|-------------|------------|
| `sensitive = true` | Hides value in CLI output | ❌ Still in state |
| Remote backend encryption | Encrypts state at rest and in transit | ✅ Protects state file |
| State access controls (IAM/RBAC) | Restricts who can read state | ✅ Limits exposure |
| Vault provider | Fetches secrets at runtime | ⚠️ Result may still be in state |
| `random` / `tls` provider | Generates secrets in Terraform | ❌ Secret is stored in state |
| Never commit state to VCS | Prevents Git history exposure | ✅ Essential practice |

## Objective Reference

**Objective 4h** — Understand best practices for managing sensitive data, including secrets management with Vault.

Key points:
- Terraform state can contain sensitive data (passwords, keys, connection strings)
- Local state is plain-text JSON
- Treat state itself as sensitive data
- Remote backends provide better security (encryption, access controls, auditing)
- HCP Terraform encrypts state at rest and in transit with RBAC
- `sensitive = true` does NOT prevent state storage — only masks CLI output
- Vault helps but does not eliminate the need for state security
