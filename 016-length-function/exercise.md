# length() Function Exercise

**Exam Question:** You have a variable containing subnet CIDR blocks as a list: `["10.0.5.0/24", "10.0.0.0/24", "10.0.2.0/24"]`. You need to determine how many subnets are in the list to use. Which function returns the number of elements?

## Steps

### Part 1 — `length()` with a list

1. **Review the config:**

   ```bash
   cat variables.tf
   cat main.tf
   ```

   The `count` in `random_pet.subnets` is set to `length(var.subnet_cidrs)` — so with the default list of 3 CIDRs, Terraform will create 3 resources.

2. **Apply with the default list:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

3. **Check the outputs:**

   ```bash
   terraform output subnet_count
   terraform output all_subnet_pets
   ```

   `length()` returned 3, and exactly 3 resources were created.

### Part 2 — `length()` adapts to different inputs

4. **Override the variable with a different list:**

   ```bash
   export TF_VAR_subnet_cidrs='["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]'
   terraform plan
   ```

   The plan shows 4 resources — `length()` dynamically returns the new count.

5. **Try an empty list:**

   ```bash
   export TF_VAR_subnet_cidrs='[]'
   terraform plan
   ```

   **0 resources** — `length()` works correctly with empty lists, maps, and strings.

6. **Unset the override:**

   ```bash
   unset TF_VAR_subnet_cidrs
   ```

### Part 3 — `length()` with other types

7. **`length()` also works on strings and maps:**

   ```hcl
   length("hello")     → 5
   length({a=1, b=2})  → 2
   ```

   This is useful for validation, conditionals, and dynamic logic throughout Terraform configurations.

### Put It Together

You have a variable containing subnet CIDR blocks as a list: `["10.0.5.0/24", "10.0.0.0/24", "10.0.2.0/24"]`. You need to determine how many subnets are in the list to use. Which function returns the number of elements?

- A. `count(var.subnet_cidrs)`
- B. `len(var.subnet_cidrs)`
- C. `length(var.subnet_cidrs)`
- D. `size(var.subnet_cidrs)`
- E. `element(var.subnet_cidrs, 0)`

## Files
- `main.tf` — uses `length()` in `count`, `content`, and conditionals
- `variables.tf` — declares `var.subnet_cidrs` with a default list
- `outputs.tf` — shows computed length-based values
- `solution/answer.md` — explanation and exam tips
