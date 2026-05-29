# Module Input Variables Exercise

**Domain:** Modules
**Topic:** Module input variables — `name`, `cidr`, `azs` as module arguments

## Description

In the following Terraform code, what do `name`, `cidr`, and `azs` represent, and what purpose do they serve

## Learning Objectives

- Inspect the module interface
- Inspect the calling module
- See it in action

## Steps

### Part 1 — Inspect the module interface

1. **Examine the child module's variable declarations:**

   ```bash
   cat modules/my_network/variables.tf
   ```

   `name`, `cidr`, and `azs` are declared as **input variables** in the child module. They define the contract — what values the module expects from its caller.

2. **Examine how the child module uses them:**

   ```bash
   cat modules/my_network/main.tf
   ```

   The module uses `var.name`, `var.cidr`, and `var.azs` inside its resource blocks. These are the **input variables** passed into the module.

### Part 2 — Inspect the calling module

3. **Examine the root module:**

   ```bash
   cat main.tf
   ```

   The `module "my_network"` block passes values from root-level variables to the child module:

   ```hcl
   name = var.network_name
   cidr = var.network_cidr
   azs  = var.network_azs
   ```

   Each argument maps a root variable to a module input variable.

### Part 3 — See it in action

4. **Initialize and apply:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

   Note how the module receives the default values (`main`, `10.0.0.0/16`, three AZs).

5. **Verify the flow:**

   ```bash
   terraform output module_received_inputs
   ```

   This shows exactly what values the module received — confirming `name`, `cidr`, and `azs` are the module's input interface.

6. **Change a root variable and re-apply:**

   ```bash
   export TF_VAR_network_name="production"
   terraform plan
   ```

   The new value flows through to the module, demonstrating how these inputs parameterize the module.

## Files
- `main.tf` — root module calling the child module
- `variables.tf` — root module input variables
- `outputs.tf` — root module outputs
- `modules/my_network/` — child module
- `modules/my_network/variables.tf` — declares `name`, `cidr`, `azs` as inputs
- `modules/my_network/main.tf` — uses inputs in resource creation
- `solution/` — reference implementation

