# Terraform Fmt Check Exercise

**Domain:** IaC Workflow
**Topic:** `terraform fmt -check` for CI/CD formatting gate

## Description

Your team wants to enforce consistent formatting across all Terraform files before merging code into the main branch. You're setting up a CI/CD pipeline and need a command that checks whether files are properly formatted without making changes. Which command should you use

## Learning Objectives

- Examine formatting issues
- Check formatting without changes
- Fix the formatting
- Using fmt -check in CI/CD

## Background

`terraform fmt` rewrites files to match canonical HCL formatting. For CI/CD pipelines, you want a **read-only check** that fails if files aren't formatted — without modifying them. `terraform fmt -check` does exactly this.

## Steps

### Part 1 — Examine formatting issues

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   Look for the intentional formatting inconsistency:

   ```hcl
   locals {
     name_prefix =  "fmt-check-demo-${var.environment}"
   ```

   There's a **double space** before the string — this is non-canonical formatting.

### Part 2 — Check formatting without changes

2. **Run the check command:**

   ```bash
   terraform fmt -check
   ```

   Output:

   ```
   main.tf
   ```

   `terraform fmt -check` prints the names of files that are **not** properly formatted and exits with a **non-zero exit code**. It makes **no changes** to the files.

3. **Verify the exit code:**

   ```bash
   terraform fmt -check
   echo $?
   # Output: 1  (or non-zero — means formatting issues found)
   ```

### Part 3 — Fix the formatting

4. **Apply formatting:**

   ```bash
   terraform fmt
   ```

   This rewrites `main.tf` with correct formatting.

5. **Re-check:**

   ```bash
   terraform fmt -check
   echo $?
   # Output: 0  (no formatting issues)
   ```

   No files are printed, and exit code is 0 — success.

### Part 4 — Using fmt -check in CI/CD

6. **Example CI/CD pipeline step:**

   ```yaml
   # GitHub Actions example
   - name: Check Terraform formatting
     run: terraform fmt -check -recursive
   ```

   If formatting is off, the pipeline **fails**, preventing unformatted code from merging.

7. **Compare fmt commands:**

   | Command | Makes changes? | Exit code on issues | Use case |
   |---------|---------------|-------------------|----------|
   | `terraform fmt` | ✅ Yes — rewrites files | 0 always | Local development |
   | `terraform fmt -check` | ❌ No — read-only | Non-zero if issues found | CI/CD pipelines |
   | `terraform fmt -recursive` | ✅ Yes — checks subdirs | 0 always | Multi-module projects |
   | `terraform fmt -check -recursive` | ❌ No — read-only all dirs | Non-zero if issues found | CI/CD for multi-module |

## Files

- `main.tf` — config with intentional formatting issue
- `outputs.tf` — output values
- `solution/` — reference implementation

