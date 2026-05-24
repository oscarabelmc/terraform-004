# IaC — Declarative vs Imperative Exercise

**Exam Question:** What sets Infrastructure as Code (IaC) apart from managing infrastructure directly instead of making raw API calls or executing CLI commands?

## Background

There are two fundamental approaches to infrastructure management:

| Approach | Description | Example |
|----------|-------------|---------|
| **Declarative** (IaC) | Describe the desired end state; tool figures out how | `ami = "ami-abc"` — Terraform decides steps |
| **Imperative** (manual) | Execute step-by-step commands in order | `aws ec2 run-instances --ami ami-abc` |

## Steps

### Part 1 — Examine a declarative config

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   This Terraform config declares the **desired state** — a VPC, subnet, and instance with specific attributes. It does **not** specify the order of operations or how to achieve this state.

### Part 2 — Compare with the imperative approach

2. **What you'd do without IaC (imperative):**

   ```bash
   # Step 1: Create VPC
   aws ec2 create-vpc --cidr-block 10.0.0.0/16
   # Step 2: Note VPC ID, create subnet
   aws ec2 create-subnet --vpc-id vpc-123 --cidr-block 10.0.1.0/24
   # Step 3: Note subnet ID, create instance
   aws ec2 run-instances --subnet-id subnet-456 --ami ami-abc
   ```

   Each step depends on the previous step's output. If a step fails, you must manually handle recovery.

### Part 3 — Terraform's declarative workflow

3. **The declarative flow:**

   ```bash
   terraform plan   # Shows what will change — no action yet
   terraform apply  # Executes the planned changes
   ```

   - **Plan**: Terraform reads the config, compares to current state, and generates an execution plan
   - **Apply**: Terraform executes the plan, handling ordering, dependencies, and parallel execution

4. **Drift detection (unique to declarative):**

   If someone manually modifies the VPC, `terraform plan` shows the drift:

   ```bash
   terraform plan
   # ~ aws_vpc.main
   #     tags.Name: "my-vpc" => "production-vpc"  (drift detected)
   ```

### Part 4 — Why declarative is better for IaC

5. **Key advantages of declarative IaC over imperative scripts:**

   | Feature | Declarative (Terraform) | Imperative (CLI/Scripts) |
   |---------|------------------------|-------------------------|
   | Desired state | ✅ Declared in config | ❌ Not defined |
   | Plan before action | ✅ `terraform plan` | ❌ Must dry-run manually |
   | Idempotent | ✅ Same result every time | ❌ May fail if already exists |
   | Drift detection | ✅ `terraform plan` shows diffs | ❌ No automatic detection |
   | Dependency ordering | ✅ Automatic (graph) | ❌ Manual |
   | Parallel execution | ✅ Automatic | ❌ Manual |
   | Rollback | ✅ State versioning | ❌ Manual reverse steps |

### Put It Together

What sets Infrastructure as Code (IaC) apart from managing infrastructure directly instead of making raw API calls or executing CLI commands?

- A. Terraform uses declarative configuration to describe the desired end state and generates a plan of action before applying changes
- B. IaC requires running commands in a specific order that the user must define
- C. IaC can only be used with a single cloud provider at a time
- D. Terraform makes raw API calls directly without any abstraction layer
- E. IaC eliminates the need for configuration files by using interactive prompts

## Files

- `main.tf` — declarative config showing desired state
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
