# Explanation

The correct answer is **A**.

> HCP Terraform private registry

---

## Why A Is Correct

The **HCP Terraform private module registry** allows organizations to publish, version, and share custom Terraform modules that are **only accessible within your organization**. It provides:

| Feature | Benefit |
|---------|---------|
| **Organization-scoped** | Only members of your HCP Terraform org can use the modules |
| **VCS integration** | Connect GitHub/GitLab repos — new tags auto-publish new versions |
| **Semantic versioning** | Git tags like `v1.0.0` become module versions |
| **README rendering** | Module documentation is auto-generated from the repo's README |
| **Searchable** | Team members can browse available modules in the HCP Terraform UI |

### Private Registry Module Source Format

```hcl
module "my_module" {
  source  = "app.terraform.io/my-org/my-module/aws"
  version = "~> 1.0"
}
```

| Component | Meaning |
|-----------|---------|
| `app.terraform.io` | HCP Terraform hostname |
| `my-org` | Your organization name |
| `my-module` | Module name (matches repo name) |
| `aws` | Target provider |

### Publishing Workflow

```
1. Create module repo ──→ 2. Write Terraform configs + README ──→ 3. Tag release (v1.0.0)
                                                                    ↓
4. HCP Terraform imports ──→ 5. Team uses source = "app.terraform.io/org/module/provider"
```

## Why the Others Are Wrong

| Option | What It Does | Why Not Correct |
|--------|-------------|-----------------|
| B — Workspace | Manages state, variables, and run history | Does not store or distribute modules. Workspaces consume modules, they don't publish them. |
| C — Run triggers | Auto-queues a downstream workspace run after an upstream apply | Orchestrates workspace runs, not module distribution. |
| D — Policy sets (Sentinel) | Enforces compliance policies on Terraform runs | Controls what can be deployed, not what modules are available. |
| E — Variable sets | Reusable groups of variables shared across workspaces | Manages configuration data, not module code. |

## Private vs Public Registry

| Aspect | Public (registry.terraform.io) | Private (HCP Terraform) |
|--------|------------------------------|------------------------|
| Visibility | Everyone | Your org only |
| Authentication | None | HCP Terraform token |
| Source format | `hashicorp/consul/aws` | `app.terraform.io/org/name/provider` |
| Version control | Git tags on GitHub | Git tags on connected VCS |
| CI/CD publishing | Manual / GitHub Actions | Auto-import from VCS |
| Cost | Free | Included with HCP Terraform |
