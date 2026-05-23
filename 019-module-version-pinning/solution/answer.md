# Answer

The correct answer is **B — to pin a specific module release and avoid unexpected upgrades**.

## Why

The `version` argument in a `module` block constrains which version of a registry module Terraform downloads. Without it, `terraform init` fetches the **latest** version — which can introduce breaking changes without warning.

With version pinning:

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
  name    = "my-vpc"
}
```

- `terraform init` downloads `5.0.0` exactly
- All team members and CI/CD pipelines get the **same** version
- New major releases are adopted **intentionally** (by updating the version string)

## Version Constraint Syntax

| Syntax | Meaning | Matches |
|--------|---------|---------|
| `= 1.0.0` | Exact version only | `1.0.0` |
| `~> 1.0` | Pessimistic constraint (≥ 1.0, < 2.0) | `1.0.0`, `1.5.0`, `1.9.9` |
| `~> 1.0.0` | Pessimistic constraint (≥ 1.0.0, < 1.1.0) | `1.0.0`, `1.0.5` |
| `>= 1.0, < 2.0` | Range constraint | `1.0.0` through `1.999.999` |
| (omitted) | **No constraint** — pulls latest | Whatever the registry returns |

## When Does `version` Apply?

| Module source | `version` respected? |
|--------------|---------------------|
| **Registry** (`hashicorp/consul/aws`) | **Yes** — required for reproducibility |
| **Local path** (`./modules/my-module`) | **No** — recorded but ignored; always uses local files |
| **Git** (`git::https://...`) | **No** — version is taken from the git ref |
| **HTTP URL** (`https://...`) | **No** — version is taken from the URL |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Specify input variable types | Variable types are declared in the **child module's** `variables.tf`, not in the `module` block. |
| C — Enable parallel downloads | Terraform downloads modules in parallel by default regardless of `version`. |
| D — Authenticate with private registry | Authentication uses `~/.terraformrc` or `TERRAFORM_CONFIG` environment variables, not `version`. |
| E — Optional with no effect | Version pinning has a **major effect** — it determines which module release is used. Omitting it is a risk. |

## Exam Tips

- The key phrase: **"pin a specific module release"** — reproducibility across environments and teams
- Without `version`, different `terraform init` runs may download different module versions
- `~>` (pessimistic constraint) is the most common pattern: `~> 3.0` means "any 3.x but not 4.0"
- Only **registry modules** use the `version` argument — local and git-sourced modules do not
- `terraform init -upgrade` overrides the lock file but still respects version constraints
