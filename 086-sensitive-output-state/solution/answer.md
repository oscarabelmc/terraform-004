# Answer

The correct answer is **A — True**.

> Marking an output as `sensitive` does **not** prevent its value from being stored in the Terraform state file.

---

## Why the Answer Is True

`sensitive = true` only affects **display**, not **storage**:

```
┌──────────────────────────────────────────────────────────┐
│  output "db_password" {                                  │
│    value     = random_password.db_master.result          │
│    sensitive = true                                       │
│  }                                                       │
│                                                          │
│  Effect on display:                                      │
│    terraform apply  →  db_password = <sensitive>  ✅     │
│    terraform output →  <sensitive>                ✅     │
│                                                          │
│  Effect on state:                                        │
│    terraform state show  →  result = "p@ssw0rd!"  ❌     │
│    cat terraform.tfstate →  "result": "p@ssw0rd!" ❌     │
└──────────────────────────────────────────────────────────┘
```

### What sensitive does

| Where | Value visible? |
|-------|---------------|
| CLI output (`terraform apply`) | ❌ Hidden (`<sensitive>`) |
| `terraform output` | ❌ Hidden |
| Logs (TF_LOG) | ❌ Hidden |
| **State file** (`terraform.tfstate`) | ✅ **Visible in plain text** |
| **`terraform state show`** | ✅ **Visible** |
| **`terraform state pull`** | ✅ **Visible** |
| **Remote backend storage** | ✅ **Visible** |

### Why this matters

Since state contains the value in plain text, anyone with access to the state can read it. This is why:
- State must be treated as sensitive data
- Remote backends should encrypt state at rest
- Access to state should be restricted via IAM/RBAC
- State should never be committed to version control

## Why "False" Is Incorrect

Choosing "False" would mean believing that `sensitive = true` actually prevents the value from reaching the state file. This is a common misconception.

The exam trick: `sensitive = true` masks display only — the state file always contains all resource attributes in plain text.

## Protecting Sensitive Values in State

| Method | What it does | Effectiveness |
|--------|-------------|---------------|
| `sensitive = true` on outputs | Hides CLI display only | ❌ Doesn't protect state |
| `sensitive = true` on variables | Hides variable value in logs | ❌ Still in state |
| Remote backend encryption | Encrypts state at rest | ✅ Protects state file |
| State access controls (IAM/RBAC) | Restricts who can read state | ✅ Limits exposure |
| Vault/Secrets provider | Fetches secrets at runtime | ⚠️ Result may still be in state |
| Never store secrets in config | Use external secrets manager | ✅ Best practice |

## Exam Tips

- `sensitive = true` = **display only** — does not protect state
- State always contains **plain text** resource attributes
- Anyone with state access can read `sensitive` values
- Protect state with: encryption, access controls, audit logging
- Common exam trap: thinking `sensitive = true` keeps values out of state
- Always remember: state is the source of truth and contains all attribute values regardless of `sensitive` settings
