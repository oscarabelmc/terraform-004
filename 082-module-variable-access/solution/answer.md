# Answer

The correct answer is **B**.

> Only values passed to it via the module block since root variables are not automatically accessible inside the module.

---

## Why B Is Correct

Child modules in Terraform are **self-contained** — they only have access to:

1. Variables they explicitly declare in their own `variable` blocks
2. Values passed to them via the module block arguments

Root module variables (including those from `terraform.tfvars`) are **not inherited** by child modules.

### The isolation model

```
Root Module                          Child Module
┌─────────────────────┐             ┌────────────────────────┐
│ variables:           │             │ variables:              │
│   region             │────X────    │   (none automatically)  │
│   environment        │────X────    │                         │
│   instance_type      │────X────    │   instance_type ← ONLY  │
│                      │  not auto   │   if explicitly passed  │
│ terraform.tfvars     │  inherited  │                         │
│   instance_type =    │             │   var.instance_type     │
│   "t3.medium"        │             │   is UNDEFINED until    │
│                      │             │   passed via module {}  │
└─────────────────────┘             └────────────────────────┘
```

### Why this isolation exists

| Reason | Explanation |
|--------|-------------|
| **Reusability** | A module should work in any root — it can't depend on root variables existing |
| **Explicitness** | Module inputs are visible in the module block — no hidden variable passing |
| **Encapsulation** | Modules are self-contained units with clear inputs and outputs |
| **Avoids coupling** | Prevents implicit dependencies between root and child modules |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — All root variables auto-accessible | ❌ Terraform does **not** automatically pass root variables to child modules. Each must be explicitly passed. |
| C — Partial access to some variables | ❌ No root variables are auto-accessible. The child module doesn't know about `region`, `environment`, or any other root variable. |
| D — Access `terraform.tfvars` directly | ❌ `terraform.tfvars` is a root-level construct. Child modules cannot read `tfvars` files — they receive values only through the module block. |
| E — Default values auto-inherited | ❌ Even with defaults, root variables are not auto-passed. The child module must receive them explicitly or define its own defaults. |

## How Module Inputs Work

```hcl
# Root module: variables declared here
variable "instance_type" {
  default = "t2.micro"
}

# Root module: must explicitly pass to child
module "web" {
  source = "./modules/web"

  instance_type = var.instance_type   # Explicit pass
}
```

```hcl
# Child module: declares its own variable
variable "instance_type" {
  type = string
}

# Child module: uses the passed value
resource "aws_instance" "web" {
  instance_type = var.instance_type
}
```

### The explicit passing chain

```
terraform.tfvars
  → var.instance_type (= "t3.medium")     ← Root variable
  → module.web.instance_type = var.instance_type  ← Explicit pass
  → child's var.instance_type (= "t3.medium")     ← Module variable
  → aws_instance.web.instance_type                ← Resource attribute
```

## Variable Passing Patterns

| Pattern | Example |
|---------|---------|
| **Pass root variable** | `instance_type = var.instance_type` |
| **Pass literal** | `instance_type = "t3.large"` |
| **Pass local** | `instance_type = local.web_type` |
| **Pass resource attribute** | `vpc_id = aws_vpc.main.id` |
| **Pass module output** | `vpc_id = module.vpc.vpc_id` |

## Exam Tips

- Child modules **do not inherit** root variables automatically
- All module inputs must be **explicitly passed** via the module block
- Module isolation is **by design** — it promotes reusability and explicitness
- Each module declares its own variables independently
- Common exam trap: thinking root variables are automatically available in child modules (they are not)
- Another trap: thinking `terraform.tfvars` applies to all modules (it only applies to the root module)
