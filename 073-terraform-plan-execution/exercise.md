# Terraform Plan Execution Exercise

**Exam Question:** You've updated a module and run `terraform plan` with default settings against the workspace's remote state. What happens when the command is executed?

## Background

`terraform plan` is the second step in the core workflow (Write → **Plan** → Apply). It performs a **read-only comparison** between the desired state (configuration) and the current state (state file) and produces an execution plan — a detailed list of what actions Terraform would take.

## Steps

### Part 1 — Examine the config

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   This config declares a VPC, subnet, and EC2 instances. The `instance_count` and `instance_type` variables control the number and size of instances.

### Part 2 — Run plan and observe

2. **Initialize and run plan:**

   ```bash
   terraform init
   terraform plan
   ```

   Output:

   ```
   Terraform used the selected providers to generate the following
   execution plan. Resource actions are indicated with the following
   symbols:
     + create

   Terraform will perform the following actions:

     # aws_vpc.main will be created
     + resource "aws_vpc" "main" {
         + cidr_block       = "10.0.0.0/16"
         ...
       }

     # aws_subnet.public will be created
     + resource "aws_subnet" "public" {
         + cidr_block       = "10.0.1.0/24"
         ...
       }

     # aws_instance.web[0] will be created
     + resource "aws_instance" "web" {
         + ami              = "ami-0c55b159cbfafe1f0"
         + instance_type    = "t2.micro"
         ...
       }

     # aws_instance.web[1] will be created
     + resource "aws_instance" "web" {
         + ami              = "ami-0c55b159cbfafe1f0"
         + instance_type    = "t2.micro"
         ...
       }

   Plan: 4 to add, 0 to change, 0 to destroy.
   ```

### Part 3 — What plan does step by step

3. **The plan process:**

   ```
   1. Read all .tf files                    (configuration parsing)
   2. Read the remote state file            (current state via backend)
   3. Read the provider schema              (validate attribute names)
   4. Compare each resource in config       (desired vs current)
      against corresponding resource in
      state
   5. Calculate diffs:
      - Resource in config, not in state → + create
      - Resource in config + state, diff  → ~ update
      - Resource in state, not in config  → - destroy
   6. Output the execution plan
   7. Save plan file (if -out flag used)
   ```

4. **What plan does NOT do:**

   - ❌ Does not create, modify, or destroy any resources
   - ❌ Does not modify state
   - ❌ Does not require confirmation (that's apply)
   - ❌ Does not guarantee the apply will succeed (resource availability, quota, permissions are checked at apply time)

### Part 4 — Plan with remote state

5. **With remote state (S3 backend in this config):**

   - Reads state from the remote backend (e.g., S3 bucket)
   - May perform a **refresh** (read real resource attributes from provider API) — this is the default behavior
   - The refresh contacts the provider APIs to update state with current real-world attributes
   - Then compares the refreshed state with the configuration

6. **Plan output symbols:**

   | Symbol | Meaning |
   |--------|---------|
   | `+` | Create |
   | `~` | Update in-place |
   | `-` | Destroy |
   | `-/+` | Replace (destroy then create) |
   | `<=` | Read (data source) |

### Put It Together

You've updated a module and run `terraform plan` with default settings against the workspace's remote state. What happens when the command is executed?

- A. Terraform immediately applies all changes to the infrastructure
- B. Terraform creates an execution plan and determines what changes are required to achieve the desired state in the configuration files
- C. Terraform destroys all existing resources and recreates them
- D. Terraform updates the state file to match the configuration without changing real infrastructure
- E. Terraform prompts for confirmation and then applies the changes

## Files

- `main.tf` — config with variables and multiple resources
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
