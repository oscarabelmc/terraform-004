# Explanation

The correct answer is **B — `TF_VAR_`**.

## Format

```
TF_VAR_<variable_name>=<value>
```

Terraform scans all environment variables and looks for any with the `TF_VAR_` prefix. The suffix after the prefix is mapped to the input variable name.

Examples:

| Environment Variable | Input Variable |
|---------------------|----------------|
| `TF_VAR_region=us-east-1` | `variable "region"` |
| `TF_VAR_instance_count=3` | `variable "instance_count"` |
| `TF_VAR_enable_monitoring=true` | `variable "enable_monitoring"` |
| `TF_VAR_tags='{"env":"dev"}'` | `variable "tags"` |

## Variable Precedence (lowest → highest)

Terraform resolves variable values in this order:

| Precedence | Source | Example |
|-----------|--------|---------|
| 1 (lowest) | Default value | `variable "x" { default = "a" }` |
| 2 | `TF_VAR_` environment variables | `export TF_VAR_x=a` |
| 3 | `terraform.tfvars` | File in the root module |
| 4 | `*.auto.tfvars` (alphabetical) | `prod.auto.tfvars` |
| 5 | `-var` or `-var-file` CLI flags | `terraform plan -var x=a` |

**Higher precedence overrides lower precedence.**

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — `TERRAFORM_` | No such prefix exists in Terraform. |
| C — `TF_INPUT_` | No such prefix exists. |
| D — `VAR_` | No such prefix exists. |
| E — No prefix | Terraform does **not** scan all env vars — only those with `TF_VAR_`. Without the prefix, the variable is ignored. |

## Handling Complex Types via Env Vars

- **string / number / bool** — straightforward values
- **list** — `TF_VAR_list='["a","b","c"]'`
- **map / object** — `TF_VAR_tags='{"env":"dev","team":"infra"}'`
- Use HCL syntax inside the string (Terraform parses the value)
