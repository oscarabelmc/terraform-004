# Data Block — Query Existing Resources Exercise

**Domain:** IaC Concepts
**Topic:** `data` block — query existing resources

## Description

Which code snippet would enable you to query information about existing resources and use that information within your Terraform configuration

## Learning Objectives

- Examine each option
- Compare against the other constructs
- Verify the data source behavior

## Background

Terraform provides several mechanisms for organizing and configuring infrastructure. Among them:

| Construct | Purpose | Example |
|-----------|---------|---------|
| **`data` block** | Query existing resources (read-only) | `data "aws_ami" "example" { ... }` |
| **`resource` block** | Create/manage infrastructure | `resource "aws_instance" "web" { ... }` |
| **`module` block** | Reuse packaged configurations | `module "vpc" { source = "./vpc" }` |
| **`locals` block** | Define computed values | `locals { name = "my-app" }` |
| **`provider` block** | Configure provider | `provider "aws" { region = "..." }` |

Only the `data` block queries existing infrastructure without creating or modifying it.

## Steps

### Part 1 — Examine each option

1. **Open `main.tf`** and examine the correct implementation:

   ```bash
   cat main.tf
   ```

   The `data` block queries AWS for the most recent AMI matching a filter, and the `resource` block uses the fetched data.

### Part 2 — Compare against the other constructs

2. **Module block** — packages resources but doesn't query existing ones:

   ```hcl
   module "data-query-servers" {
     source  = "./modules/app-cluster"
     servers = 5
   }
   ```

3. **Locals block** — defines computed values, no API queries:

   ```hcl
   locals {
     service_name = "forum"
     owner        = "Community Team"
   }
   ```

4. **Provider block** — configures the provider, doesn't query data:

   ```hcl
   provider "google" {
     project = "acme-app"
     region  = "us-central1"
   }
   ```

5. **Resource block** — creates new infrastructure, doesn't query existing:

   ```hcl
   resource "aws_instance" "web" {
     ami           = "ami-502abc4e6b1ab"
     instance_type = "m6g.xlarge"
   }
   ```

### Part 3 — Verify the data source behavior

6. **Initialize and plan:**

   ```bash
   terraform init
   terraform plan
   ```

   The data source queries the AWS API during planning and makes the AMI ID available. The resource uses the fetched value.

## Files

- `main.tf` — data block querying AMI + resource using the result
- `outputs.tf` — output values
- `solution/` — reference implementation

