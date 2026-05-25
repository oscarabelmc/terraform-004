# Answer

The correct answer is **B**.

> To bring the database under Terraform management so future changes can be tracked and managed through your IaC workflow.

---

## Why B Is Correct

The primary purpose of `terraform import` is **adoption** — adding an existing resource to Terraform state so it becomes part of the IaC workflow:

```hcl
import {
  to = aws_db_instance.production    # Resource address in Terraform
  id = "manually-created-db-instance" # Real-world resource identifier
}
```

### What import achieves

```
┌──────────────────────────────────────────────────────────┐
│                Before Import (Manual DB)                  │
├──────────────────────────────────────────────────────────┤
│  • Exists in AWS console                                 │
│  • Changes via CLI or UI                                 │
│  • No code, no review, no audit trail                    │
│  • Unknown to Terraform (not in state)                   │
└──────────────────────────────────────────────────────────┘
                          │
                          ▼
                    terraform import
                          │
                          ▼
┌──────────────────────────────────────────────────────────┐
│                 After Import (Managed DB)                 │
├──────────────────────────────────────────────────────────┤
│  • Exists in AWS console                                 │
│  • In Terraform state ✅                                 │
│  • Future changes via terraform plan → apply             │
│  • Code reviewed via PR                                  │
│  • Version controlled in Git                             │
│  • Consistency with other IaC-managed resources          │
└──────────────────────────────────────────────────────────┘
```

### The IaC workflow after import

```
1. Code:   Edit main.tf (e.g., change instance_class)
2. Review: terraform plan → show changes → PR approval
3. Apply:  terraform apply → modify the database via IaC
4. Track:  Git history shows when and why the change was made
```

This is the **primary reason** to import — not to modify the resource immediately, but to bring it under management so all **future** changes follow the IaC workflow.

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Destroy and recreate | Import **adopts** the existing resource — there's no need to destroy it. Destroying and recreating would cause downtime and data loss. |
| C — Create a copy for dev | Import brings the existing resource under management — it doesn't create copies. If you need a dev copy, create a new resource (not import). |
| D — Modify to match defaults | Import does **not modify** the resource. The resource remains exactly as it is. You can then use Terraform to apply changes in subsequent runs if needed. |
| E — Delete from cloud | Import is the **opposite** of delete — it adds to state to prevent accidental deletion. |

## When to Use Import

| Scenario | Should you import? |
|----------|-------------------|
| Resource created manually, now needs IaC management | ✅ Yes |
| Resource was created by another Terraform config | ❌ No — use `terraform state mv` or data sources |
| Resource is temporary/test-only | ❌ No — leave it outside IaC or destroy it |
| Need to modify the resource going forward | ✅ Yes — import first, then modify via IaC |

## Import Methods

| Method | Command | Terraform version |
|--------|---------|-------------------|
| **Config-driven** | `import {}` block + `terraform plan`/`apply` | 1.5+ (recommended) |
| **CLI** | `terraform import <address> <id>` | All versions (legacy) |

Both achieve the same result — the resource is added to state.

## Exam Tips

- Primary reason to import: **bring existing resources under IaC management**
- Import does **not create** resources (they must already exist)
- Import does **not modify** resources (they remain as-is)
- After import, all future changes use the standard IaC workflow
- Import requires a matching resource block in configuration
- Common exam trap: thinking import creates or modifies resources (it only adopts them into state)
- Another trap: thinking import is for emergency changes (it's for adoption into IaC)
