# Core Terraform Workflow Exercise

**Exam Question:** What are the three core steps that make up the Terraform workflow? (Select three.)

## Background

The Terraform workflow consists of three fundamental steps that form a continuous loop for infrastructure management. All other operations (validate, destroy, import, state manipulation) are secondary to this core cycle.

## Steps

### Part 1 — Step 1: Write

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   This is the **Write** step — authoring infrastructure as code in HCL:

   ```hcl
   resource "aws_vpc" "main" {
     cidr_block = "10.0.0.0/16"
   }
   ```

   Writing involves:
   - Defining resources, data sources, and modules
   - Specifying provider configurations
   - Setting variables and outputs
   - Organizing code into reusable modules

### Part 2 — Step 2: Plan

2. **Run a plan:**

   ```bash
   terraform plan
   ```

   The **Plan** step compares the desired state (config) with the current state (state file) and shows what will be created, updated, or destroyed — **without making any changes**.

   ```bash
   # Plan output:
   Terraform will perform the following actions:
     # random_pet.name will be created
     # aws_vpc.main will be created
     # aws_subnet.public will be created
   ```

### Part 3 — Step 3: Apply

3. **Apply the configuration:**

   ```bash
   terraform apply
   ```

   The **Apply** step executes the plan, provisioning infrastructure in a reproducible manner.

### Part 4 — The continuous loop

4. **The workflow is iterative:**

   ```
   ┌─────────┐     ┌─────────┐     ┌─────────┐
   │  Write  │ ──→ │  Plan   │ ──→ │  Apply  │
   │  (code) │     │(preview)│     │(execute)│
   └─────────┘     └─────────┘     └─────────┘
        ↑                              │
        └──────────────────────────────┘
          (feedback loop — review,
           modify, re-plan, re-apply)
   ```

   - Change code → re-plan → re-apply
   - This loop continues throughout the infrastructure lifecycle

### Part 5 — What is NOT a core step

5. **Common misconceptions:**

   | Operation | Core step? | Why |
   |-----------|-----------|-----|
   | `terraform destroy` | ❌ No | Deprovisioning is an apply with empty config, not a separate core step |
   | `terraform validate` | ❌ No | Validation happens during write/plan, not a standalone workflow step |
   | `terraform import` | ❌ No | Import brings existing resources under management but is not part of the core cycle |
   | `terraform fmt` | ❌ No | Formatting is a code quality tool, not a workflow step |
   | `terraform init` | ❌ No | Initialization is a prerequisite, not a workflow step |

### Put It Together

What are the three core steps that make up the Terraform workflow? (Select three.)

- A. Write — Author infrastructure as code.
- B. Destroy — Deprovision and remove all infrastructure resources.
- C. Validate — Verify the syntax and internal consistency.
- D. Import — Bring in existing infrastructure resources under management.
- E. Plan — Preview changes before applying.
- F. Apply — Provision reproducible infrastructure.

## Files

- `main.tf` — example config to walk through Write → Plan → Apply
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
