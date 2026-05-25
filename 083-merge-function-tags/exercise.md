# Merge Function — Tag Composition Exercise

**Exam Question:** Your team maintains a map of common tags to apply to all resources. Each individual resource also needs its own specific tags. To accomplish this, you have `var.common_tags` containing shared tags and `local.resource_tags` containing resource-specific tags. How do you combine both to apply to a resource?

## Background

Terraform's `merge()` function takes one or more maps and returns a single map containing all key-value pairs. When the same key exists in multiple maps, the **last value wins** (rightmost map takes precedence).

## Steps

### Part 1 — Examine the merge pattern

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   Three different merge patterns:

   ```hcl
   # Pattern 1: common + inline map
   tags = merge(var.common_tags, { Name = "billing-vpc" })

   # Pattern 2: common + local map
   tags = merge(var.common_tags, local.resource_tags)

   # Pattern 3: common + inline with multiple overrides
   tags = merge(var.common_tags, {
     Name      = "billing-logs"
     Retention = "90days"
   })
   ```

### Part 2 — How merge works

2. **The merge logic:**

   ```hcl
   var.common_tags = {
     Environment = "production"
     ManagedBy   = "Terraform"
     Owner       = "platform-team"
     Project     = "billing"
   }

   local.resource_tags = {
     Name    = "billing-api"
     Service = "api-gateway"
     Backup  = "daily"
   }

   # merge combines both:
   merge(var.common_tags, local.resource_tags)

   # Result:
   {
     Environment = "production"    # from common
     ManagedBy   = "Terraform"     # from common
     Owner       = "platform-team" # from common
     Project     = "billing"       # from common
     Name        = "billing-api"   # from resource (overrides if in common too)
     Service     = "api-gateway"   # from resource
     Backup      = "daily"         # from resource
   }
   ```

### Part 3 — Last-value-wins behavior

3. **When keys overlap, the rightmost map wins:**

   ```hcl
   merge(
     { Name = "common-name", Env = "prod" },
     { Name = "specific-name" }
   )
   # Result: { Name = "specific-name", Env = "prod" }
   ```

   This allows resource-specific tags to **override** common tags when needed.

### Part 4 — Alternative approaches (worse)

4. **Manual tag duplication (don't do this):**

   ```hcl
   tags = {
     Environment = "production"
     ManagedBy   = "Terraform"
     Name        = "my-resource"
   }
   ```

   ❌ Duplicates common tags everywhere — violates DRY principle.

5. **Separate tag variables (not ideal):**

   ```hcl
   tags = concat(var.common_tags, local.resource_tags)  # ❌ concat works on lists, not maps
   ```

   ❌ `concat()` works on lists, not maps. Only `merge()` works for maps.

### Put It Together

Your team maintains a map of common tags to apply to all resources. Each individual resource also needs its own specific tags. To accomplish this, you have `var.common_tags` containing shared tags and `local.resource_tags` containing resource-specific tags. How do you combine both to apply to a resource?

- A. `concat(var.common_tags, local.resource_tags)`
- B. `merge(var.common_tags, local.resource_tags)`
- C. `zipmap(var.common_tags, local.resource_tags)`
- D. `var.common_tags + local.resource_tags`
- E. `element(var.common_tags, local.resource_tags)`

## Files

- `main.tf` — config demonstrating merge() with tags
- `outputs.tf` — outputs showing merged tag results
- `solution/answer.md` — explanation and exam tips
