# Explanation

The correct answer is **B**.

> `required_providers`

---

## Why B Is Correct

The `required_providers` block inside the `terraform` block is the setting that specifies each provider's source and version constraints:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"    # registry namespace/type
      version = "~> 5.0"           # version constraint
    }
  }
}
```

Each entry in `required_providers` declares:
| Field | Required? | Purpose |
|-------|:---------:|---------|
| `source` | ✅ | Full registry path: `<namespace>/<type>` |
| `version` | ❌ | Constraint string for acceptable versions |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — `required_version` | This sets the **Terraform Core** version constraint (`">= 1.5"`), not provider source or version. |
| C — `backend` | This configures **state storage** (S3, AzureRM, etc.). It has nothing to do with providers. |
| D — `provider` | `provider` is a **separate block** (outside `terraform`) that configures **instances** of providers (region, alias, etc.). It does not specify source or version. |
| E — `provider_source` | **No such setting exists.** This is a made-up distractor. |

## Anatomy of the terraform Block

```hcl
terraform {
  # ┌─ Core version (optional)
  required_version = ">= 1.5"
  #
  # ┌─ Provider specifications (optional but recommended)
  # │   ├── aws:    source = "hashicorp/aws",    version = "~> 5.0"
  # │   ├── random: source = "hashicorp/random",  version = "~> 3.6"
  # │   └── azurerm: source = "hashicorp/azurerm", version = "~> 3.0"
  # │
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  #
  # ┌─ Backend configuration (optional)
  backend "s3" {
    bucket = "my-state-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
```

## Source Format

```
source = "<namespace>/<type>"

Namespace:  The organization or publisher (hashicorp, iap, your-org, etc.)
Type:       The provider name (aws, azurerm, random, google, etc.)

Examples:
  hashicorp/aws     → Official AWS provider
  hashicorp/random  → Official Random provider
  iap/postgresql    → Community PostgreSQL provider
  your-org/custom   → Your own custom provider
```

## Version Constraints

| Pattern | Meaning |
|---------|---------|
| `"~> 5.0"` | Any 5.x (pessimistic constraint) |
| `">= 4.0, < 5.0"` | 4.x range |
| `"= 5.10.0"` | Exact version |
| `">= 3.0"` | At least 3.0 |
| `"~> 5.0.0"` | Any 5.0.x |
