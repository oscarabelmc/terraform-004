# Provider Plugin Storage Location Exercise

**Domain:** IaC Workflow
**Topic:** Provider plugin storage location after `init`

## Description

You run `terraform init` in a new working directory. The output shows Terraform downloading the `aws` and `time` provider plugins. On this machine, where does Terraform store those provider plugins

## Learning Objectives

- Examine the provider configuration
- Run terraform init
- Find the downloaded plugins
- Understand the directory structure
- Check the global plugin cache (if configured)

## Background

When you run `terraform init`, Terraform downloads provider plugins and stores them in a specific directory structure. Understanding where providers are stored helps with troubleshooting, disk space management, and CI/CD caching.

## Steps

### Part 1 — Examine the provider configuration

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   Two providers are declared: `aws` and `time`.

### Part 2 — Run terraform init

2. **Initialize the directory:**

   ```bash
   terraform init
   ```

   Output:

   ```
   Initializing provider plugins...
   - Finding hashicorp/aws versions matching "~> 5.0"...
   - Finding hashicorp/time versions matching "~> 0.9"...
   - Installing hashicorp/aws v5.84.0...
   - Installing hashicorp/time v0.9.1...
   Terraform has been successfully initialized!
   ```

### Part 3 — Find the downloaded plugins

3. **Explore the `.terraform/providers` directory:**

   ```bash
   ls -R .terraform/providers/
   ```

   ```
   .terraform/providers/
   └── registry.terraform.io/
       └── hashicorp/
           ├── aws/
           │   └── 5.84.0/
           │       └── linux_amd64/
           │           └── terraform-provider-aws_v5.84.0_x5
           └── time/
               └── 0.9.1/
                   └── linux_amd64/
                       └── terraform-provider-time_v0.9.1_x5
   ```

   The path pattern is:

   ```
   .terraform/providers/<registry>/<namespace>/<type>/<version>/<os_arch>/<binary>
   .terraform/providers/registry.terraform.io/hashicorp/aws/5.84.0/linux_amd64/terraform-provider-aws
   ```

### Part 4 — Understand the directory structure

4. **Break down the path:**

   | Path Component | Example | Meaning |
   |----------------|---------|---------|
   | `.terraform/providers/` | | Root provider directory |
   | `<registry>/` | `registry.terraform.io/` | Provider registry source |
   | `<namespace>/` | `hashicorp/` | Provider publisher |
   | `<type>/` | `aws/` | Provider name |
   | `<version>/` | `5.84.0/` | Exact version downloaded |
   | `<os_arch>/` | `linux_amd64/` | Platform-specific binary |
   | `<binary>` | `terraform-provider-aws_v5.84.0_x5` | Executable plugin binary |

### Part 5 — Check the global plugin cache (if configured)

5. **Check if a global cache is being used:**

   ```bash
   ls ~/.terraform.d/plugins/ 2>/dev/null || echo "No global plugin cache"
   ```

   By default, Terraform stores plugins **per-working-directory** in `.terraform/providers/`. However, you can configure a **global plugin cache** by setting the `plugin_cache_dir` in `.terraformrc` or `~/.terraformrc`:

   ```hcl
   # ~/.terraformrc
   plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
   ```

   When a global cache is configured, Terraform still creates the `.terraform/providers/` structure but uses **hard links** to the cached files instead of downloading them again.

## Files

- `main.tf` — config with aws and time providers
- `outputs.tf` — output values
- `solution/` — reference implementation

