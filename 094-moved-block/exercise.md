# Moved Block — State Refactoring Exercise

**Exam Question:** True or False? After successfully applying a `moved` block to refactor your resources, you should immediately remove the `moved` block from your configuration to keep your code clean.

## Background

The `moved` block (Terraform 1.1+) allows you to rename or restructure resources in configuration without destroying and recreating them. It tells Terraform: "This resource now has a new address — update the state to match."

However, removing a `moved` block too soon causes Terraform to interpret the old address as a missing resource (destroy) and the new address as a new resource (create).

## Steps

### Part 1 — Examine the moved block

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The resource was renamed from `aws_instance.web_server` to `aws_instance.application`:

   ```hcl
   moved {
     from = aws_instance.web_server
     to   = aws_instance.application
   }
   ```

   This tells Terraform: "The resource that was previously at `aws_instance.web_server` is now at `aws_instance.application`."

### Part 2 — How moved blocks work

2. **The moved block lifecycle:**

   ```
   Apply 1: moved block present
   → Terraform updates state from old address to new address
   → Resource is NOT destroyed/recreated — state reference changes only

   Apply 2: moved block still present
   → Terraform sees the moved block again
   → Checks state: old address no longer exists (already moved)
   → No action needed — safe no-op

   Remove moved block: after team has synced
   → Terraform sees only the new address in config
   → State already has the new address
   → Clean configuration
   ```

### Part 3 — What happens if you remove the moved block too soon

3. **Scenario: Remove moved block immediately after apply:**

   ```
   Before apply:
   - Config has: moved { from = aws_instance.web_server to = aws_instance.application }
   - State has:  aws_instance.web_server (old name)
   - Plan:       moved action (update state only, no infrastructure change)

   After apply:
   - State has:  aws_instance.application (new name)
   
   ❌ Remove moved block immediately:
   - Config has: aws_instance.application only
   - Terraform process:
     1. Sees aws_instance.application in config
     2. Sees aws_instance.application in state → match, no changes
     ✅ Actually this works IF the mover's state is the only one...
     
   BUT: if another team member hasn't applied yet:
   - Their state still has aws_instance.web_server
   - They run plan without the moved block
   - Terraform sees: aws_instance.application (create) + aws_instance.web_server (destroy)
   - Result: unwanted destruction and recreation!
   ```

### Part 4 — Best practices for moved blocks

4. **Timeline for removing a moved block:**

   ```
   Week 1:  Add moved block, commit, apply
   Week 2:  All team members pull and apply (state now has new address)
   Week 3:  Remove moved block in a separate commit, apply
   ```

5. **When to keep the moved block:**

   - **Until all team members** have run `terraform apply` (or `terraform plan` with refresh)
   - **Until CI/CD pipelines** have completed at least one run
   - **Until you're confident** no state still references the old address

### Put It Together

True or False? After successfully applying a `moved` block to refactor your resources, you should immediately remove the `moved` block from your configuration to keep your code clean.

- A. True
- B. False

## Files

- `main.tf` — config with moved block for resource rename
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
