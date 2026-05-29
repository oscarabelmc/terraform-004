# Explanation

The correct answer is **A**.

> Define the provider in `required_providers` and add a matching `provider` block in the configuration.

---

## Why A Is Correct

Provider specification in Terraform uses **two complementary blocks**:

### 1. `required_providers` — Installation

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"    # Where to find the provider
      version = "~> 5.0"           # Version constraint
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
```

This tells Terraform **what** to download during `terraform init`. The `source` attribute specifies the provider's location in the registry, and `version` constrains which version is acceptable.

### 2. `provider` block — Configuration

```hcl
provider "aws" {
  region = "us-east-1"
}

provider "random" {
  # Some providers need no configuration
}
```

This tells Terraform **how** to configure the provider instance. The provider name must match the key in `required_providers`.

### 3. `terraform init` downloads the provider

```bash
$ terraform init

Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 5.0"...
- Finding hashicorp/random versions matching "~> 3.6"...
- Installing hashicorp/aws v5.84.0...
- Installing hashicorp/random v3.6.2...
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — Install manually with apt/brew | Terraform providers are **not OS packages**. They are downloaded and managed by `terraform init` from the Terraform registry. |
| C — Set `TF_PROVIDER` environment variable | No such environment variable exists. Providers are declared in the configuration, not environment variables. |
| D — Only `provider` block | The `provider` block alone configures a provider but does not tell Terraform which provider to **install**. Without `required_providers`, Terraform assumes the provider is from the built-in `hashicorp` namespace, which may use a deprecated lookup. Since Terraform 0.13+, `required_providers` is required. |
| E — Auto-detected from resources | Terraform does not auto-detect providers by scanning resource types — you must declare them explicitly. The `required_providers` block is mandatory. |

## The Evolution of Provider Specification

| Terraform Version | How Providers Were Specified |
|-------------------|------------------------------|
| < 0.13 | Implicit from `provider` block (defaulted to `hashicorp/`) |
| 0.13+ | Explicit `required_providers` block required for non-HashiCorp providers |
| 1.0+ | Best practice: always use `required_providers` for all providers |
| 1.5+ | `required_providers` is the standard approach |

## Provider Source Format

```hcl
required_providers {
  <local_name> = {
    source  = "<registry>/<namespace>/<type>"  # Full source
    version = "<constraint>"                    # Version constraint
  }
}
```

| Component | Example | Meaning |
|-----------|---------|---------|
| `local_name` | `aws` | How you reference the provider in `provider` blocks and resource `provider` arguments |
| `source` | `hashicorp/aws` | Registry location: `registry.terraform.io/hashicorp/aws` |
| `version` | `~> 5.0` | Semver constraint for which versions to allow |

## When a Provider Block Is Optional

Some providers require **no configuration**:

```hcl
# random, null, http, tls, etc.
provider "random" {}       # Empty block (or can be omitted entirely)
provider "null" {}         # Empty block
```

For these, the `provider` block can be empty or omitted — as long as they're in `required_providers`, `terraform init` will download them.
