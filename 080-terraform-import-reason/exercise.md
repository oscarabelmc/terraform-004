# Terraform Import — Reason and Purpose Exercise

**Domain:** IaC Workflow
**Topic:** Primary reason to use `terraform import`

## Description

Your team has been using Terraform to manage infrastructure. A colleague manually created a database in the console for urgent troubleshooting and testing. The database is now needed permanently as part of your production environment.

## Learning Objectives

- The problem: infrastructure outside IaC
- The solution: import into state
- The primary reason: IaC management
- What import does NOT do

## Background

Terraform import is the mechanism for bringing existing infrastructure under Terraform management. Without import, Terraform is unaware of the database — it would either try to create a duplicate (and fail) or ignore it entirely.

## Steps

### Part 1 — The problem: infrastructure outside IaC

1. **Examine the config:**

   ```bash
   cat main.tf
   ```

   The config defines an `aws_db_instance` resource and an `import` block. The `import` block tells Terraform: "This resource already exists — adopt it into state."

2. **What happens without import:**

   If you write the resource block without an import:

   ```hcl
   resource "aws_db_instance" "production" {
     identifier = "manually-created-db-instance"
     # ...
   }
   ```

   Then run `terraform apply`:

   ```
   Error: DB Instance already exists
   ```

   Terraform tries to create a new database with the same identifier, which fails because it already exists.

### Part 2 — The solution: import into state

3. **Config-driven import (Terraform 1.5+):**

   ```hcl
   import {
     to = aws_db_instance.production
     id = "manually-created-db-instance"
   }

   resource "aws_db_instance" "production" {
     identifier = "manually-created-db-instance"
     # ...
   }
   ```

   Running `terraform plan` then `terraform apply`:

   - Reads the existing database from AWS
   - Writes it into state at `aws_db_instance.production`
   - Terraform now manages the database
   - Future changes go through the IaC workflow

### Part 3 — The primary reason: IaC management

4. **Before vs after import:**

   ```
   BEFORE IMPORT:
   Database exists in AWS, but:
   ❌ Not in Terraform state
   ❌ Changes made via console/CLI (no audit trail)
   ❌ Not reproducible from code
   ❌ Unknown to other team members
   ❌ Risk of configuration drift

   AFTER IMPORT:
   Database exists in AWS, and:
   ✅ In Terraform state
   ✅ Changes via Terraform (reviewed, versioned)
   ✅ Reproducible from config
   ✅ Documented in code
   ✅ Managed through IaC workflow
   ```

5. **What import enables:**

   Once imported, the database follows the standard IaC workflow:

   ```
   Write (modify config) → Plan (preview) → Apply (execute)
                             ↓
                     Code review via PR
                             ↓
                     Approval gates
                             ↓
                     Audit trail in Git
   ```

### Part 4 — What import does NOT do

6. **Import limitations:**

   - Import does **not** create the resource — it already exists
   - Import does **not** modify the resource — attributes remain as-is
   - Import does **not** retroactively add Git history
   - Import requires the config to match the existing resource

## Files

- `main.tf` — config with import block and RDS resource
- `outputs.tf` — output values
- `solution/` — reference implementation

