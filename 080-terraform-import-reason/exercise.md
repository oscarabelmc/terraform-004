# Terraform Import — Reason and Purpose Exercise

**Exam Question:** Your team has been using Terraform to manage infrastructure. A colleague manually created a database in the console for urgent troubleshooting and testing. The database is now needed permanently as part of your production environment.

What is the primary reason to use Terraform import in this situation?

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

### Put It Together

Your team has been using Terraform to manage infrastructure. A colleague manually created a database in the console for urgent troubleshooting and testing. The database is now needed permanently as part of your production environment.

What is the primary reason to use Terraform import in this situation?

- A. To destroy the existing database and recreate it with Terraform
- B. To bring the database under Terraform management so future changes can be tracked and managed through your IaC workflow
- C. To create a copy of the database for development use
- D. To modify the database's configuration to match Terraform defaults
- E. To delete the database from the cloud provider

## Files

- `main.tf` — config with import block and RDS resource
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
