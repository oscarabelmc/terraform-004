# Multiple .tf Files — Order Independence Exercise

**Exam Question:** You have split a large module into multiple `.tf` files and rearranged several resource blocks without changing any arguments or references. What impact should this have when running a `terraform plan`?

## Background

Terraform processes all `.tf` files in a directory together — they are parsed as a **single configuration**. File names, block order within files, and the number of `.tf` files do not affect the resulting plan. Only the **content** of the declarations matters.

## Steps

### Part 1 — Examine the single-file config

1. **Change to the `single-file/` directory:**

   ```bash
   cd /home/terraform-004/048-multiple-tf-files/single-file
   cat main.tf
   ```

   All resources are in one file.

2. **Initialize and plan:**

   ```bash
   terraform init
   terraform plan -out=original.tfplan
   ```

   Save this plan for comparison.

### Part 2 — Split into multiple files

3. **Change to the `split-files/` directory:**

   ```bash
   cd /home/terraform-004/048-multiple-tf-files/split-files
   ls
   ```

   The same configuration has been split across `vpc.tf`, `subnets.tf`, and `outputs.tf`.

4. **Examine the split files:**

   ```bash
   cat vpc.tf
   cat subnets.tf
   cat outputs.tf
   ```

   The resource blocks are identical in content but rearranged and split across files.

### Part 3 — Compare the plans

5. **Initialize and plan in the split directory:**

   ```bash
   terraform init
   terraform plan -out=split.tfplan
   ```

6. **Compare the plans:**

   ```bash
   terraform show -no-color original.tfplan > /tmp/original.txt
   terraform show -no-color split.tfplan > /tmp/split.txt
   diff /tmp/original.txt /tmp/split.txt
   ```

   The plans are **identical** — no differences despite the file reorganization.

### Part 4 — Understand Terraform's file loading

7. **Terraform's rules for `.tf` files:**

   - All files ending in `.tf` (or `.tf.json`) in a directory are loaded
   - Files are sorted **alphabetically** before parsing
   - The sorted contents are parsed as **one combined configuration**
   - File names, block order, and comments have **zero effect** on the plan
   - `override.tf` / `override.tf.json` is the only file treated specially (loaded last)

### Put It Together

You have split a large module into multiple `.tf` files and rearranged several resource blocks without changing any arguments or references. What impact should this have when running a `terraform plan`?

- A. No changes — block order doesn't affect the plan because Terraform parses all `.tf` files in a module together during execution
- B. The plan shows resource destruction and recreation in the new order
- C. Terraform will fail to parse the configuration because blocks are in different files
- D. The plan is still the same but resources are created in alphabetical order
- E. Resources change order in the plan output, but the execution is the same

## Files

- `single-file/main.tf` — all resources in one file
- `split-files/vpc.tf` — VPC resource
- `split-files/subnets.tf` — subnet resources
- `split-files/outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
