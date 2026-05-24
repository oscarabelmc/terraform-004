# Answer

The correct answers are **A** and **B**.

> A. State can include plaintext secrets and detailed resource data; commit history can expose them.
>
> B. VCS provides no state locking, so concurrent runs can cause conflicting commits and corrupt state.

---

## Why A and B Are Correct

### A — Secrets in Plaintext

Terraform state files contain **all resource attributes in plaintext**, including sensitive ones:

```json
{
  "resources": [
    {
      "type": "random_password",
      "name": "database",
      "instances": [
        {
          "attributes": {
            "result": "aB3#xK9!mP2$qR7&",   ← plaintext password
            "length": 16
          }
        }
      ]
    },
    {
      "type": "local_file",
      "name": "config",
      "instances": [
        {
          "attributes": {
            "content": "DB_PASSWORD=aB3#xK9!mP2$qR7&",  ← plaintext secret
            "filename": "./config.txt"
          }
        }
      ]
    }
  ]
}
```

Even if you mark an output as `sensitive = true`, the state file stores the value in **plaintext**:

| Location | Secrets Visible? |
|----------|-----------------|
| `terraform plan` output | Hidden (if marked `sensitive`) |
| `terraform.tfstate` | ✅ Always plaintext |
| Git commit history | ✅ Plaintext forever |

**Commit history amplifies the risk** — once committed, the secret is permanently in the git history, even if the file is later removed.

### B — No State Locking in VCS

Version control systems do not provide Terraform's state locking mechanism:

```
Time  User A              User B
  ↓   terraform apply     terraform apply
  ↓   Reads state v1      Reads state v1 (same version)
  ↓   Creates resource    Creates resource (different resource)
  ↓   Writes state v2     Writes state v2 (overwrites A's changes)
  ↓   git commit          git commit (merge conflict or overwrite)
```

The result: **state corruption** — User A's changes are lost because User B overwrote them. Terraform believes the state is complete, but it's missing A's resources.

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| C — State files are too large | State files are typically **small** (kilobytes to a few megabytes). Size is not the primary concern — security and locking are. |
| D — Terraform cannot read state from VCS | Terraform **can** read state from filesystem paths. The issue is security and locking, not technical inability. |
| E — State files are only readable by Terraform | State files are **plain JSON** — human-readable and easily parsed. Anyone can view them. |

## Proper State Management

Instead of committing state to VCS, use a **remote backend**:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

| Feature | VCS | Remote Backend (S3 + DynamoDB) |
|---------|-----|-------------------------------|
| Storage location | Git repository | S3 bucket |
| Secrets encrypted? | ❌ (unless manually encrypted) | ✅ (S3 SSE) |
| State locking | ❌ | ✅ (DynamoDB) |
| Access control | Repo permissions | IAM policies |
| Version history | Git history (permanent) | S3 versioning (manageable) |
| Audit trail | Git blame | Server access logs |

## Standard .gitignore for Terraform

```
# .gitignore
.terraform/
*.tfstate
*.tfstate.backup
crash.log
override.tf
override.tf.json
*_override.tf
*_override.tf.json
```

## Exam Tips

- **Plaintext secrets** in state — passwords, keys, tokens are always visible
- **Commit history** preserves secrets even after deletion — they never truly disappear from git
- **No VCS locking** — concurrent runs corrupt state
- Remote backends solve both problems: **encryption** + **locking**
- Marking an output or variable `sensitive = true` does **not** prevent the value from appearing in state
- The `.terraform.lock.hcl` file is for **provider version pinning**, not state — it's safe to commit
- Common exam pattern: "Why not commit state?" — two answers: secrets exposure + no locking
