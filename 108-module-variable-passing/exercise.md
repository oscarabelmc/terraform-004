# Module Variable Passing Exercise

**Exam Question:** You have a root module that calls the child module `modules/web`. In `modules/web/main.tf`, a developer added `name = "${var.env}-app"`. What is the correct way to make this work?

## Background

Child modules in Terraform are **isolated** — they cannot access root module variables directly. All values must be **explicitly passed** through the module block.

```
Root module                          Child module (modules/web)
┌────────────────────┐               ┌────────────────────────┐
│ variable "env" {}  │    pass via    │ variable "env" {}      │
│                    │ ────────────►  │                        │
│ module "web" {     │   module args  │ resource "..." "app" { │
│   env = var.env    │               │   name = "${var.env}-app"│
│ }                  │               │ }                      │
└────────────────────┘               └────────────────────────┘
     ▲                                    ▲
     │                                    │
  Root variable                      Child variable
  (not inherited)                    (must be declared)
```

## Steps

### Part 1 — The problem: root variables aren't inherited

1. **Examine the root module:**

   ```bash
   cat main.tf
   ```

   The root module defines a variable `env` and calls the child module `modules/web`:

   ```hcl
   variable "env" {
     type    = string
     default = "production"
   }

   module "web" {
     source = "./modules/web"
     # TODO: pass env variable
   }
   ```

2. **Examine the child module:**

   ```bash
   cat modules/web/main.tf
   ```

   The child module references `var.env`:

   ```hcl
   resource "random_pet" "web" {
     name = "${var.env}-app"
   }
   ```

3. **Try to run `terraform plan`:**

   ```bash
   terraform init
   terraform plan
   ```

   Error:

   ```
   │ Error: Reference to undeclared input variable
   │
   │   on modules/web/main.tf line 2:
   │    2:     name = "${var.env}-app"
   │
   │ The module at modules/web does not declare a variable
   │ named "env".
   ```

   The child module cannot see the root's `var.env`. It must declare its own variable.

### Part 2 — The fix: declare in child, pass from root

4. **Step 1 — Declare `env` in the child module:**

   Add to `modules/web/variables.tf`:

   ```hcl
   variable "env" {
     type        = string
     description = "Environment name for resource naming"
   }
   ```

   This tells the child module: "I expect an input called `env` of type string."

5. **Step 2 — Pass the value from the root module:**

   In the root `main.tf`, update the module block:

   ```hcl
   module "web" {
     source = "./modules/web"
     env    = var.env
   }
   ```

   This passes the root's `var.env` value to the child module's `var.env`.

### Part 3 — Verify it works

6. **Run plan again:**

   ```bash
   terraform plan
   ```

   Plan succeeds. The child module now receives the value.

7. **Test with a different value:**

   ```bash
   terraform plan -var="env=staging"
   ```

   The child module uses `staging` — resources are named `staging-app`.

### Part 4 — The full variable flow

8. **How variables flow through modules:**

   ```
   User input                     Root module                    Child module
   ┌──────────────┐              ┌──────────────────┐          ┌──────────────────┐
   │ -var="env=   │              │ variable "env" {} │          │ variable "env" {} │
   │ production"  │ ────────────►│                  │ ────────►│                  │
   │ TF_VAR_env=  │              │ module "web" {   │          │ name =           │
   │ production   │              │   env = var.env  │          │ "${var.env}-app" │
   └──────────────┘              │ }                │          └──────────────────┘
                   terraform.tfvars                 │
                   env = "production"                │
                                  └──────────────────┘
   ```

   Each layer must **declare** the variable and **pass** it to the next layer. Variables are never automatically inherited.

### Put It Together

You have a root module that calls the child module `modules/web`. In `modules/web/main.tf`, a developer added `name = "${var.env}-app"`. What is the correct way to make this work?

- A. Declare `variable "env" {}` in the child module and pass it from root using `env = var.env`
- B. The child module automatically inherits `var.env` from the root — no changes needed
- C. Use `terraform output` to read the env value in the child module
- D. Set the `env` variable in `modules/web/terraform.tfvars`
- E. Use `data.terraform_remote_state` to read the root variable

## Files

- `main.tf` — root module (needs module argument for env)
- `variables.tf` — root variable declarations
- `modules/web/main.tf` — child module referencing `var.env`
- `modules/web/variables.tf` — child variable declaration (to be created)
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
