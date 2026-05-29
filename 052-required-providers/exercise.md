# Required Providers Exercise

**Domain:** IaC Workflow
**Topic:** `required_providers` block

## Description

How do you specify which provider Terraform should install for a configuration

## Learning Objectives

- Examine the required_providers block
- The matching provider block
- Understand how they work together
- Multiple providers
- Run terraform init

## Background

Terraform uses a two-part mechanism to specify providers:

1. **`required_providers` block** — declares which providers and versions Terraform must download
2. **`provider` block** — configures the provider instance (region, credentials, alias, etc.)

## Steps

### Part 1 — Examine the required_providers block

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The `terraform` block contains `required_providers`:

   ```hcl
   terraform {
     required_providers {
       aws = {
         source  = "hashicorp/aws"
         version = "~> 5.0"
       }
     }
   }
   ```

   This tells Terraform: "Download the `aws` provider from the `hashicorp` namespace, version 5.x."

### Part 2 — The matching provider block

2. **Examine the provider configuration:**

   ```hcl
   provider "aws" {
     region = "us-east-1"
   }
   ```

   The `provider` block configures the downloaded provider. The name (`aws`) must match the key in `required_providers`.

### Part 3 — Understand how they work together

3. **The relationship:**

   ```
   required_providers block          provider block
   ┌──────────────────────┐          ┌─────────────────┐
   │  aws = {             │  tells   │  provider "aws"  │
   │    source  = "..."   │ ──────→  │    region = ".." │
   │    version = "..."   │          │  }               │
   │  }                   │          └─────────────────┘
   └──────────────────────┘                 │
          │                                 │
          ▼                                 ▼
   terraform init                terraform plan/apply
   Downloads provider plugin     Uses configured provider
   ```

   - `required_providers` → **installation** (what to download)
   - `provider` → **configuration** (how to use it)

### Part 4 — Multiple providers

4. **Multiple providers in the same config:**

   ```hcl
   terraform {
     required_providers {
       aws = {
         source  = "hashicorp/aws"
         version = "~> 5.0"
       }
       azurerm = {
         source  = "hashicorp/azurerm"
         version = "~> 3.0"
       }
     }
   }

   provider "aws" {
     region = "us-east-1"
   }

   provider "azurerm" {
     features {}
   }
   ```

### Part 5 — Run terraform init

5. **Initialize and observe provider download:**

   ```bash
   terraform init
   ```

   Output shows:

   ```
   Initializing provider plugins...
   - Finding hashicorp/aws versions matching "~> 5.0"...
   - Installing hashicorp/aws v5.84.0...
   ```

   The providers specified in `required_providers` are downloaded.

## Files

- `main.tf` — terraform block with required_providers + provider configuration
- `outputs.tf` — output values
- `solution/` — reference implementation

