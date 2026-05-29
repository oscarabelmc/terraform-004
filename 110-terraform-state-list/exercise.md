# Terraform State List Exercise

**Domain:** State Management
**Topic:** `terraform state list` — list all tracked resources without attributes

## Description

Your team manages infrastructure across multiple AWS regions using Terraform. You want to see a complete list of all resources currently tracked in your Terraform state file, but don't need the detailed attributes of each resource. Which command should you use

## Learning Objectives

- Create some resources
- List all resources in state
- Compare with other state commands
- State list use cases

## Background

Terraform's `state` subcommands allow you to inspect and manipulate state. The most common state inspection commands are:

| Command | Purpose | Output detail |
|---------|---------|:------------:|
| `terraform state list` | List all resource addresses in state | **Minimal** — just addresses |
| `terraform state show <addr>` | Show full attributes of one resource | **Detailed** — all attributes |
| `terraform show` | Show full state or plan file | **Full** — entire state or plan |

## Steps

### Part 1 — Create some resources

1. **Examine the config:**

   ```bash
   cat main.tf
   ```

   The config creates resources across multiple "regions" (simulated with `random` providers).

2. **Initialize and apply:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

   Multiple resources are now tracked in state.

### Part 2 — List all resources in state

3. **Run `terraform state list`:**

   ```bash
   terraform state list
   ```

   Output:

   ```
   data.aws_availability_zones.available
   random_pet.vpc
   random_pet.subnet
   random_pet.instance
   aws_vpc.main
   aws_subnet.main
   aws_instance.web
   ```

   Each line shows one resource in the format `<type>.<name>`. No attributes — just the addresses.

4. **Run it against a specific region or module:**

   ```bash
   terraform state list -state=terraform.tfstate
   ```

   Or for resources in a module:

   ```
   module.vpc.aws_vpc.main
   module.vpc.aws_subnet.private
   module.vpc.aws_subnet.public
   ```

### Part 3 — Compare with other state commands

5. **`terraform state show` — detailed view of one resource:**

   ```bash
   terraform state show random_pet.vpc
   ```

   Output:

   ```
   # random_pet.vpc:
   resource "random_pet" "vpc" {
       id        = "vpc-jolly-koala"
       length    = 2
       prefix    = "vpc"
       separator = "-"
   }
   ```

   Shows **all attributes** of a **single** resource.

6. **`terraform show` — full state dump:**

   ```bash
   terraform show
   ```

   Outputs the **entire** state file in a human-readable format, including all resources and their complete attributes.

### Part 4 — State list use cases

7. **When to use `state list`:**

   | Scenario | Use `state list` |
   |----------|:----------------:|
   | ✅ "How many resources do we manage?" | Yes — quick count |
   | ✅ "Which resources exist in state?" | Yes — overview |
   | ✅ "Is a specific resource tracked?" | Yes — grep the output |
   | ✅ "What resources are in this module?" | Yes — shows module addresses |
   | ❌ "What are the attributes of this resource?" | No — use `state show` |
   | ❌ "What's the current public IP?" | No — use `state show` or `output` |

8. **Pipe to count resources:**

   ```bash
   terraform state list | wc -l
   ```

   Gives you the total number of resources in state.

## Files

- `main.tf` — config with multiple resources across simulated regions
- `outputs.tf` — output values
- `solution/` — reference implementation

