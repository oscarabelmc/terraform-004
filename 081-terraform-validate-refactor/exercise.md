# Terraform Validate After Refactoring Exercise

**Exam Question:** You're refactoring a large Terraform configuration, splitting a monolithic file into multiple smaller files and reorganizing resource blocks. Before running `terraform plan`, what's the fastest way to verify you didn't introduce any syntax errors during the refactoring?

## Background

When you split a single `main.tf` into multiple files (`main.tf`, `resources.tf`, `variables.tf`, `outputs.tf`), you can introduce syntax errors, broken references, or missing resources. `terraform validate` is the fastest feedback loop — it runs entirely offline and checks the entire configuration across all `.tf` files.

## Steps

### Part 1 — Examine the refactored config

1. **List the files:**

   ```bash
   ls *.tf
   ```

   ```
   main.tf         ← providers, variables, locals
   resources.tf    ← resources (refactored out of main.tf)
   outputs.tf      ← output values
   ```

   The config was split from a single monolithic file into separate files. This is a common refactoring.

2. **Cross-file references still work:**

   - `main.tf` defines `var.environment`, `var.instance_type`, `local.name_prefix`
   - `resources.tf` references those variables and locals
   - Terraform parses **all** `.tf` files together, so the split is transparent

### Part 2 — Run validate after refactoring

3. **Initialize and validate:**

   ```bash
   terraform init      # Required first — validate needs provider schemas
   terraform validate
   ```

   Output:

   ```
   Success! The configuration is valid.
   ```

### Part 3 — Introduce and catch refactoring errors

4. **Common refactoring mistakes validate catches:**

   | Error | What changed | Validate catches it? |
   |-------|-------------|---------------------|
   | Missing closing brace | File split error | ✅ Yes |
   | Typo in resource type | `aws_instanse` instead of `aws_instance` | ✅ Yes |
   | Broken reference | `aws_vpc.main.id` → `aws_vpc.wrong.id` | ✅ Yes |
   | Undefined variable | `var.region` but `region` not defined in `variables.tf` | ✅ Yes |
   | Duplicate resource name | Same resource in two files | ✅ Yes |

5. **Test: introduce a reference error:**

   Edit `resources.tf` and change `aws_vpc.main.id` to `aws_vpc.main.nonexistent`:

   ```bash
   terraform validate
   ```

   Output:

   ```
   Error: Unsupported attribute
     on resources.tf line 9, in resource "aws_subnet" "public":
      9:   vpc_id = aws_vpc.main.nonexistent
   ```

   Fix the error and re-validate before running plan.

### Part 4 — Validate vs plan after refactoring

6. **Speed comparison:**

   ```bash
   time terraform validate    # ~0.5 seconds — offline
   time terraform plan        # ~15 seconds — contacts state backend
   ```

   After refactoring, run `validate` iteratively as you edit, then `plan` only once before apply.

### Put It Together

You're refactoring a large Terraform configuration, splitting a monolithic file into multiple smaller files and reorganizing resource blocks. Before running `terraform plan`, what's the fastest way to verify you didn't introduce any syntax errors during the refactoring?

- A. Run `terraform plan`
- B. Run `terraform validate`
- C. Run `terraform fmt`
- D. Run `terraform apply` and check for errors
- E. Manually review all files for syntax errors

## Files

- `main.tf` — providers, variables, locals
- `resources.tf` — resources (split from main)
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
