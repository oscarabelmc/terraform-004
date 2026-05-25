# Answer

The correct answer is **B**.

> Add a `lifecycle` block with `create_before_destroy = true`.

---

## Why B Is Correct

The `create_before_destroy` meta-argument inside a `lifecycle` block reverses Terraform's default replacement order:

```hcl
resource "azurerm_mssql_database" "production" {
  name      = "prod-db"
  sku_name  = "GP_Gen5_2"   # change triggers recreation
  server_id = azurerm_mssql_server.main.id

  lifecycle {
    create_before_destroy = true
  }
}
```

### What happens during apply

```
Without create_before_destroy (default):
  1. Destroy old database    ← ❌ Database goes offline
  2. Create new database     ← ✅ Back online
  3. Result: DOWNTIME

With create_before_destroy = true:
  1. Create new database     ← ✅ Old database still serving traffic
  2. Update DNS/routing      ← Application transitions to new DB
  3. Destroy old database    ← ✅ No downtime
  4. Result: ZERO DOWNTIME
```

### How Terraform executes it

```
Apply order with create_before_destroy = true:
                        ┌──────────────┐
                        │  Create new  │
                        │  resource    │
                        └──────┬───────┘
                               │ success
                               ▼
                        ┌──────────────┐
                        │  Update deps │
                        │  to point    │
                        │  to new      │
                        └──────┬───────┘
                               │
                               ▼
                        ┌──────────────┐
                        │  Destroy old │
                        │  resource    │
                        └──────────────┘
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — `depends_on` | `depends_on` controls **ordering between resources**, not the create/destroy order of a **single resource** replacement. It can't change whether a resource is created before it's destroyed. |
| C — `prevent_destroy = true` | This **blocks all destroy operations** on the resource. The database would never be recreated — the change would fail with an error. It's a safety guard, not a zero-downtime strategy. |
| D — `terraform taint` | `taint` marks a resource for destruction and recreation on the next apply, but it does **not** change the execution order. The default is still destroy-before-create. |
| E — `force_recreate = true` | **No such meta-argument exists.** There is no `force_recreate` option in Terraform. Recreation is determined by whether the provider considers the change an in-place update or a replacement. |

## When create_before_destroy Works (and When It Doesn't)

### ✅ Works when:
- The new resource can coexist with the old one (e.g., different name, different IP)
- The provider supports creating before deleting (most cloud resources do)
- The resource does not have unique naming constraints that would cause a conflict

### ❌ Fails when:
- The resource name must be globally unique and both cannot exist simultaneously
- The provider's API does not support parallel creation of the same resource type
- The `count.index` or `for_each` key produces the same name for old and new

### Example: unique name collision

```hcl
resource "aws_db_instance" "db" {
  identifier = "prod-db"   # Must be globally unique
  lifecycle {
    create_before_destroy = true   # ❌ Fails: "prod-db" already exists
  }
}
```

**Fix:** Use a name that can vary (e.g., append a timestamp or suffix).

## Comparison of Lifecycle Options

| Meta-argument | Purpose | Zero-downtime? |
|---------------|---------|:--------------:|
| `create_before_destroy = true` | Create new before destroying old | ✅ |
| `prevent_destroy = true` | Block all destroys | N/A (blocks changes) |
| `ignore_changes` | Ignore attribute drift | N/A (tolerates drift) |
| `postcondition` | Validate after create | N/A (validation only) |

## Exam Tips

- **Key phrase:** "ensure the new database is created before the old one is destroyed" → `create_before_destroy`
- This is a `lifecycle` block meta-argument, not a resource attribute or a separate command
- Default behavior is **destroy-before-create** (can cause downtime)
- `create_before_destroy` is set **per resource**, not globally
- Common exam trap: confusing `create_before_destroy` with `prevent_destroy` (opposite purposes)
- Another trap: thinking `depends_on` can change the creation/destruction order of a single resource being replaced
- If names must be globally unique, `create_before_destroy` alone won't work — you need a naming strategy too
