# Answer

The correct answer is **B — Remove the database and backup resource blocks from your configuration, then run `terraform apply`.**

## Why

Removing resource blocks from the configuration and running `terraform apply` is the standard Terraform workflow for decommissioning resources:

1. **Edit the config** — delete the resource blocks for the resources you no longer want
2. **Run `terraform plan`** — preview: the removed resources show as **destroyed**
3. **Run `terraform apply`** — Terraform destroys those resources, leaving everything else unchanged

This approach:
- Is **declarative** — the config reflects the desired state (database doesn't exist)
- Is **auditable** — the change is captured in version control (`git diff` shows the removal)
- Preserves **all other resources** — only what you remove from config is affected

## What Happens During Apply

```
Before apply:                     After apply:
┌──────────────────────┐          ┌──────────────────────┐
│ random_pet.database  │  DESTROY │                      │
│ random_pwd.db_backup │─────────>│                      │
│ random_pet.server    │          │ random_pet.server    │
│ random_pet.cache     │  KEEP    │ random_pet.cache     │
│ random_pet.queue     │          │ random_pet.queue     │
│ local_file.inventory │  UPDATE  │ local_file.inventory │
└──────────────────────┘          └──────────────────────┘
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — `terraform destroy -target=...` | `-target` on `destroy` can work for simple cases, but it's **dangerous** in complex configurations — it may skip dependencies and leave dangling resources. Removing from config and running `apply` is the safer, standard approach. |
| C — `terraform state rm` | Only removes the resource from state — the **real infrastructure still exists** and is now orphaned (unmanaged, still running, still costing money). |
| D — Manually delete in Console | The resource is deleted, but **Terraform state still references it**. The next `terraform plan` will try to recreate it to match the config. You'd need to also run `terraform state rm` — two steps instead of one. |
| E — `terraform destroy` and recreate | Destroys **all** 50 resources, then you'd need to recreate 49 of them. Massive downtime, risk of data loss, and completely unnecessary. |

## Exam Tips

- **To decommission:** remove the resource block from config → `terraform apply`
- **To remove from management (but keep running):** `terraform state rm` (use with caution)
- `terraform destroy` removes **everything** — never use it when you only need to remove specific resources
- The config is the source of truth — if it's not in the config, Terraform will destroy it on next apply
- Always run `terraform plan` first to verify only the intended resources will be destroyed
