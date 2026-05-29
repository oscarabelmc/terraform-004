# Explanation

The correct answer is **B**.

> Convert the hardcoded values to input variables and provide environment-specific settings via tfvars or variable sets at plan/apply.

---

## Why B Is Correct

Making a module reusable across environments requires **parameterization** — replacing hardcoded values with variables:

```
❌ Before (hardcoded — one environment only):
   module "vm" {
     datastore     = "DS1"         # Hardcoded
     network_label = "VM Network"  # Hardcoded
     folder        = "Dev/Apps"    # Hardcoded
   }

✅ After (parameterized — any environment):
   module "vm" {
     datastore     = var.datastore      # Variable
     network_label = var.network_label  # Variable
     folder        = var.folder         # Variable
   }
```

### The parameterization pattern

| Environment | Variables file | Deployment command |
|-------------|---------------|-------------------|
| Lab | `lab.tfvars` | `terraform apply -var-file=lab.tfvars` |
| QA | `qa.tfvars` | `terraform apply -var-file=qa.tfvars` |
| Prod | `prod.tfvars` | `terraform apply -var-file=prod.tfvars` |

**Zero code changes** between environments — only variable values differ.

### Why this is the best approach

| Benefit | How it helps |
|---------|-------------|
| **DRY** | Same code, different values — no duplication |
| **Safe** | Code reviewed once, values reviewed separately |
| **Auditable** | Git shows who changed which environment's values |
| **Flexible** | Works with tfvars files, HCP variable sets, CI/CD env vars |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Copy module per environment | Violates DRY — you'd maintain N copies of the same module. A bug fix must be applied to all copies. |
| C — `TF_VAR_` env vars only | Environment variables work for **individual variables** but don't scale well for many env-specific values across multiple environments. tfvars files are more maintainable. |
| D — Separate provider configs | Provider configurations manage credentials/endpoints, not module input values. You still need variables for datastore, network, folder. |
| E — `terraform workspace` | Workspaces separate **state**, not variable values. You'd still need to set variables per workspace — workspaces don't automatically provide environment-specific values. |

## Environment-Specific Configuration Patterns

| Pattern | Best for |
|---------|----------|
| **`-var-file`** (tfvars files) | Local/CLI-driven workflows, simple env separation |
| **HCP variable sets** | HCP Terraform with multiple workspaces |
| **`TF_VAR_` environment variables** | CI/CD pipelines, simple values |
| **Directory structure** | Monorepos with separate env directories |
| **Terragrunt** | Complex multi-environment setups |
