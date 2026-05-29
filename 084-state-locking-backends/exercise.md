# State Locking — Remote Backend Support Exercise

**Domain:** State Management
**Topic:** State locking — not all remote backends support it by default

## Description

True or False? All remote backends in Terraform support state locking by default, so you never need to worry about concurrent modifications when using any remote backend.

## Learning Objectives

- Examine an S3 backend with locking
- Backend locking support matrix
- Why locking matters
- Checking your backend's locking

## Background

State locking prevents concurrent modifications to Terraform state, which could cause corruption or lost updates. However, **not all remote backends support locking**, and those that do may require explicit configuration.

## Steps

### Part 1 — Examine an S3 backend with locking

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The S3 backend configuration includes a `dynamodb_table`:

   ```hcl
   backend "s3" {
     bucket         = "terraform-state-prod"
     key            = "locking-demo/terraform.tfstate"
     region         = "us-east-1"
     encrypt        = true
     dynamodb_table = "terraform-state-lock"   # ← Locking support
   }
   ```

   S3 itself does **not** natively support state locking. Locking is provided by a separate DynamoDB table that must be created and configured. A placeholder `random_pet` resource is included to have something for Terraform to manage.

### Part 2 — Backend locking support matrix

2. **Not all backends support locking:**

   | Backend | Locking support | Requires extra config? |
   |---------|----------------|----------------------|
   | S3 | ✅ Via DynamoDB | Yes — must create DynamoDB table |
   | AzureRM | ✅ Native | No — built-in |
   | GCS | ✅ Native | No — built-in |
   | Consul | ✅ Native | No — built-in |
   | HTTP | ❌ No | N/A |
   | Local | ❌ No | N/A |
   | Postgres | ✅ Native | No — built-in |
   | Kubernetes | ❌ No | N/A |
   | COS (IBM) | ✅ Native | No — built-in |
   | OSS (Alibaba) | ❌ No | N/A |

3. **State locking is NOT automatic for all backends:**

   ```
   ┌──────────────────────────────────────────────────────────┐
   │  "All remote backends support locking by default"        │
   │                                                          │
   │  This is FALSE because:                                  │
   │                                                          │
   │  • HTTP backend has NO locking mechanism                 │
   │  • S3 backend requires a DynamoDB table to be configured │
   │  • Without DynamoDB, S3 backend has NO locking           │
   │  • Always verify your backend's locking capabilities     │
   └──────────────────────────────────────────────────────────┘
   ```

### Part 3 — Why locking matters

4. **What happens without locking:**

   ```
   User A: terraform apply (reads state, starts making changes)
   User B: terraform apply (reads same state, starts making changes)
   User A: writes updated state
   User B: writes updated state (overwrites User A's changes!)
   
   Result: State corruption or lost updates
   ```

5. **With locking:**

   ```
   User A: terraform apply → acquires lock → makes changes → releases lock
   User B: terraform apply → waits for lock → acquires → makes changes → releases
   
   Result: Sequential, safe updates
   ```

### Part 4 — Checking your backend's locking

6. **Terraform docs specify locking for each backend:**

   ```bash
   # Check if your backend supports locking:
   # https://developer.hashicorp.com/terraform/language/settings/backends/<backend>
   ```

7. **Force-unlock if a lock is stuck:**

   ```bash
   terraform force-unlock <lock_id>
   ```

   This should only be used when you're certain no operation is actively using the lock.

## Files

- `main.tf` — S3 backend with DynamoDB locking and placeholder resources
- `outputs.tf` — output values
- `solution/` — reference implementation

