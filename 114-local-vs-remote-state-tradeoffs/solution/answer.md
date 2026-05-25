# Answer

The three correct answers are: **A, B, and C**.

> **A** — Remote backends typically provide encryption at rest and access controls for state data, while local state security depends entirely on filesystem permissions.
>
> **B** — Local state is simple to set up with no additional infrastructure required, while remote backends require configuration and maintenance of backend services.
>
> **C** — Remote backends provide centralized state access for team collaboration, while local state requires manual file sharing between team members.

---

## Why A, B, and C Are Correct

### A — Security tradeoff

```
Local:                     Remote:
┌────────────────┐        ┌──────────────────────┐
│ terraform      │        │ S3 Bucket (encrypted)│
│ .tfstate       │        │ SSE-S256 encryption  │
│                │        │ IAM policies          │
│ Protection:    │        │ Access logging        │
│ chmod 600      │        │                       │
└────────────────┘        └──────────────────────┘
   ⚠ Plaintext on disk      ✅ Encrypted + controlled
```

Local state has **no built-in encryption** — anyone with filesystem access can read `terraform.tfstate`, which may contain secrets like database passwords, access keys, or sensitive configuration values. Remote backends offer encryption at rest (e.g., S3 SSE-S3/AES-256, Azure Storage SSE) and access controls (IAM, RBAC).

### B — Complexity tradeoff

Local state requires **zero setup** — Terraform writes to `terraform.tfstate` automatically. Remote backends require:

1. Creating infrastructure (S3 bucket, DynamoDB table, etc.)
2. Adding a `backend` block to config
3. Running `terraform init` to migrate
4. Managing permissions and access

```
Local state setup:      $ terraform apply
Remote state setup:     1. Create S3 bucket + DynamoDB table
                         2. Add backend "s3" { ... } block
                         3. terraform init (migrate)
                         4. Manage IAM policies
```

### C — Collaboration tradeoff

Local state exists on **one machine**. To share it, you'd need to:
- Copy the `.tfstate` file manually (error-prone)
- Store it in a shared drive (no locking — corruption risk)
- Email it (version confusion)

Remote backends provide a **single source of truth** that all team members read from and write to, with locking to prevent conflicts.

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| D — Local state provides encryption, remote stores plaintext | **Exactly backwards.** Local state is plaintext on disk. Remote backends typically encrypt at rest by default (S3 SSE-S3, Azure SSE, GCS default encryption). |
| E — Local state supports more providers | The number of supported providers is **independent of state storage**. Providers are plugins downloaded by `terraform init` — they work the same regardless of where state is stored. |

## Comparison Summary

| Aspect | Local | Remote |
|--------|:-----:|:------:|
| Setup effort | ✅ None | ⚠️ Moderate |
| Team collaboration | ❌ Manual sharing | ✅ Centralized |
| State locking | ❌ Not available | ✅ Supported |
| Encryption at rest | ❌ Plaintext | ✅ Encrypted |
| Access controls | ❌ File perms only | ✅ IAM/RBAC |
| Requires network | ✅ No | ❌ Yes |
| Requires extra infra | ✅ No | ❌ Yes (S3, etc.) |
| Backup/versioning | ❌ Manual | ✅ Often built-in |

## Exam Tips

- **Three correct:** A (security), B (complexity), C (collaboration)
- Local = simple but no security/collaboration
- Remote = secure/collaborative but more complex
- Encryption: remote ✅, local ❌ (opposite of the distractor)
- State locking: remote ✅, local ❌
- Number of providers: **not affected** by state backend choice
- Common exam trap: getting the encryption direction backwards (D)
- Another trap: thinking local state has some advantage for provider support (E)
- Key phrase: **"tradeoffs"** implies weighing pros and cons — the three correct answers each describe a different tradeoff dimension
