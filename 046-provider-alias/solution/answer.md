# Answer

The correct answer is **A**.

> `alias`

---

## Why A Is Correct

The `alias` argument differentiates multiple configurations of the same provider:

```hcl
# Default provider — no alias needed
provider "aws" {
  region = "us-east-1"
}

# Aliased provider — uses "alias" to avoid conflict
provider "aws" {
  alias  = "mumbai"
  region = "ap-south-1"
}
```

Without `alias`, Terraform sees two `provider "aws"` blocks and doesn't know which is which — hence the "Duplicate provider configuration" error.

### How to Reference Each Provider

| Provider Configuration | How to Reference in Resources |
|------------------------|-------------------------------|
| Default (no alias) | `provider = aws` (or omit — it's the default) |
| Aliased | `provider = aws.<alias_name>` |

```hcl
# Uses default provider (us-east-1)
resource "aws_instance" "web_us" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

# Uses aliased provider (ap-south-1)
resource "aws_instance" "web_mumbai" {
  provider      = aws.mumbai
  ami           = "ami-0c55b159cbfafe1f1"
  instance_type = "t2.micro"
}
```

## Why the Others Are Wrong

| Option | Purpose | Why Not Correct |
|--------|---------|-----------------|
| B — `profile` | Sets the AWS CLI profile (credentials) | Only one per provider block; doesn't differentiate provider configurations. Two blocks with different profiles still need aliases. |
| C — `name` | Not a valid provider argument | Terraform providers don't have a `name` argument. |
| D — `source` | Specifies the provider source (in `required_providers` block) | Used in the `terraform` block to specify where to download the provider, not to differentiate configurations. |
| E — `version` | Specifies provider version constraint | Used in `required_providers` or the provider block, but doesn't help differentiate configurations — both blocks would use the same version. |

## Provider Configuration Rules

| Scenario | Requires Alias? | Example |
|----------|----------------|---------|
| Single provider config | ❌ | `provider "aws" { region = "us-east-1" }` |
| Multiple of same provider | ✅ | `alias = "west"`, `alias = "east"` |
| Different providers | ❌ | `provider "aws" {}` + `provider "azurerm" {}` |
| Module with provider passed in | ❌ (uses `providers` mapping) | `providers = { aws = aws.west }` |

## Common Use Cases for Provider Aliases

| Use Case | Why Multiple Providers |
|----------|----------------------|
| **Multi-region deployment** | Deploy the same resource to us-east-1 and eu-west-1 |
| **Multi-account setup** | Use different AWS accounts for different environments |
| **Cross-provider resources** | e.g., DNS in us-east-1, compute in eu-west-1 |
| **Provider with different credentials** | Different IAM roles for different resources |

## Exam Tips

- `alias` is the argument that differentiates multiple configurations of the **same** provider
- The first/default provider block does **not** need `alias`
- Every additional provider block of the same type **must** have a unique `alias`
- Reference aliased providers as `provider = <provider_type>.<alias>` in resources
- `alias` is also used in `required_providers` to configure provider versions per alias
- Modules can accept aliased providers via `providers` mapping
- The error message literally tells you: "set the 'alias' argument" — a strong hint for the exam
- Common exam scenario: two `provider "aws"` blocks causing a duplicate error → add `alias`
