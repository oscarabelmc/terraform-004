# Validation — Enforce Exact Value Exercise

**Domain:** Input Variables
**Topic:** Validation block — enforce exact instance count

## Description

Your team is building a reusable Terraform module for web servers. The module must always create exactly two instances, and you want Terraform to fail if a caller tries to use any other value during plan or apply. Which approach should you use to enforce this requirement

## Learning Objectives

- Examine the module variable
- Test with the correct value
- Test with incorrect values
- Alternative approaches that don't work
- Multiple conditions

## Background

Variable `validation` blocks can enforce **any** condition on a variable value, including requiring an exact value. This is useful for modules that must use a fixed count or specific setting that should not be overridden.

## Steps

### Part 1 — Examine the module variable

1. **Open `variables.tf`:**

   ```bash
   cat variables.tf
   ```

   The `instance_count` variable has a validation block enforcing the exact value `2`:

   ```hcl
   variable "instance_count" {
     type = number

     validation {
       condition     = var.instance_count == 2
       error_message = "This module requires exactly 2 instances."
     }
   }
   ```

### Part 2 — Test with the correct value

2. **Initialize and plan:**

   ```bash
   cd /home/terraform-004/043-validation-exact-value
   terraform init
   ```

3. **Plan with the expected value:**

   ```bash
   terraform plan -var="instance_count=2"
   ```

   The plan succeeds — validation passes.

### Part 3 — Test with incorrect values

4. **Plan with too few instances:**

   ```bash
   terraform plan -var="instance_count=1"
   ```

   Error:

   ```
   │ Error: Invalid value for variable
   │
   │   on variables.tf line 1:
   │    1: variable "instance_count" {
   │     ├────────────────
   │     │ var.instance_count is 1
   │
   │ This module requires exactly 2 instances.
   ```

5. **Plan with too many instances:**

   ```bash
   terraform plan -var="instance_count=5"
   ```

   Same error. Any value other than `2` fails validation.

### Part 4 — Alternative approaches that don't work

6. **Why not just hardcode `count = 2`?** — You could hardcode it, but then the variable is misleading (it accepts input but ignores it). Validation is more transparent.

7. **Why not just document it?** — Documentation is good, but it doesn't prevent misuse. Validation enforces the requirement programmatically.

### Part 5 — Multiple conditions

8. **You can combine exact value with other checks:**

   ```hcl
   variable "instance_type" {
     type = string

     validation {
       condition     = contains(["t3.micro", "t3.small", "t3.medium"], var.instance_type)
       error_message = "Instance type must be one of: t3.micro, t3.small, t3.medium."
     }
   }
   ```

   While `instance_count` enforces an exact value, other variables can use `contains()` to allow a set of valid values.

## Files

- `main.tf` — module resource using `var.instance_count`
- `variables.tf` — variable with validation enforcing exact value
- `outputs.tf` — output values
- `solution/` — reference implementation

