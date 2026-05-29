# Provider Alias Exercise

**Domain:** IaC Workflow
**Topic:** `alias` — duplicate provider configurations

## Description

You configure two `aws` providers in the same module, as shown below, and Terraform returns `Error: Duplicate provider configuration` and says to set an additional argument for alternative configurations. Which argument must you add to the second provider block so both can be used

## Learning Objectives

- Reproduce the error
- Fix with alias
- Use aliased providers in resources

## Background

Terraform allows multiple configurations of the same provider, but each must have a unique **alias**. The first (default) provider doesn't need an alias; additional ones use the `alias` argument to differentiate them.

## Steps

### Part 1 — Reproduce the error

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   Two `provider "aws"` blocks with no aliases — this will cause the duplicate error.

2. **Initialize:**

   ```bash
   terraform init
   ```

3. **Attempt to plan:**

   ```bash
   terraform plan
   ```

   Expected error:

   ```
   │ Error: Duplicate provider configuration
   │
   │   on main.tf line 9, in provider "aws":
   │    9: provider "aws" {
   │   10:   region = "ap-south-1"
   │   11: }
   │
   │ A provider with the name "aws" was already configured at main.tf:1-5.
   │ To use multiple configurations of the same provider, set the "alias"
   │ argument for each additional configuration.
   ```

### Part 2 — Fix with alias

4. **Edit `main.tf`** — add `alias` to the second provider:

   ```hcl
   provider "aws" {
     region = "us-east-1"
   }

   provider "aws" {
     alias  = "mumbai"
     region = "ap-south-1"
   }
   ```

5. **Plan again:**

   ```bash
   terraform plan
   ```

   The error is resolved.

### Part 3 — Use aliased providers in resources

6. **Use the default provider (no alias needed):**

   ```hcl
   resource "aws_instance" "web_us" {
     ami           = "ami-0c55b159cbfafe1f0"
     instance_type = "t2.micro"
     # provider = aws  ← default, can be omitted
   }
   ```

7. **Use the aliased provider:**

   ```hcl
   resource "aws_instance" "web_mumbai" {
     provider      = aws.mumbai
     ami           = "ami-0c55b159cbfafe1f1"
     instance_type = "t2.micro"
   }
   ```

## Files

- `main.tf` — starter config with duplicate provider error
- `variables.tf` — input variables
- `outputs.tf` — output values
- `solution/` — reference implementation

