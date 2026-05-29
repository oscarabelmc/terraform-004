# Explanation

The correct answer is **B**.

> In each directory (`/dev`, `/staging`, and `/prod`) since each is a separate working directory.

---

## Why B Is Correct

`terraform init` initializes a **single working directory**. Each environment subdirectory is independent:

| Directory | Working Dir | Requires `terraform init` | Has own `.terraform/` | Has own state |
|-----------|-------------|--------------------------|----------------------|---------------|
| `.` (root) | `./` | Yes | `./.terraform/` | `./terraform.tfstate` |
| `dev/` | `./dev/` | Yes | `./dev/.terraform/` | `./dev/terraform.tfstate` |
| `staging/` | `./staging/` | Yes | `./staging/.terraform/` | `./staging/terraform.tfstate` |
| `prod/` | `./prod/` | Yes | `./prod/.terraform/` | `./prod/terraform.tfstate` |

### What `terraform init` Does Per Directory

1. **Downloads provider plugins** — each directory gets its own plugin copies
2. **Installs modules** — resolves `module` blocks for that directory
3. **Configures the backend** — initializes state storage per environment
4. **Creates `.terraform.lock.hcl`** — dependency lock file for that directory
5. **Creates `.terraform/`** — working directory metadata

None of this is shared or recursive.

### Why Running Init Once Isn't Enough

- `.terraform/` is **local to the current directory**
- Provider plugins are **not inherited** by subdirectories
- Each environment has potentially **different backends, providers, or versions**
- State is **per-directory** — each needs its own initialization

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Only in root, `terraform init` is recursive | `terraform init` is **never recursive**. Each working directory must be initialized independently. |
| C — Only in `/prod` | You'd be able to deploy only to prod. Dev and staging would fail with "plugin reinitialization required" errors. |
| D — Any single directory, plugins are shared | Provider plugins are installed per `.terraform/` directory, not globally shared. State and backend config also differ per environment. |
| E — `terraform init` is not needed if you `plan` first | The opposite is true — `terraform plan` requires `terraform init` to have been run first. It will error if plugins are missing. |

## Contrast with `terraform fmt -recursive`

| Command | Recursive? |
|---------|-----------|
| `terraform init` | No — per-working-directory |
| `terraform fmt -recursive` | Yes — formats `.tf` files in all subdirectories |
| `terraform validate` | No — current directory only |
| `terraform plan` | No — current directory only |
| `terraform apply` | No — current directory only |

This is a common exam trap. Only `terraform fmt` has a `-recursive` flag.
