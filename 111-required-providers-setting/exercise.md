# Required Providers Setting Exercise

**Domain:** IaC Workflow
**Topic:** `required_providers` — setting in terraform block for source + version

## Description

In the top-level `terraform` block, which setting specifies a provider's source and version constraints

## Learning Objectives

- Examine the terraform block
- Break down the source and version
- What happens without required_providers
- Compare with other terraform block settings

## Background

The `terraform` block supports several settings for configuring how Terraform behaves:

```hcl
terraform {
  required_version   = ">= 1.5"     # Terraform Core version constraint
  required_providers = { ... }      # Provider source + version constraints ← THIS
  backend "s3" { ... }              # State backend configuration
}
```

The `required_providers` block is where you declare which provider plugins Terraform must download and what versions are acceptable.

## Steps

### Part 1 — Examine the terraform block

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The `terraform` block contains `required_providers`:

   ```hcl
   terraform {
     required_version = ">= 1.5"

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
   }
   ```

2. **Identify the setting name:**

   The setting is `required_providers` — it's a **map** where each key is the provider name and each value specifies:
   - `source` — the registry namespace and type (e.g., `hashicorp/aws`)
   - `version` — version constraint string (e.g., `~> 5.0`)

### Part 2 — Break down the source and version

3. **The `source` attribute:**

   ```
   source = "hashicorp/aws"
              ▲         ▲
              │         └── Provider type (aws, azurerm, random, etc.)
              └── Namespace (publisher: hashicorp, iap, etc.)
   ```

   The source tells Terraform **where** to find the provider plugin in the registry.

4. **The `version` attribute:**

   | Constraint | Meaning | Example matches |
   |-----------|---------|----------------|
   | `"~> 5.0"` | Any 5.x version | 5.0, 5.1, 5.84 — but not 6.0 |
   | `">= 4.0, < 5.0"` | 4.x only | 4.0, 4.99 — but not 5.0 |
   | `"= 5.10.0"` | Exact version | 5.10.0 only |
   | `">= 3.0"` | At least 3.0 | 3.0, 4.0, 5.0 — any higher |

### Part 3 — What happens without required_providers

5. **Without `required_providers`, Terraform uses defaults:**

   ```hcl
   terraform {
     # No required_providers block
   }

   provider "aws" {
     region = "us-east-1"
   }
   ```

   Terraform assumes the source is `hashicorp/<type>` (e.g., `hashicorp/aws`). This works for official HashiCorp providers but fails for community or third-party providers.

6. **Best practice — always declare `required_providers`:**

   ```
   ✅ required_providers specified:
      - Explicit source (works for any provider)
      - Version constraint (prevents unexpected upgrades)
      - Lock file (.terraform.lock.hcl) records exact versions

   ❌ required_providers omitted:
      - Implicit source (only works for hashicorp/*)
      - No version constraint (always gets latest)
      - Inconsistent versions across team members
   ```

### Part 4 — Compare with other terraform block settings

7. **All settings in the `terraform` block:**

   | Setting | Purpose | Example |
   |---------|---------|---------|
   | `required_version` | Pin Terraform Core version | `">= 1.5"` |
   | **`required_providers`** | **Specify provider source + version** | `aws = { source = "hashicorp/aws", version = "~> 5.0" }` |
   | `backend` | Configure state storage backend | `backend "s3" { bucket = "..." }` |
   | `cloud` | Configure HCP Terraform integration | `cloud { organization = "..." }` |

## Files

- `main.tf` — config with `required_providers` in the terraform block
- `outputs.tf` — output values
- `solution/` — reference implementation

