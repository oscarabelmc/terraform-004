# Answer

The correct answer is **B — They are module-specific inputs that are passed into the child module used for resource creation.**

## Why

In a Terraform module:

- The **child module** declares what values it expects via `variable` blocks in its `variables.tf`
- The **calling module** (root) passes values to the child using `name = expression` syntax inside the `module` block
- These passed values are called **arguments** or **module input variables**
- Inside the child module, they are accessed as `var.name`, `var.cidr`, `var.azs`

This is the **module's public interface** — it defines what configuration the caller must provide.

## Key Concepts

| Term | Meaning |
|------|---------|
| **Module input variable** | A variable declared in the child module's `variables.tf` that the caller can set |
| **Argument** | The `name = value` expression in the `module` block that passes a value |
| **`var.*` reference** | How the child module accesses the input values internally |
| **Purpose** | Makes modules **parameterizable** and **reusable** — same module, different inputs |

## The Flow of Data

```
Calling module (root)           Child module
──────────────────────          ─────────────
main.tf:                        variables.tf:
  name = var.network_name  ──>    variable "name" { ... }
  cidr = var.network_cidr  ──>    variable "cidr" { ... }
  azs  = var.network_azs   ──>    variable "azs" { ... }

                                main.tf:
                                  var.name  → used in resource
                                  var.cidr  → used in resource
                                  var.azs   → used in resource
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Output values | Outputs use `output {}` blocks and are consumed via `module.x.output_name`. `name`, `cidr`, `azs` are being **passed in**, not **returned**. |
| C — Built-in functions | Terraform functions include `cidrsubnet()`, `join()`, etc. `name`/`cidr`/`azs` are user-defined variable names, not functions. |
| D — Hardcoded defaults | The module may have defaults, but the purpose of an argument is to **override** them. The question code passes root variables — these are not hardcoded. |
| E — Automatically assigned attributes | Terraform does not auto-assign arguments. Every value in a `module` block must be explicitly passed or use a default. |

## Exam Tips

- Module arguments = **inputs** (what you **pass** to the module)
- Module outputs = **outputs** (what you **get back** from the module)
- The code `name = var.vpc_name` means: "set the module's `name` input to the value of `var.vpc_name`"
- Inside the child module, you always reference inputs as `var.*` (e.g., `var.name`)
- If a module variable has no `default` and no caller value is provided, Terraform will prompt for it
