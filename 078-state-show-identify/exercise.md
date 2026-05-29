# State Show — Identifying Managed Resources Exercise

**Domain:** State Management
**Topic:** Identify managed resources with `terraform state show`

## Description

Rahul deployed multiple VMs outside the Terraform workflow, and now your team is unsure which VM is managed by Terraform. What approach would best help you identify the Terraform-managed VM without making any changes to the infrastructure

## Learning Objectives

- Examine the config
- State inspection commands
- The identification workflow
- Alternative approaches and why they're worse

## Background

Terraform's state file tracks every resource it manages. When VMs are created both inside and outside Terraform, the state file is the definitive record of which resources Terraform owns. State inspection commands can identify managed resources without modifying anything.

## Steps

### Part 1 — Examine the config

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   This config defines instances with `tags.Name = "managed-vm-0"` and `managed-vm-1`. After applying, Terraform's state will track these specific VMs by their AWS instance IDs.

### Part 2 — State inspection commands

2. **List all resources in state:**

   ```bash
   terraform state list
   ```

   Output:

   ```
   aws_vpc.main
   aws_subnet.public
   aws_instance.web[0]
   aws_instance.web[1]
   ```

   This shows every resource Terraform manages, including their addresses.

3. **Show details of a specific resource:**

   ```bash
   terraform state show aws_instance.web[0]
   ```

   Output includes the **real AWS instance ID** and all attributes:

   ```
   # aws_instance.web[0]:
   resource "aws_instance" "web" {
       id              = "i-0a1b2c3d4e5f67890"
       ami             = "ami-0c55..."
       instance_type   = "t2.micro"
       subnet_id       = "subnet-123..."
       tags            = {
           "Name" = "managed-vm-0"
       }
       # ... many more attributes
   }
   ```

### Part 3 — The identification workflow

4. **Step-by-step to identify managed VMs:**

   ```
   1. List all instances in the cloud console
      ─────────────────────────────────────
      Name            | Instance ID
      managed-vm-0    | i-0a1b2c3d
      managed-vm-1    | i-0e5f6g7h
      rahul-vm-01     | i-0i9j8k7l    ← Not managed by Terraform
      rahul-vm-02     | i-0m3n4o5p    ← Not managed by Terraform

   2. Run terraform state list to see managed resources
      aws_instance.web[0]
      aws_instance.web[1]

   3. Run terraform state show for each managed instance
      terraform state show aws_instance.web[0] → id = i-0a1b2c3d
      terraform state show aws_instance.web[1] → id = i-0e5f6g7h

   4. Match IDs: VMs with IDs i-0a1b2c3d and i-0e5f6g7h are Terraform-managed
   ```

5. **This approach makes no changes:**

   - `terraform state list` — reads state only, no API calls
   - `terraform state show` — reads state only, no API calls
   - No plan, no apply, no refresh — completely safe

### Part 4 — Alternative approaches and why they're worse

6. **Comparison of identification methods:**

   | Method | Changes anything? | Works offline? | Reliability |
   |--------|------------------|----------------|-------------|
   | `terraform state show` | ❌ No | ✅ Yes | ✅ Exact match |
   | `terraform plan` | ❌ No (but slower, may refresh) | ❌ No | ✅ Good |
   | Tags in config | ❌ No (but requires planning) | ✅ Yes | ⚠️ Only if tags were set |
   | Cloud console search | ❌ No | ❌ No | ⚠️ Manual, error-prone |

## Files

- `main.tf` — config with managed EC2 instances
- `outputs.tf` — output values
- `solution/` — reference implementation

