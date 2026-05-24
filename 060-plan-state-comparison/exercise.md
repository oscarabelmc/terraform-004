# Terraform Plan — State Comparison Exercise

**Exam Question:** You run `terraform plan` in a workspace that has existing infrastructure. Terraform shows that it will update 3 resources, create 2 new resources, and destroy 1 resource. How does Terraform determine what changes need to be made?

## Background

Terraform's `plan` command is a **three-way diff** between three sources of truth:

```
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   Configuration  │     │   State File     │     │  Real Infra      │
│   (desired state)│     │   (last known)   │     │  (actual cloud)  │
└────────┬─────────┘     └────────┬─────────┘     └────────┬─────────┘
         │                        │                        │
         └────────────┬───────────┘────────────────────────┘
                      ▼
            ┌──────────────────┐
            │   terraform plan │
            │                  │
            │  Creates/Updates │
            │  Destroys/No-op  │
            └──────────────────┘
```

## Steps

### Part 1 — Understand the plan mechanism

1. **Examine the config (desired state):**

   ```bash
   cat main.tf
   ```

   This config declares the desired end state: a VPC, a subnet, and an EC2 instance with specific attributes.

2. **Understand what the state file contains:**

   After an apply, the state file (`terraform.tfstate`) stores the **last known state** of the real infrastructure — resource IDs, attributes, metadata.

### Part 2 — The three-way comparison

3. **Terraform plan performs this logic:**

   ```
   For each resource in configuration:
     if resource exists in state AND matches config → No changes
     if resource exists in state BUT differs from config → Update in-place
     if resource does NOT exist in state → Create

   For each resource in state:
     if resource does NOT exist in config → Destroy
   ```

   This produces the plan output:

   ```
   Terraform will perform the following actions:

     # aws_vpc.main will be updated in-place
     # aws_subnet.public will be created
     # aws_instance.web will be destroyed
   ```

### Part 3 — See the plan in action

4. **Initialize and apply the config:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

5. **Modify a resource attribute (simulate a config change):**

   Edit `main.tf` and change the instance type to `t3.micro` and add a new subnet.

6. **Run plan to see the diff logic:**

   ```bash
   terraform plan
   ```

   Output shows:
   - `~ aws_instance.web` will be **updated** (instance type changed)
   - `+ aws_subnet.additional` will be **created** (new resource in config, not in state)
   - If you removed `aws_subnet.public` from config, it would show: `- aws_subnet.public` will be **destroyed**

### Part 4 — What plan does NOT do

7. **Plan is not a full refresh by default:**

   By default, `terraform plan` does **not** query all cloud APIs to detect drift. It trusts the state file as the source of current state. To detect drift (changes made outside Terraform), use:

   ```bash
   terraform plan -refresh-only
   ```

   This explicitly queries APIs to update state before comparing with config.

### Put It Together

You run `terraform plan` in a workspace that has existing infrastructure. Terraform shows that it will update 3 resources, create 2 new resources, and destroy 1 resource. How does Terraform determine what changes need to be made?

- A. Terraform queries all cloud provider APIs and compares the results with the configuration files
- B. Terraform compares the desired state in the configuration with the current state in the state file to build the plan
- C. Terraform reads the configuration and checks Git history to identify what changed
- D. Terraform looks at the `terraform plan` output from the last run and applies the same changes
- E. Terraform randomly orders all resources and determines changes based on resource dependencies

## Files

- `main.tf` — config with VPC, subnet, and EC2 instance
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
