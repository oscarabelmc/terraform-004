# Create Before Destroy Exercise

**Exam Question:** You have a SQL Database that's currently in production with live data. You need to change the database's pricing tier, but the change requires destroying and recreating the database. You want to ensure the new database is created before the old one is destroyed to avoid downtime. What should you add to your resource configuration?

## Background

Some resource changes require **recreation** — Terraform must destroy the old resource and create a new one. By default, Terraform **destroys first**, then creates. This causes downtime.

The `create_before_destroy` lifecycle option **reverses the order**: create the new resource first, then destroy the old one.

```
Default (destroy then create):        create_before_destroy = true:
┌──────────────────────┐               ┌──────────────────────┐
│  1. Destroy old DB   │               │  1. Create new DB    │
│     ❌ DOWNTIME      │               │     ✅ Still running │
│  2. Create new DB    │               │  2. Destroy old DB   │
│     ✅ Back online   │               │     ✅ No downtime   │
└──────────────────────┘               └──────────────────────┘
```

## Steps

### Part 1 — Understand the problem

1. **Examine the config:**

   ```bash
   cat main.tf
   ```

   The `azurerm_mssql_database` resource has `sku_name = "S2"`. Changing to a different SKU that requires recreation will cause downtime without `create_before_destroy`.

2. **Not all changes trigger recreation:**

   | Change | Behavior |
   |--------|----------|
   | SKU from `S2` to `S3` (same family) | **Update in-place** — no downtime |
   | SKU from `S2` to `GP_Gen5_2` (different family) | **Recreate** — requires `create_before_destroy` |
   | `max_size_gb` increase | **Update in-place** — no downtime |
   | `collation` change | **Recreate** — requires `create_before_destroy` |

### Part 2 — Add create_before_destroy

3. **Add a lifecycle block to the resource:**

   ```hcl
   resource "azurerm_mssql_database" "production" {
     name                = "prod-db"
     server_id           = azurerm_mssql_server.main.id
     sku_name            = "GP_Gen5_2"   # requires recreation
     max_size_gb         = 256

     lifecycle {
       create_before_destroy = true
     }
   }
   ```

4. **Plan the change:**

   ```bash
   terraform plan
   ```

   Output shows:

   ```
   # azurerm_mssql_database.production must be replaced
   -/+ resource "azurerm_mssql_database" "production" {
       ~ sku_name = "S2" -> "GP_Gen5_2"
       # ...
     }

   Plan: 1 to add, 0 to change, 1 to destroy.
   ```

   Note: `-/+` means replace (destroy and recreate). With `create_before_destroy = true`, the actual execution order is: **add first, then destroy**.

### Part 3 — Verify the execution order

5. **Apply the change:**

   ```bash
   terraform apply
   ```

   With `create_before_destroy = true`, Terraform:
   - Creates the new database with the new SKU **first**
   - Waits for it to be fully provisioned and available
   - **Then** destroys the old database
   - The application experiences zero downtime (assuming the connection string handles a brief DNS/endpoint transition)

6. **Verify state:**

   ```bash
   terraform state list
   terraform state show azurerm_mssql_database.production
   ```

### Part 4 — Important caveats

7. **create_before_destroy does NOT work in all cases:**

   | Scenario | Works? | Reason |
   |----------|:------:|--------|
   | Resources with unique name constraints | ❌ | New resource must have a different name than old |
   | Resources with `name` derived from `count.index` | ❌ | Names collide if index doesn't change |
   | Resources that can share the name (depends on provider) | ✅ | Provider must support temporary coexistence |

8. **If names must be unique, combine with `name` changes:**

   ```hcl
   resource "azurerm_mssql_database" "production" {
     name = var.environment == "production" ? "prod-db-${timestamp()}" : "prod-db"
     # ...
     lifecycle {
       create_before_destroy = true
     }
   }
   ```

   Or use `prevent_destroy` to guard against accidental deletion of critical resources.

### Part 5 — Compare lifecycle options

9. **Lifecycle meta-arguments:**

   | Option | Purpose |
   |--------|---------|
   | `create_before_destroy` | Create replacement first, then destroy old (avoid downtime) |
   | `prevent_destroy` | Block any destroy operation on the resource (safety guard) |
   | `ignore_changes` | Ignore specific attribute changes (drift tolerance) |
   | `postcondition` | Validate resource attributes after creation (exercise #079) |

### Put It Together

You have a SQL Database that's currently in production with live data. You need to change the database's pricing tier, but the change requires destroying and recreating the database. You want to ensure the new database is created before the old one is destroyed to avoid downtime. What should you add to your resource configuration?

- A. Add `depends_on` to ensure the new database is created first
- B. Add a `lifecycle` block with `create_before_destroy = true`
- C. Add `prevent_destroy = true` to the lifecycle block
- D. Use `terraform taint` to mark the resource for recreation
- E. Set `force_recreate = true` in the resource configuration

## Files

- `main.tf` — config with SQL database resource needing SKU change
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
