# Default State Location Exercise

**Domain:** State Management
**Topic:** Default state location without backend block

## Description

You have created a brand-new Terraform repo that has no backend block. After successfully running your first `terraform apply`, where does Terraform store state by default

## Learning Objectives

- Examine a config with no backend
- Apply and observe the state file
- Inspect local state
- Local backend characteristics

## Background

When no `backend` block is specified in the `terraform` block, Terraform uses the **local backend** by default. The state file is stored as `terraform.tfstate` in the current working directory.

## Steps

### Part 1 — Examine a config with no backend

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   Notice there is **no** `backend` block inside the `terraform` block. This means Terraform will use the default **local backend**.

### Part 2 — Apply and observe the state file

2. **Initialize and apply:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

3. **Check for the state file:**

   ```bash
   ls -la terraform.tfstate
   ```

   ```
   -rw-r--r-- 1 user user 2048 May 25 10:00 terraform.tfstate
   ```

   The file was created in the **current working directory**.

### Part 3 — Inspect local state

4. **Read the state file:**

   ```bash
   cat terraform.tfstate | head -20
   ```

   ```json
   {
     "version": 4,
     "terraform_version": "1.5.0",
     "serial": 1,
     "lineage": "abc-...",
     "outputs": {},
     "resources": [
       {
         "module": "root",
         "mode": "managed",
         "type": "random_pet",
         "name": "name",
         "provider": "provider[\"registry.terraform.io/hashicorp/random\"]",
         "instances": [
           {
             "schema_version": 0,
             "attributes": {
               "id": "marsupial-gerbil-jackal"
             }
           }
         ]
       }
     ]
   }
   ```

5. **Backup file:**

   ```bash
   ls -la terraform.tfstate.backup
   ```

   Terraform also creates a `terraform.tfstate.backup` file containing the previous state version.

### Part 4 — Local backend characteristics

6. **Local backend features:**

   | Feature | Local backend |
   |---------|---------------|
   | **Storage location** | Current working directory |
   | **File name** | `terraform.tfstate` |
   | **Encryption** | None (plain text JSON) |
   | **Locking** | ❌ No (file lock only on some OS) |
   | **Sharing** | ❌ No — single user only |
   | **Versioning** | Via `.backup` file |
   | **Suitable for** | Learning, testing, single-user |

## Files

- `main.tf` — config with no backend block (uses local backend by default)
- `outputs.tf` — output values
- `solution/` — reference implementation

