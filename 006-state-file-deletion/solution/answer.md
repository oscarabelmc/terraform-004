# Answer

The correct answer is **C — Terraform loses the mapping to existing resources, making them orphaned and unmanaged.**

## Why This Is the Most Serious Consequence

Terraform's state file is the **sole source of truth** for the mapping between your configuration and real-world infrastructure. Without it, Terraform has no way of knowing which resources it already manages.

The chain of problems:

1. **No knowledge of existing resources** — `terraform plan` shows everything as "create"
2. **Running `apply` creates duplicates** — new resources alongside the originals
3. **Running `destroy` only removes the new ones** — originals become permanently orphaned
4. **Orphaned resources must be manually cleaned up** — you must find and delete them outside of Terraform

## The `.backup` File

Terraform automatically creates `terraform.tfstate.backup` before every state write. This is your primary recovery mechanism for local backends:

```bash
cp terraform.tfstate.backup terraform.tfstate
```

This restores the previous state, but **any changes made between the backup and the deletion are lost**.

## Prevention

| Method | How it helps |
|--------|-------------|
| **Remote backend** (S3, GCS, Azurerm) | State is stored remotely and **versioned** — you can roll back to any version |
| **State locking** (DynamoDB, Consul) | Prevents concurrent modifications that could corrupt state |
| **Terraform Cloud/Enterprise** | Managed state with history, locking, and audit trails |
| **Version control** | Never commit `terraform.tfstate` to git, but do store it in a safe remote location |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Auto-recovers from config | Terraform **never** auto-recovers state from config. Config describes *what you want*, state describes *what exists*. |
| B — Confirms deletion | No such confirmation exists for deleting the local state file. The OS `rm` command doesn't ask. |
| D — Backup is redundant | The backup exists, but **any changes since the last backup are lost**. It's also possible to accidentally delete both. |
| E — Plan updates existing | Without state, Terraform has no knowledge of existing resources. It cannot update what it doesn't know about. |

## Exam Tips

- The state file is **NOT** optional — Terraform fundamentally requires it.
- Deleting state does **NOT** destroy infrastructure. It only loses the tracking.
- Always use a **remote backend with versioning** for any non-trivial environment.
- `terraform.tfstate.backup` is created automatically — it's your safety net for local backends.
- The exam may ask: "What happens to the real resources?" → They **continue running**, orphaned.
