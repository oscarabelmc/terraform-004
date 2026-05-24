# Terraform Validate Exercise

**Exam Question:** Which Terraform command checks modules, attribute names, and value types to ensure the configuration is syntactically valid and internally consistent?

## Background

Before running `terraform plan` or `terraform apply`, it's good practice to validate your configuration. `terraform validate` checks:

- **Syntax** — valid HCL format
- **Attribute names** — resource arguments exist for the given provider
- **Value types** — arguments receive the correct type (string, number, list, etc.)
- **Module references** — referenced modules exist and their inputs/outputs are correct
- **Resource references** — `resource.something.attribute` references point to valid resources

`terraform validate` does **not** check cloud connectivity, authentication, or whether resources actually exist — that's `terraform plan`'s job.

## Steps

### Part 1 — Start with a valid config

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   This is a valid Terraform config that will pass validation.

2. **Initialize and validate:**

   ```bash
   terraform init
   terraform validate
   ```

   Expected output:

   ```
   Success! The configuration is valid.
   ```

### Part 2 — Introduce a syntax error

3. **Edit `main.tf` and introduce a syntax error** — remove a closing brace or add an invalid character.

4. **Run validation:**

   ```bash
   terraform validate
   ```

   Terraform reports where the syntax error is:

   ```
   │ Error: Unclosed configuration block
   │ 
   │   on main.tf line 9, in resource "local_file" "example":
   │    9: resource "local_file" "example" {
   ```

### Part 3 — Introduce a type error

5. **Edit `variables.tf`** and change `content` from a string to a boolean:

   ```hcl
   content = true
   ```

6. **Re-validate:**

   ```bash
   terraform validate
   ```

   Output:

   ```
   │ Error: Incorrect attribute value type
   │ 
   │   on variables.tf line 5, in variable "content":
   │    5:   default = true
   │     ├────────────────
   │     │ var.content is a string, but this value is bool
   ```

### Part 4 — Introduce an invalid attribute name

7. **Edit `main.tf`** and change `content` to a misspelled attribute like `contnt`:

   ```hcl
   contnt = var.content
   ```

8. **Re-validate:**

   ```bash
   terraform validate
   ```

   Terraform detects the unknown attribute:

   ```
   │ Error: Unsupported argument
   │ 
   │   on main.tf line 11, in resource "local_file" "example":
   │   11:   contnt = var.content
   │     ├────────────────
   │     │ An argument named "contnt" is not expected here.
   ```

### Part 5 — Fix the config and validate clean

9. **Restore the correct config** (or copy from `solution/main.tf`) and run:

   ```bash
   terraform validate
   ```

   ```
   Success! The configuration is valid.
   ```

### Put It Together

Which Terraform command checks modules, attribute names, and value types to ensure the configuration is syntactically valid and internally consistent?

- A. `terraform validate`
- B. `terraform fmt`
- C. `terraform plan`
- D. `terraform init`
- E. `terraform apply`

## Files

- `main.tf` — starter configuration (valid initially)
- `variables.tf` — input variable declarations
- `outputs.tf` — output definitions
- `solution/answer.md` — explanation and exam tips
- `solution/main.tf` — corrected configuration
