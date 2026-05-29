# Variable Type Errors Exercise

**Domain:** Input Variables
**Topic:** Variable type errors — `list(string)` with `default = {}`

## Description

Which of the following variable declarations will cause Terraform to return a type error before apply

## Learning Objectives

- See the type error
- Fix the error
- Confirm the others work
- Experiment with other mismatches

## Steps

### Part 1 — See the type error

1. **Initialize:**

   ```bash
   terraform init
   ```

2. **Run `terraform validate`:**

   ```bash
   terraform validate
   ```

   Terraform returns a type error:

   ```
   Error: Invalid default value for variable
   │
   │   on variables.tf line 4, in variable "names":
   │    4:   default     = {}
   │
   │ This default value is not compatible with the variable's type constraint:
   │ list(string) required, but map of any given.
   ```

   The `names` variable declares `type = list(string)` but provides an empty map `{}` as the default. A map is not compatible with a list type.

### Part 2 — Fix the error

3. **Edit `variables.tf`** and change the `names` default from `{}` to `[]`:

   ```
   default = []
   ```

4. **Re-validate:**

   ```bash
   terraform validate
   ```

   No errors — `[]` is an empty `list(string)`, which matches the type constraint.

### Part 3 — Confirm the others work

5. **Run `terraform plan`:**

   ```bash
   terraform plan
   ```

   The plan succeeds — `instance_count` (number), `enabled` (bool), and `tags` (map) all have correct type/default pairings.

6. **Apply and check outputs:**

   ```bash
   terraform apply -auto-approve
   terraform output
   ```

### Part 4 — Experiment with other mismatches

7. **Try more type mismatches** (one at a time, then revert):

   ```hcl
   # type = bool, default = "maybe"    → ERROR: string is not bool
   # type = number, default = "three"  → ERROR: string is not number
   # type = map(string), default = []  → ERROR: list is not map
   ```

## Files
- `variables.tf` — all four variable declarations (one with intentional type error)
- `main.tf` — uses all variables in a local_file resource
- `outputs.tf` — outputs for verification
- `solution/` — reference implementation

