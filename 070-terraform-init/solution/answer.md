# Explanation

The correct answers are **B**, **C**, and **D**.

> **B.** Initializes the backend configuration.
>
> **C.** Downloads the required modules referenced in the configuration.
>
> **D.** Downloads the providers/plugins required to execute the configuration.

---

## Why B, C, and D Are Correct

`terraform init` performs three core actions:

```
╔══════════════════════════════════════════════════════╗
║                 terraform init                       ║
╠══════════════════════════════════════════════════════╣
║                                                      ║
║   ┌──────────────────────────────────────────────┐   ║
║   │ B - Initialize backend                       │   ║
║   │     ─ Configure state storage backend        │   ║
║   │     ─ Create/update .terraform/terraform.    │   ║
║   │       tfstate with backend config             │   ║
║   │     ─ Set up state locking (if applicable)   │   ║
║   └──────────────────────────────────────────────┘   ║
║                                                      ║
║   ┌──────────────────────────────────────────────┐   ║
║   │ C - Download modules                         │   ║
║   │     ─ Fetch modules from registry or sources │   ║
║   │     ─ Cache in .terraform/modules/           │   ║
║   │     ─ Resolve module versions                │   ║
║   └──────────────────────────────────────────────┘   ║
║                                                      ║
║   ┌──────────────────────────────────────────────┐   ║
║   │ D - Download provider plugins                │   ║
║   │     ─ Install providers from registry        │   ║
║   │     ─ Cache in .terraform/providers/         │   ║
║   │     ─ Enforce version constraints            │   ║
║   │     ─ Generate .terraform.lock.hcl           │   ║
║   └──────────────────────────────────────────────┘   ║
║                                                      ║
╚══════════════════════════════════════════════════════╝
```

### B — Initialize backend

Reads the `backend "s3" {}` block and configures the state storage:

```hcl
backend "s3" {
  bucket = "terraform-state-demo"
  key    = "init-demo/terraform.tfstate"
  region = "us-east-1"
}
```

Creates `.terraform/terraform.tfstate` (local cache of backend config).

### C — Download modules

Resolves and downloads all `module` blocks with `source`:

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
}
```

Cached in `.terraform/modules/`.

### D — Download provider plugins

Installs provider binaries specified in `required_providers`:

```hcl
required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
  }
}
```

Cached in `.terraform/providers/`.

## Why the Incorrect Option Is Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Provisions resources | Provisioning is done by **`terraform apply`**, not `init`. Init only prepares the working directory. Resources are created, updated, or destroyed during the apply phase. |

## Before vs After terraform init

| State | Before `init` | After `init` |
|-------|---------------|--------------|
| `.terraform/providers/` | Empty | Provider plugins downloaded |
| `.terraform/modules/` | Empty | Module code downloaded |
| `.terraform/terraform.tfstate` | Missing | Backend config cached |
| `.terraform.lock.hcl` | Missing | Provider version lock created |
| `terraform plan` | ❌ Fails — need init | ✅ Works |

## When to Run terraform init

- When cloning a repo with Terraform configs
- After adding new providers or modules
- After changing backend configuration
- After changing provider version constraints
- After running `terraform init -upgrade`

It is **safe to run repeatedly** — it's idempotent.

## Objective Reference

**Objective 3b** — Initialize a Terraform working directory.

`terraform init` is the first command after writing config or cloning from VCS. It initializes backends, downloads providers and modules, and is safe to run multiple times.
