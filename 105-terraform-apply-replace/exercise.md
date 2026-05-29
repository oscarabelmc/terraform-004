# Terraform Apply -replace Exercise

**Domain:** IaC Workflow
**Topic:** `terraform apply -replace` — force resource recreation without config changes

## Description

Which Terraform command will force a resource to be destroyed and recreated even if there are no configuration changes that would require it

## Learning Objectives

- Understand the scenario
- Force replacement with `-replace`
- Compare: `-replace` vs other approaches
- How `-replace` works

## Background

Sometimes a resource becomes **degraded or stuck** — it's in a bad state but Terraform sees no config changes needed. Before Terraform v1.1, you'd use `terraform taint` to mark it for replacement. The modern approach is `terraform apply -replace=<resource_address>`.

```
Legacy (Terraform <1.1):       Modern (Terraform 1.1+):
terraform taint <address>       terraform apply -replace=<address>
terraform apply                 (single command, no taint state)
```

## Steps

### Part 1 — Understand the scenario

1. **Examine the config:**

   ```bash
   cat main.tf
   ```

   A `random_pet` resource with fixed configuration. It's healthy and matches state — no changes needed.

2. **Simulate a degraded resource:**

   In production, this might be:
   - An EC2 instance with a failing application
   - A database with corrupted indexes
   - A load balancer with stuck health checks

   The config is correct, but the resource needs to be **rebuilt fresh**.

### Part 2 — Force replacement with `-replace`

3. **Force replacement without config changes:**

   ```bash
   terraform apply -replace="random_pet.database"
   ```

   Output:

   ```
   # random_pet.database will be replaced, as requested
   -/+ resource "random_pet" "database" {
         id       = "original-pet-name" -> (known after apply)
         length   = 2
         prefix   = "db"
         separator = "-"
       }

   Plan: 1 to add, 0 to change, 1 to destroy.

   Do you want to perform these actions?
     Terraform will perform the actions described above.
     Only 'yes' will be accepted to approve.

     Enter a value: yes
   ```

   Terraform:
   - Creates a **new** random_pet with a new ID
   - Destroys the **old** random_pet
   - Updates state to point to the new resource

4. **Verify the replacement:**

   ```bash
   terraform state show random_pet.database
   ```

   The ID has changed — the resource was fully recreated.

### Part 3 — Compare: `-replace` vs other approaches

5. **Replace multiple resources at once:**

   ```bash
   terraform apply -replace="aws_instance.web" -replace="aws_db_instance.main"
   ```

6. **Comparison table:**

   | Approach | Command | State change? | Requires `apply`? | Modern? |
   |----------|---------|:-------------:|:-----------------:|:-------:|
   | `-replace` | `terraform apply -replace=<addr>` | No taint marker | ✅ Yes (single step) | ✅ |
   | `terraform taint` (legacy) | `terraform taint <addr>` | ✅ Marks tainted | ✅ Yes (separate step) | ❌ |
   | Config change | Edit `.tf` file | Depends | ✅ Yes | ✅ |
   | Manual destroy | `terraform destroy -target=<addr>` + apply | ✅ Removes from state | ✅ Yes (two steps) | ❌ Risky |

### Part 4 — How `-replace` works

7. **The execution flow:**

   ```
   terraform apply -replace=aws_instance.web
        │
        ├── 1. Reads current config and state
        ├── 2. Forces the targeted resource into the plan as "replace"
        │      even if config matches state
        ├── 3. Generates plan: "1 to add, 1 to destroy"
        ├── 4. Waits for approval (unless -auto-approve)
        └── 5. Executes: creates new, then destroys old
   ```

   The `-replace` flag **overrides** Terraform's normal plan logic, forcing the resource to appear as `-/+` (replace) in the plan.

## Files

- `main.tf` — config with a resource to force-replace
- `outputs.tf` — output values
- `solution/` — reference implementation

