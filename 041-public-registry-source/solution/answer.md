# Answer

The correct answer is **A**.

> The Terraform public registry

---

## Why A Is Correct

The module source `terraform-aws-modules/transit-gateway/aws` follows the **Terraform Public Registry** naming convention:

```
<namespace>/<module-name>/<provider>
```

| Component | In This Example | Meaning |
|-----------|----------------|---------|
| **Namespace** | `terraform-aws-modules` | The organization that maintains the module |
| **Module Name** | `transit-gateway` | The specific module |
| **Provider** | `aws` | The target cloud provider |

### How Terraform Resolves the Source

When you run `terraform init` with this source:

1. Terraform recognizes `<namespace>/<name>/<provider>` as a public registry format
2. It resolves to: `https://registry.terraform.io/modules/terraform-aws-modules/transit-gateway/aws`
3. It downloads the specified version (`3.0.3`) from the registry API

### Why the `version` Argument Supports Registry

The `version` argument only works with **registry sources** (public or private):

```hcl
version = "3.0.3"  # ✅ Valid for public/private registry
# ❌ Not valid for: local paths, git URLs, HTTP URLs
```

Local and git sources handle versioning differently:
- **Local modules**: No versioning (resolved by filesystem path)
- **Git modules**: Use `ref` argument for tags/branches/commits

## Source Format Reference

| Format | Example | Where |
|--------|---------|-------|
| `<namespace>/<name>/<provider>` | `hashicorp/consul/aws` | **Public Registry** ✅ |
| `<hostname>/<namespace>/<name>/<provider>` | `app.terraform.io/my-org/vpc/aws` | **Private Registry** |
| `./<path>` | `./modules/networking` | **Local filesystem** |
| `git::<url>` | `git::https://github.com/org/repo.git` | **Git repository** |
| `http://<url>` | `http://example.com/module.zip` | **HTTP URL** |
| `<prefix>//<subdir>` | `github.com/org/repo//modules/child` | **Subdirectory** in any source |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — Private registry | Private registry sources include a **hostname prefix** like `app.terraform.io/my-org/...`. The source in the question has no hostname. |
| C — Local filesystem | Local paths start with `./` or `../`, e.g., `./modules/transit-gateway`. Three-segment format with slashes is never a local path. |
| D — Git repository | Git sources must start with `git::` or use a format like `github.com/org/repo`. The three-segment format is exclusively a registry pattern. |
| E — HTTP URL | HTTP sources start with `http://` or `https://`. The three-segment format doesn't contain `://`. |

## Exam Tips

- **Three-segment source** = public registry (`namespace/name/provider`)
- **Four-segment with hostname** = private registry (`hostname/namespace/name/provider`)
- **Leading `./` or `../`** = local module
- **Contains `://`** = git or HTTP source
- `version` argument only works with **registry** sources
- Public registry URL pattern: `registry.terraform.io/modules/<namespace>/<name>/<provider>`
- Common module namespace examples: `hashicorp/`, `terraform-aws-modules/`, `terraform-google-modules/`, `Azure/`
- The provider suffix (`/aws`, `/azurerm`, `/google`) matches the **target** provider, not the module source
