# Answer

The two correct answers are: **A and B**.

> **A** — Initialize the working directory using `terraform init` to download and install the provider.
>
> **B** — Declare and configure the provider in the configuration with the required arguments.

---

## Why A and B Are Correct

### A — `terraform init` downloads the provider

Running `terraform init` is the step that actually downloads the provider plugin binary from the registry and installs it locally:

```
terraform init
    │
    ├── Reads required_providers from config
    ├── Downloads hashicorp/aws v5.84.0 from registry
    ├── Stores in .terraform/providers/
    └── Creates/updates .terraform.lock.hcl
```

Without `init`, Terraform has no plugin binary to communicate with the target API.

### B — Declare and configure in config

You must add two things to your configuration:

```hcl
# 1. required_providers — tells Terraform WHAT to download
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 2. provider block — configures HOW to use it
provider "aws" {
  region = "us-east-1"
}
```

Without these declarations, Terraform doesn't know which provider plugin to download or how to configure it.

### The complete flow

```
┌─────────────────────────────────────────────────────┐
│                 Using a new provider                  │
├─────────────────────────────────────────────────────┤
│                                                       │
│  Step 1 (Config):                                     │
│    required_providers { aws = { ... } }               │
│    provider "aws" { region = "..." }                  │
│                                                       │
│  Step 2 (CLI):                                        │
│    terraform init                                     │
│      → Downloads provider plugin                      │
│      → Creates .terraform.lock.hcl                    │
│                                                       │
│  Then:                                                │
│    terraform plan  →  validates config                │
│    terraform apply →  creates resources               │
│                                                       │
└─────────────────────────────────────────────────────┘
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| C — Run `terraform plan` | `plan` validates the configuration but **does not** download or install providers. It will fail with "Plugin reinitialization required" if `init` hasn't been run. |
| D — Restart the terminal | Terminal state has **no effect** on Terraform provider availability. Providers are files on disk, not environment variables. |
| E — Manually download the provider binary | You **could** manually download a provider, but it's neither required nor recommended. `terraform init` handles this automatically from the registry. |

## Common Misconceptions

| Misconception | Truth |
|--------------|-------|
| "I need to run `plan` first" | No — `init` comes first. `plan` validates config but doesn't install providers. |
| "I can install providers via apt/brew" | Not recommended. Terraform manages its own plugins in `.terraform/providers/`. |
| "The `required_providers` block alone is enough" | No — you also need a `provider` block to configure it (or the provider must have no required config). |
| "A `provider` block alone is enough" | No — without `required_providers`, Terraform uses a default source lookup, which may fail for non-HashiCorp providers. |
| "`terraform init` only needs to run once ever" | No — you must re-run `init` whenever you add a new provider or change version constraints. |

## Exam Tips

- **Two steps:** declare (config) + initialize (CLI)
- `terraform init` is the **only** command that downloads provider plugins
- `required_providers` + `provider` block = the declaration step
- Common exam trap: thinking `terraform plan` can substitute for `init`
- Another trap: thinking providers are installed globally via package managers
- Key phrase: **"before a new Terraform provider can be used"** → the question is about the setup steps, not ongoing usage
- The `provider` block must be in the **root module** (for the default provider) or passed explicitly to child modules
