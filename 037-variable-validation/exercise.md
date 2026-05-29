# Variable Validation Exercise

**Domain:** Input Variables
**Topic:** Variable validation error timing

## Description

Your configuration includes a validation block in a variable, as shown below. A user sets `instance_count = 15`. When does Terraform report the validation error

## Learning Objectives

- Examine the validation block
- Test with a valid value
- Test with an invalid value
- Test with validate
- Verify no resources are created

## Background

Terraform's `validation` block allows you to define custom constraints on variable values. The validation is evaluated **before** any resource operations — during the planning/validation phase. This catches invalid inputs early, before any infrastructure changes are attempted.

## Steps

### Part 1 — Examine the validation block

1. **Open `variables.tf`:**

   ```bash
   cat variables.tf
   ```

   The validation block uses:
   - `condition` — a boolean expression that must be `true`
   - `error_message` — the message shown when the condition is `false`

### Part 2 — Test with a valid value

2. **Initialize and run validate:**

   ```bash
   terraform init
   terraform validate
   ```

3. **Plan with a valid value:**

   ```bash
   terraform plan -var="instance_count=5"
   ```

   No errors. The plan proceeds normally.

### Part 3 — Test with an invalid value

4. **Plan with an out-of-range value:**

   ```bash
   terraform plan -var="instance_count=15"
   ```

   Terraform reports the validation error **before** showing any resource changes:

   ```
   │ Error: Invalid value for variable
   │
   │   on variables.tf line 1:
   │    1: variable "instance_count" {
   │     ├────────────────
   │     │ var.instance_count is 15
   │
   │ Instance count must be between 1 and 10.
   ```

   The plan does **not** proceed — the error is raised during variable evaluation.

### Part 4 — Test with validate

5. **Run validate with the default value:**

   ```bash
   terraform validate -var="instance_count=15"
   ```

   Same result — validation fails at the validate stage too.

### Part 5 — Verify no resources are created

6. **Confirm that no resources were created despite the error:**

   ```bash
   ls -la terraform.tfstate 2>/dev/null
   echo "No state file exists — no resources were created"
   ```

   The error was caught during planning/validation, so TerraForm never reached the apply phase.

## Files

- `main.tf` — config that consumes `instance_count`
- `variables.tf` — variable with validation block
- `outputs.tf` — output values
- `solution/` — reference implementation

