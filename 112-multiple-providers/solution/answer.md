# Answer

The correct answer is **A — True**.

---

## Why True Is Correct

Multiple providers **can** be declared within a single Terraform configuration file. This is a fundamental capability of Terraform.

### Example

```hcl
terraform {
  required_providers {
    aws    = { source = "hashicorp/aws",    version = "~> 5.0" }
    random = { source = "hashicorp/random", version = "~> 3.6" }
    local  = { source = "hashicorp/local",  version = "~> 2.5" }
  }
}

provider "aws"    { region = "us-east-1" }
provider "random" { }
provider "local"  { }
```

All three providers are declared in the same file and work together. Resources from different providers can even reference each other:

```hcl
resource "random_pet" "server" {
  length = 2
}

resource "local_file" "config" {
  content  = random_pet.server.id   # cross-provider reference
  filename = "config.txt"
}
```

### What makes this possible

Terraform's **plugin architecture** allows each provider to run as a separate process. The core engine orchestrates them:

```
Terraform Core
      │
      ├── Provider: AWS     (manages aws_* resources)
      ├── Provider: Random  (manages random_* resources)
      └── Provider: Local   (manages local_* resources)
```

Each provider plugin is independent — they don't interfere with each other.

### Why B (False) is incorrect

Saying "False" would imply Terraform can only manage resources from one provider at a time, which contradicts Terraform's multi-cloud and multi-service design philosophy. The ability to use multiple providers in one config is a key exam objective.

## Real-World Multi-Provider Examples

| Configuration | Providers | Why |
|--------------|-----------|-----|
| Web app on AWS + Cloudflare DNS | `aws` + `cloudflare` | Infrastructure + DNS management |
| Kubernetes cluster + deployed apps | `aws` (or `gcp`) + `kubernetes` + `helm` | Create cluster then deploy to it |
| Database + monitoring | `aws` (or `azurerm`) + `datadog` | Create resources then configure monitoring |
| Multi-cloud disaster recovery | `aws` + `azurerm` | Active in AWS, standby in Azure |
| Infrastructure + random naming | `aws` + `random` | Generate unique names for resources |

## Exam Tips

- **True** — multiple providers in one config is fully supported
- Each provider needs: `required_providers` entry + `provider` configuration block
- Multiple instances of the **same** provider use the `alias` meta-argument
- Cross-provider references work via Terraform's dependency graph
- Common exam trap: thinking each provider needs its own directory or config file
- Another trap: confusing "multiple providers" with "multiple provider aliases" (different concepts)
- Key phrase: **"within a single Terraform configuration file"** — yes, multiple providers can coexist
