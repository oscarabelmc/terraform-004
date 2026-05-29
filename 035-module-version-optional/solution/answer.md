# Explanation

The correct answer is **A**.

> No, the version argument is optional, but it is recommended to ensure consistent and reproducible deployments.

---

## Why A Is Correct

The `version` argument in a `module` block is **optional**:

```hcl
# Valid — no version constraint
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  # defaults to latest
}

# Also valid — with version constraint
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
}
```

However, omitting `version` means Terraform downloads the **latest** version every time you run `terraform init`. This can cause:

- **Unexpected infrastructure changes** — the new module version may change resource behavior
- **Breaking changes** — module updates can deprecate or rename variables/outputs
- **Non-reproducible deployments** — running `terraform init` a month later may download a different version

**Best practice:** Always pin a version constraint to ensure every team member and CI/CD pipeline uses the same module version.

## Terraform Registry Version Resolution

```
Without version:          Terraform downloads latest
With "~> 5.0":            Terraform downloads 5.x (never 6.x)
With ">= 5.0, < 6.0":    Same as ~> 5.0
With "5.0.0":            Exact version only
```

The resolved version is recorded in `.terraform.lock.hcl`:

```hcl
provider "registry.terraform.io/hashicorp/aws" {
  version     = "5.84.0"
  constraints = "~> 5.0"
}
```

But the lock file only applies to **providers**, not modules. Module versions are resolved and recorded in the `.terraform/modules/` directory, and re-resolved when you run `terraform init` with the `-upgrade` flag.

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — Required for all registry modules | The `version` argument is **optional** for all module sources. Never a hard requirement. |
| C — Should never be specified | Pinning versions is a standard software engineering practice. Omitting it causes non-reproducible builds. |
| D — Only for private registries | Version constraints work the same for public and private registries — always optional, always recommended. |
| E — Only for local modules | Local modules (`source = "./modules/foo"`) don't support `version` at all — they resolve at filesystem path. Version is only for registry or remote module sources. |

## When Version Is Not Applicable

| Module Source | Can Use `version`? |
|--------------|-------------------|
| Terraform Registry | ✅ `version = "~> 5.0"` |
| Private Registry | ✅ `version = ">= 1.0"` |
| GitHub (git URL) | ❌ (use `ref` instead) |
| Local path (`./modules/foo`) | ❌ |
| HTTP URL | ❌ |
