# Module Variable Access Exercise

**Domain:** Modules
**Topic:** Child module variable isolation — no auto-inheritance

## Description

A root module includes several variables in `terraform.tfvars`. You add a child module as shown below. What values can the child module access by default

## Learning Objectives

- Examine the root module
- Examine the child module
- How to pass variables to a child module
- Module isolation

## Background

In Terraform, **root module variables** are not automatically inherited by child modules. Each module is self-contained — a child module only knows about:

1. Variables it **declares** in its own `variable` blocks
2. Values **explicitly passed** to it via the `module` block arguments

Root-level variables from `terraform.tfvars` are not visible inside child modules unless explicitly passed through.

## Steps

### Part 1 — Examine the root module

1. **Open the root module files:**

   ```bash
   cat variables.tf
   ```

   ```hcl
   variable "region"       { default = "us-east-1" }
   variable "environment"  { default = "dev" }
   variable "instance_type" { default = "t2.micro" }
   ```

   ```bash
   cat terraform.tfvars
   ```

   ```hcl
   region       = "us-east-1"
   environment  = "production"
   instance_type = "t3.medium"
   ```

   The root module has three variables with values set in `terraform.tfvars`.

2. **Examine the module block in `main.tf`:**

   ```bash
   cat main.tf
   ```

   ```hcl
   module "web" {
     source = "./modules/web"
   }
   ```

   The module block is **empty** besides `source` — no variables are passed.

### Part 2 — Examine the child module

3. **Open the child module's files:**

   ```bash
   cat modules/web/main.tf
   ```

   ```hcl
   variable "instance_type" {
     type = string
   }

   resource "aws_instance" "web" {
     ami           = "ami-0c55b159cbfafe1f0"
     instance_type = var.instance_type
   }
   ```

   The child module declares its own `instance_type` variable. It expects this value to be passed from the root module.

4. **What happens with the current setup:**

   ```bash
   terraform init
   terraform plan
   ```

   Output:

   ```
   Error: Missing required argument
     on main.tf line 2, in module "web":
      2: module "web" {

   The argument "instance_type" is required, but was not set.
   ```

   Terraform reports an error because the child module requires `instance_type`, but the root module didn't pass it. The root variable `var.instance_type` is **not automatically available** inside the child module.

### Part 3 — How to pass variables to a child module

5. **The fix: pass variables explicitly:**

   Update `main.tf`:

   ```hcl
   module "web" {
     source = "./modules/web"

     instance_type = var.instance_type
   }
   ```

   Now the root variable `var.instance_type` is explicitly passed to the child module.

6. **The data flow:**

   ```
   Root Module                       Child Module (./modules/web)
   ┌───────────────────┐            ┌─────────────────────────┐
   │ terraform.tfvars  │            │                         │
   │ instance_type =   │            │ variable "instance_type"│
   │   "t3.medium"     │            │   type = string         │
   │         │         │            │                         │
   │         ▼         │            │ resource "aws_instance" │
   │ var.instance_type │   ──────→  │   instance_type =      │
   │         │         │   passed   │     var.instance_type   │
   │         ▼         │            │                         │
   │ module "web" {    │            └─────────────────────────┘
   │   instance_type = │
   │     var.instance  │
   │     _type         │
   │ }                 │
   └───────────────────┘
   ```

### Part 4 — Module isolation

7. **Module isolation is by design:**

   - Each module is a **self-contained unit** with its own variables, resources, and outputs
   - Root variables are not automatically inherited — this prevents **implicit coupling**
   - All module inputs are **explicit** — you can see exactly what each module receives by reading the module block
   - This makes modules **reusable** — they don't depend on root variables existing

## Files

- `main.tf` — root module with empty module block
- `variables.tf` — root module variable declarations
- `terraform.tfvars` — root module variable values
- `modules/web/main.tf` — child module expecting `instance_type`
- `modules/web/outputs.tf` — child module outputs
- `outputs.tf` — root module outputs
- `solution/` — reference implementation

