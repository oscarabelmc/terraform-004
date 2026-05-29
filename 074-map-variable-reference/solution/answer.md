# Explanation

The correct answer is **B**.

> `var.metadata["build-tag"]`

---

## Why B Is Correct

To access a value in a `map(string)` variable, use **bracket notation** with the key as a string:

```hcl
var.metadata["build-tag"]  # Returns "v5.0.2"
```

This works for all map keys regardless of characters:

| Key | Access expression | Result |
|-----|------------------|--------|
| `"build-tag"` | `var.metadata["build-tag"]` | `"v5.0.2"` |
| `"owner"` | `var.metadata["owner"]` | `"platform"` |
| `"service"` | `var.metadata["service"]` | `"billing"` |

### Why bracket notation is required here

The key `build-tag` contains a **hyphen** (`-`). In HCL, the dot notation (`var.metadata.build-tag`) is parsed as:

```hcl
var.metadata.build - tag  # Subtraction of undefined variables
```

This fails with an error because `build` and `tag` are not valid references.

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — `var.metadata.build-tag` | Hyphen is interpreted as subtraction: `var.metadata.build` **minus** `tag`. Results in a reference error. |
| C — `var.metadata.build_tag` | This references a key named `build_tag` (underscore), but the actual key is `build-tag` (hyphen). Case- and character-sensitive. |
| D — `var.metadata("build-tag")` | Parentheses `()` are for function calls, not map access. Maps use brackets `[]`. |
| E — `metadata.build-tag` | Missing `var.` prefix — all variables are accessed via `var.<name>`. Without `var.`, Terraform looks for a resource or data source named `metadata`, not a variable. |

## Reference Syntax Reference

| Type | Syntax | Example |
|------|--------|---------|
| **Simple variable** | `var.<name>` | `var.region` |
| **Map** | `var.<name>["key"]` | `var.metadata["build-tag"]` |
| **Map (dot, valid keys)** | `var.<name>.<key>` | `var.metadata.owner` |
| **List** | `var.<name>[index]` | `var.subnets[0]` |
| **Object** | `var.<name>.<attribute>` | `var.vpc_config.cidr` |
| **Resource attribute** | `<type>.<name>.<attr>` | `aws_vpc.main.id` |
| **Data source attribute** | `data.<type>.<name>.<attr>` | `data.aws_ami.ubuntu.id` |
| **Module output** | `module.<name>.<output>` | `module.vpc.vpc_id` |

## Variables with Hyphens in Keys

When a map has keys with special characters (hyphens, dots, spaces), you **must** use bracket notation:

```hcl
variable "config" {
  type = map(string)
  default = {
    "app-version" = "1.0.0"
    "db.host"     = "localhost"
    "env name"    = "production"
  }
}

locals {
  version = var.config["app-version"]   # ✅ Bracket notation
  host    = var.config["db.host"]       # ✅ Dot in key needs brackets
  env     = var.config["env name"]      # ✅ Space in key needs brackets
}
```

## Objective Reference

**Objective 4d** — Understand and use complex types.

`map(string)` is a collection of string key-value pairs. Access values using bracket notation: `var.<name>["<key>"]`.
