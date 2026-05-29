# Environment Variable Prefix Exercise

**Domain:** Input Variables
**Topic:** Environment variable prefix — `TF_VAR_`

## Description

When assigning a value to a Terraform input variable through an environment variable, which prefix string is necessary

## Learning Objectives

- Correct prefix
- Set all variables via `TF_VAR_`
- Alternative methods and precedence

## Steps

### Part 1 — Correct prefix

1. **Try setting a variable without the prefix:**

   ```bash
   export region=us-east-1
   terraform plan
   ```

   Terraform prompts for all required variables because the plain `region` env var is not read by Terraform.

2. **Use the correct prefix:**

   ```bash
   export TF_VAR_region=us-east-1
   terraform plan
   ```

   Terraform picks up the value. It still prompts for `instance_count`, `enable_monitoring`, and `tags` — they aren't set yet.

### Part 2 — Set all variables via `TF_VAR_`

3. **Set all required variables at once:**

   ```bash
   export TF_VAR_region=us-east-1
   export TF_VAR_instance_count=3
   export TF_VAR_enable_monitoring=true
   export TF_VAR_tags='{env="dev",team="infra"}'
   terraform plan
   ```

   The plan succeeds — all values are supplied via environment variables using the `TF_VAR_` prefix.

### Part 3 — Alternative methods and precedence

4. **Create a `terraform.tfvars` file:**

   ```hcl
   region           = "eu-west-1"
   instance_count   = 5
   enable_monitoring = false
   tags = {
     env  = "staging"
     team = "ops"
   }
   ```

5. **Run `terraform plan`** with both the env vars and the `.tfvars` file set:

   ```bash
   terraform plan
   ```

   Which value wins? The `.tfvars` file has **higher precedence** than `TF_VAR_` env vars.

## Files
- `main.tf` — declares four typed input variables with no defaults
- `solution/` — reference implementation

