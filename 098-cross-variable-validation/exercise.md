# Cross-Variable Validation Exercise

**Domain:** Input Variables
**Topic:** Cross-variable validation — conditional requirement on another variable

## Description

What is preventing you from producing a plan based on the error below

## Learning Objectives

- Examine the validation block
- Reproduce the error
- Understand when validation runs
- Fix the error
- Test with `terraform validate`

## Background

Validation blocks in Terraform can reference **other variables** using `var.<name>`. This enables conditional validation — where one variable's allowed values depend on another variable's setting.

The error above occurs because `cluster_endpoint` has a validation block that checks:
- If `create_cluster` is `false`, then `cluster_endpoint` must be a non-empty string
- When both variables are evaluated and the condition fails, Terraform halts during **input evaluation** — before it can generate a plan

## Steps

### Part 1 — Examine the validation block

1. **Open `variables.tf`:**

   ```bash
   cat variables.tf
   ```

   Look at the `cluster_endpoint` variable:

   ```hcl
   variable "cluster_endpoint" {
     type = string
     default = ""

     validation {
       condition     = var.create_cluster == false ? length(var.cluster_endpoint) > 0 : true
       error_message = "You must specify a value for cluster_endpoint if create_cluster is false."
     }
   }
   ```

   This validation uses a **ternary expression**:
   - If `create_cluster` is `false`: `cluster_endpoint` must have at least 1 character
   - If `create_cluster` is `true`: any value is allowed (even empty)

### Part 2 — Reproduce the error

2. **Initialize Terraform:**

   ```bash
   terraform init
   ```

3. **Try to plan with `create_cluster = false` and no endpoint:**

   ```bash
   terraform plan -var="create_cluster=false"
   ```

   The error matches the exam question exactly:

   ```
   │ Error: Invalid value for variable
   │
   │   on variables.tf line 7:
   │    7: variable "cluster_endpoint" {
   │     ├────────────────
   │     │ var.cluster_endpoint is ""
   │     │ var.create_cluster is false
   │
   │ You must specify a value for cluster_endpoint if create_cluster is false.
   ```

   Terraform **cannot produce a plan** — input evaluation fails first.

### Part 3 — Understand when validation runs

4. **Validation runs during input variable evaluation**, which happens:

   ```
   Input variables evaluated
         │
         ▼
   Validation conditions checked  ← Error caught here
         │
         ▼
   terraform validate / plan output
         │
         ▼
   Resource changes computed
   ```

   The validation error occurs **before** Terraform can produce a plan. No state lookup, no provider calls, no resource graph — the process stops at variable evaluation.

### Part 4 — Fix the error

5. **Provide a valid endpoint:**

   ```bash
   terraform plan -var="create_cluster=false" -var="cluster_endpoint=https://existing-cluster.example.com"
   ```

   Plan succeeds because the validation passes.

6. **Alternatively, set `create_cluster = true`:**

   ```bash
   terraform plan -var="create_cluster=true"
   ```

   Plan succeeds because when `create_cluster = true`, the validation condition is `true` (no constraint on endpoint).

### Part 5 — Test with `terraform validate`

7. **Validate also catches the error:**

   ```bash
   terraform validate -var="create_cluster=false"
   ```

   Same error — validation runs in both `validate` and `plan`.

## Files

- `main.tf` — configuration that consumes both variables
- `variables.tf` — variable declarations with cross-variable validation
- `outputs.tf` — output values
- `solution/` — reference implementation

