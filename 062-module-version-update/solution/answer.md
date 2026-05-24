# Answer

The correct answers are **B** and **D**.

> **B.** Update the version argument to allow 5.3.0 using `version = "~> 5.3.0"`
>
> **D.** Run `terraform init -upgrade` to download the new module version

---

## Why B and D Are Correct

Upgrading a module version is a **two-step process**:

### Step 1 — Update the version constraint (B)

Change the version argument in the module block from an exact pin to a constraint that includes 5.3.0:

```hcl
# Before (exact pin):
version = "5.2.0"

# After (pessimistic constraint allowing 5.3.x):
version = "~> 5.3.0"
```

The `~> 5.3.0` constraint means "any version >= 5.3.0 and < 5.4.0." This:
- ✅ Allows the upgrade to 5.3.0
- ✅ Automatically accepts future patch versions (5.3.1, 5.3.2, etc.)
- ✅ Blocks major breaking changes (6.0.0)

### Step 2 — Re-initialize with upgrade flag (D)

```bash
terraform init -upgrade
```

This is required because Terraform **caches** modules locally:

```
.terraform/modules/
└── compute/          ← cached copy of 5.2.0
```

Without `-upgrade`, `terraform init` sees the cache and skips downloading. The `-upgrade` flag tells Terraform to:
1. Ignore the cached version
2. Query the registry for versions matching the new constraint
3. Download and cache the latest matching version

### Why both steps are needed

```
┌──────────────────────────────────────────────────────┐
│  Just change version in code                         │
│  → terraform init (no -upgrade)                      │
│  → Uses cached 5.2.0 ❌ (skips download)             │
├──────────────────────────────────────────────────────┤
│  Just run terraform init -upgrade                    │
│  → No version constraint change                      │
│  → Still downloads 5.2.0 ❌ (matches existing pin)   │
├──────────────────────────────────────────────────────┤
│  Change version + terraform init -upgrade            │
│  → New constraint is "~> 5.3.0"                      │
│  → -upgrade forces re-download                       │
│  → Downloads 5.3.0 ✅                                │
└──────────────────────────────────────────────────────┘
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Change to `version = "5.3.0"` | This is an exact pin to 5.3.0 — it works but is overly restrictive. The question asks for the **safer** approach using `~>`, which allows patch updates within 5.3.x. Also, A alone is missing the second step. |
| C — Run `terraform apply` | `terraform apply` does not download modules. It only applies changes. Module downloads happen during `terraform init`. |
| E — Delete `.terraform` directory | While this would force a re-download, it's **not recommended** — you lose all cached provider plugins and module data. `terraform init -upgrade` is the correct way to refresh modules. |

## Module Update Workflow

```
1. Edit version constraint in code
         │
         ▼
2. Review the change       ────  Is version constraint
         │                       correct?
         ▼
3. terraform init -upgrade ────  Downloads new version
         │
         ▼
4. terraform plan          ────  Review for unexpected changes
         │
         ▼
5. terraform apply         ────  Deploy with new module version
```

## Version Constraint Comparison

| Constraint | Meaning | Use case |
|-----------|---------|----------|
| `= 5.2.0` | Exactly 5.2.0 | Production pinning |
| `~> 5.3.0` | >= 5.3.0, < 5.4.0 | Safe minor upgrade with patch flexibility |
| `>= 5.3.0` | Any version >= 5.3.0 | Too permissive — allows major bumps |
| `~> 5.0` | >= 5.0, < 6.0 | Broad range within major version |

## Exam Tips

- Updating a module version always requires **two steps**: code change + `init -upgrade`
- `terraform init -upgrade` is the command to re-download modules/providers with updated constraints
- Simply editing `version` in code does **not** immediately download the new version
- The `~>` (pessimistic) constraint is the safest way to allow minor/patch upgrades
- Never delete `.terraform/` as a routine step — use `init -upgrade` instead
- Always run `terraform plan` after a module upgrade to review changes before applying
- Common exam trap: thinking `terraform init` (without `-upgrade`) re-downloads modules when the version changes (it does not — it uses the cache)
