# Answer

The correct answer is **C**.

> In the current working directory in a file named `terraform.tfstate`.

---

## Why C Is Correct

When no `backend` block is specified, Terraform uses the **local backend** — the default:

```
terraform apply
       │
       ▼
Current Working Directory
│
├── main.tf
├── terraform.tfstate        ← Default state storage location
├── terraform.tfstate.backup ← Previous state version
├── .terraform/
└── .terraform.lock.hcl
```

### Local backend characteristics

| Aspect | Detail |
|--------|--------|
| **File** | `terraform.tfstate` |
| **Location** | Same directory where `terraform apply` is run |
| **Format** | Plain text JSON |
| **Encryption** | None — all attributes visible in plain text |
| **Suitable for** | Learning, testing, single-user environments |

### Why the other options are wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Remote S3 bucket | Requires a `backend "s3" {}` block. Without it, state is local. |
| B — Terraform Cloud | Requires a `cloud` block or `backend "remote" {}` configuration. |
| D — Database | No backend block means local state, not a database. |
| E — Not persisted | State **is** persisted by default as `terraform.tfstate`. |

## Local vs Remote Backends

| Feature | Local (default) | Remote (e.g., S3) |
|---------|----------------|-------------------|
| **File location** | `./terraform.tfstate` | Remote storage |
| **Requires config** | None — default | `backend "s3" { ... }` block |
| **Encryption** | ❌ Plain text | ✅ SSE, TLS |
| **Locking** | ❌ No (OS file lock only) | ✅ Via DynamoDB (S3) |
| **Team sharing** | ❌ Not possible | ✅ Yes |
| **Audit logging** | ❌ No | ✅ Via CloudTrail |

## Exam Tips

- **No backend block = local backend** = `terraform.tfstate` in the current directory
- Local state is **plain text JSON** — never commit to VCS
- Local state is **single-user only** — not suitable for teams
- Remote backends require explicit configuration
- Common exam trap: thinking state is not stored by default (it always is — locally)
- Another trap: assuming state goes to a remote location without configuration
