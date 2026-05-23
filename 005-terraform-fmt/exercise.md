# Terraform Format Exercise

**Exam Question:** After creating several Terraform configurations, you want to quickly format the files without editing each one manually. How can you update all the files at once?

## Steps

1. **View the current formatting chaos:**

   ```bash
   cat main.tf
   ```

   Notice the inconsistent indentation, extra spaces, and misplaced braces.

2. **Format all files in this directory:**

   ```bash
   terraform fmt
   ```

   All `.tf` files in the current directory are reformatted to canonical HCL style. Run `cat main.tf` again to see the difference.

3. **Check if files are already formatted:**

   ```bash
   terraform fmt -check
   ```

   This exits with code 0 if all files are formatted, or 1 if any need formatting. No file changes are made — useful for CI pipelines.

4. **Preview changes without applying:**

   ```bash
   terraform fmt -diff
   ```

   Shows a diff of what would change. Run it on the `outputs.tf` file:

   ```bash
   terraform fmt -diff outputs.tf
   ```

5. **Format subdirectories recursively:**

   ```bash
   terraform fmt -recursive
   ```

   This also formats `subdir/main.tf`. Check it:

   ```bash
   cat subdir/main.tf
   ```

6. **List files that were changed:**

   ```bash
   terraform fmt -list
   ```

### Put It Together

Which command updates all Terraform configuration files in a directory and its subdirectories with proper formatting?

- A. `terraform validate`
- B. `terraform fmt -recursive`
- C. `terraform format`
- D. `terraform lint`
- E. `terraform fmt`

## Files
- `main.tf` — deliberately poorly formatted
- `outputs.tf` — also poorly formatted
- `subdir/main.tf` — nested file to test `-recursive`
- `solution/answer.md` — explanation and exam tips
