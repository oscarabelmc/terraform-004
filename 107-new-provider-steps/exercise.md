# New Provider — Required Steps Exercise

**Exam Question:** Before a new Terraform provider can be used in a configuration, what steps are required? (Select two.)

## Background

Using a new provider in Terraform requires exactly two steps:

```
Step 1: Declare & configure in config  →  tells Terraform WHAT to use
Step 2: terraform init                  →  downloads the provider plugin
```

Neither step alone is sufficient. You must **declare** the provider so Terraform knows about it, and **initialize** so Terraform downloads the plugin binary.

## Steps

### Part 1 — Step 1: Declare and configure the provider

1. **Examine the starter config:**

   ```bash
   cat main.tf
   ```

   The config has no provider declarations yet.

2. **Add the provider declaration:**

   You need two elements:

   ```hcl
   terraform {
     required_providers {
       <name> = {
         source  = "<namespace>/<type>"
         version = "<constraint>"
       }
     }
   }

   provider "<name>" {
     # Configuration arguments (region, credentials, etc.)
   }
   ```

   Example for AWS:

   ```hcl
   terraform {
     required_providers {
       aws = {
         source  = "hashicorp/aws"
         version = "~> 5.0"
       }
     }
   }

   provider "aws" {
     region = "us-east-1"
   }
   ```

   - `required_providers` — tells Terraform which provider plugin to download
   - `provider` block — configures the provider instance with API-specific settings

### Part 2 — Step 2: Initialize the working directory

3. **Run `terraform init`:**

   ```bash
   terraform init
   ```

   Output:

   ```
   Initializing provider plugins...
   - Finding hashicorp/aws versions matching "~> 5.0"...
   - Installing hashicorp/aws v5.84.0...
   - Installed hashicorp/aws v5.84.0 (signed by HashiCorp)

   Terraform has been successfully initialized!
   ```

   `terraform init`:
   - Reads `required_providers` from config
   - Downloads the provider plugin binary from the registry
   - Stores it in `.terraform/providers/`
   - Creates/updates `.terraform.lock.hcl`

4. **Without `init`, plan fails:**

   ```bash
   terraform plan
   ```

   ```
   ╷
   │ Error: Could not load plugin
   │
   │ Plugin reinitialization required. Please run "terraform init".
   ```

### Part 3 — Verify the provider is ready

5. **After init, use the provider:**

   ```bash
   terraform plan
   ```

   The plan runs successfully — Terraform can now communicate with the AWS API through the provider plugin.

6. **Check what was downloaded:**

   ```bash
   ls .terraform/providers/registry.terraform.io/hashicorp/aws/
   ```

   The provider plugin binary is available for use.

### Part 4 — What does NOT need to happen

7. **Common misconceptions:**

   | Step | Required? | Why |
   |------|:---------:|-----|
   | Declare in `required_providers` | ✅ | Tells Terraform what to download |
   | Configure a `provider` block | ✅ | Provides API credentials and settings |
   | Run `terraform init` | ✅ | Downloads the plugin |
   | Run `terraform plan` | ❌ | Only validates config, doesn't install providers |
   | Run `terraform apply` | ❌ | Would fail without init |
   | Install manually via package manager | ❌ | Terraform manages its own plugins |
   | Restart the terminal | ❌ | No effect |

### Put It Together

Before a new Terraform provider can be used in a configuration, what steps are required? (Select two.)

- A. Initialize the working directory using `terraform init` to download and install the provider
- B. Declare and configure the provider in the configuration with the required arguments
- C. Run `terraform plan` to validate the provider configuration
- D. Restart the terminal session to load the new provider
- E. Manually download the provider binary from the Terraform registry

## Files

- `main.tf` — config template for adding a new provider
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
