# Explanation

The correct answer is **A**.

> Declare `variable "env" {}` in the child module and pass it from root using `env = var.env`.

---

## Why A Is Correct

Child modules are **isolated** from the root module. They cannot read root variables automatically. To pass a value:

### Step 1 — Declare the variable in the child module

```hcl
# modules/web/variables.tf
variable "env" {
  type        = string
  description = "Environment name for resource naming"
}
```

### Step 2 — Pass the value from the root module

```hcl
# main.tf (root)
module "web" {
  source = "./modules/web"
  env    = var.env    # root variable → module argument
}
```

### Step 3 — Use it in the child module

```hcl
# modules/web/main.tf
resource "random_pet" "web" {
  prefix = var.env
  length = 2
}
```

### The flow

```
Root:  var.env = "production"
         │
         │  env = var.env  (module argument)
         ▼
Child: var.env = "production"
         │
         │  prefix = var.env
         ▼
       Resource name: "production-app"
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — Automatic inheritance | Child modules do **not** automatically inherit root variables. Each variable must be explicitly declared in the child and passed from the parent. This is a deliberate design choice for encapsulation. |
| C — `terraform output` to read env | `terraform output` reads **outputs** from state, not variables. It's also a runtime command, not a config reference. You cannot use it to pass values into a module. |
| D — `terraform.tfvars` in child module | A `terraform.tfvars` file in the child module sets values for the child's variables, but those values are **hardcoded** — they don't come from the root's `var.env`. This wouldn't use the root variable at all. |
| E — `data.terraform_remote_state` | This reads outputs from a **different workspace's state** — it's for cross-workspace data sharing, not for passing variables between modules in the same configuration. |

## Module Variable Isolation Design

Terraform intentionally isolates child module variables for **encapsulation**:

```
✅ Benefits of isolation:
   - Modules are self-contained and reusable
   - A module's variable interface is explicit (documented in variables.tf)
   - No hidden dependencies on parent scope
   - Modules can be tested independently

❌ What would break without isolation:
   - Module behavior would depend on the calling context
   - Reusing a module in a different root would be unpredictable
   - Hard to know what variables a module needs without reading its code
```

## Complete Variable Flow

```
User input methods
├── -var="env=production"       (CLI flag)
├── TF_VAR_env=production       (env var)
├── terraform.tfvars            (auto-loaded)
├── *.auto.tfvars               (auto-loaded)
└── -var-file="custom.tfvars"  (explicit file)
        │
        ▼
Root variable: var.env
        │
        │  env = var.env
        ▼
Child module argument
        │
        ▼
Child variable: var.env
        │
        │  prefix = var.env
        ▼
Resource attribute: "production-app"
```
