# Multiple Providers in One Config Exercise

**Exam Question:** True or False? Multiple providers can be declared within a single Terraform configuration file.

## Background

Terraform supports **multi-provider configurations** — you can declare and use multiple providers in the same directory. This is one of Terraform's core strengths: managing diverse infrastructure across different platforms from a single configuration.

```hcl
# Single config file — multiple providers
terraform {
  required_providers {
    aws    = { source = "hashicorp/aws",    version = "~> 5.0" }
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
    random  = { source = "hashicorp/random",  version = "~> 3.6" }
  }
}

provider "aws"    { region = "us-east-1" }
provider "azurerm" { features {} }
provider "random"  { }
```

## Steps

### Part 1 — Examine a multi-provider config

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The config declares three providers: `aws`, `random`, and `local`. Each is configured with its own `provider` block.

2. **Initialize:**

   ```bash
   terraform init
   ```

   Terraform downloads all three provider plugins:

   ```
   Initializing provider plugins...
   - Finding hashicorp/aws versions matching "~> 5.0"...
   - Finding hashicorp/random versions matching "~> 3.6"...
   - Finding hashicorp/local versions matching "~> 2.5"...
   - Installing hashicorp/aws v5.84.0...
   - Installing hashicorp/random v3.6.3...
   - Installing hashicorp/local v2.5.2...
   ```

### Part 2 — Resources from different providers

3. **Apply the config:**

   ```bash
   terraform apply -auto-approve
   ```

   Resources from different providers are created together:

   ```
   random_pet.server: Creating...
   random_pet.server: Creation complete after 0s
   local_file.config: Creating...
   local_file.config: Creation complete after 0s
   ```

   Each resource type belongs to its respective provider.

### Part 3 — Why multiple providers matter

4. **Real-world scenarios:**

   | Scenario | Providers used |
   |----------|---------------|
   | **Multi-cloud** | AWS + Azure + GCP |
   | **Cloud + DNS** | AWS + Cloudflare/DNS |
   | **Cloud + Monitoring** | AWS + Datadog/New Relic |
   | **Infra + Config** | AWS + Random + Local |
   | **Kubernetes + Cloud** | AWS + Kubernetes + Helm |

5. **Provider isolation:**

   Each provider operates independently. Resources from different providers can reference each other via attributes:

   ```hcl
   resource "random_pet" "server" {
     length = 2
   }

   resource "local_file" "config" {
     content  = "Server name: ${random_pet.server.id}"
     filename = "${path.module}/config.txt"
   }
   ```

   The `local` provider reads the `random` provider's output — Terraform handles the cross-provider dependency through the dependency graph.

### Part 4 — Multiple instances of the same provider

6. **Beyond different providers, you can also have multiple configurations of the SAME provider using `alias`:**

   ```hcl
   provider "aws" {
     alias  = "east"
     region = "us-east-1"
   }

   provider "aws" {
     alias  = "west"
     region = "us-west-2"
   }

   resource "aws_instance" "web_east" {
     provider = aws.east
     # ...
   }

   resource "aws_instance" "web_west" {
     provider = aws.west
     # ...
   }
   ```

   This is covered in depth in exercise #046 (Provider Alias).

### Put It Together

True or False? Multiple providers can be declared within a single Terraform configuration file.

- A. True
- B. False

## Files

- `main.tf` — config with multiple providers (aws, random, local)
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
