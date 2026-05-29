# Explanation

The correct syntax is **B — `module.database.connection_string`**.

```hcl
module "webapp" {
  source            = "./modules/webapp"
  db_connection_str = module.database.connection_string
}
```

## Why

Module outputs are always accessed using the `module.<NAME>.<OUTPUT_NAME>` syntax:

```
module.<module_label>.<output_name>
```

| Part | Meaning | Example |
|------|---------|---------|
| `module` | Keyword indicating a module reference | Always `module` |
| `database` | The label of the module block | The name you gave the `module "database"` block |
| `connection_string` | The name of the `output` block inside the module | Defined in `outputs.tf` |

## How Module Outputs Work

```
┌──────────────┐     output "connection_string"     ┌──────────────┐
│              │  ──────────────────────────────>    │              │
│  database    │    module.database.connection_str   │   webapp     │
│  module      │  <──────────────────────────────    │   module     │
│              │     var.db_connection_str           │              │
└──────────────┘                                     └──────────────┘
```

1. The **database module** declares `output "connection_string" { value = ... }`
2. The **root module** reads it via `module.database.connection_string`
3. The root module passes it to webapp as an argument: `db_connection_str = module.database.connection_string`
4. The **webapp module** receives it as `var.db_connection_str`

## Why the Others Are Wrong

| Option | Syntax | Why it's incorrect |
|--------|--------|-------------------|
| A | `output.database.connection_string` | `output` is not a valid prefix. There is no `output.*` namespace in Terraform — module outputs live under `module.*`. |
| B | **`module.database.connection_string`** | **Correct.** |
| C | `var.database.connection_string` | `var.*` references **input variables** of the current module, not outputs from other modules. The root module has no variable named `database`. |
| D | Output inside database pointing to webapp | An output block declares what a module **exposes**, not what it consumes. The webapp module needs an input variable (`variable` block), not an output pointing to it. |

## Access Patterns Summary

| Reference | Accesses | Syntax |
|-----------|----------|--------|
| Module output | Output from a called module | `module.<NAME>.<OUTPUT>` |
| Input variable | Current module's variables | `var.<NAME>` |
| Resource attribute | Resource attribute | `<RESOURCE_TYPE>.<NAME>.<ATTRIBUTE>` |
| Data source | Data source attribute | `data.<DATA_TYPE>.<NAME>.<ATTRIBUTE>` |
| Local value | Current module's locals | `local.<NAME>` |
| Provider | Provider configuration | `provider.<PROVIDER>` |
