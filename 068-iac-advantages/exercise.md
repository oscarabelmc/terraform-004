# Infrastructure as Code Advantages Exercise

**Domain:** IaC Concepts
**Topic:** Advantages of IaC

## Description

What are the advantages of using Infrastructure as Code? (Select five.)

## Learning Objectives

- Examine an IaC config
- Consistency and standardization
- Repeatability and reuse
- Automation and disaster recovery
- Accessibility and ease of learning
- What IaC does NOT do

## Background

Infrastructure as Code (IaC) is the practice of managing and provisioning infrastructure through code rather than manual processes. It brings software engineering practices — version control, code review, automated testing — to infrastructure management.

## Steps

### Part 1 — Examine an IaC config

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   This config demonstrates key IaC advantages:
   - **Parameterized** — the `environment` variable makes code reusable across dev/staging/prod
   - **Consistent** — every deploy produces the same structure
   - **Automated** — one command provisions the entire stack
   - **Version-controlled** — this `.tf` file can be committed to Git

### Part 2 — Consistency and standardization

2. **IaC ensures identical environments:**

   ```bash
   # Deploy to dev:
   terraform apply -var="environment=dev"

   # Deploy to staging — same code, consistent outcome:
   terraform apply -var="environment=staging"

   # Deploy to prod — same code, different sizing:
   terraform apply -var="environment=prod"
   ```

   Without IaC, environments drift over time as manual changes are made inconsistently.

### Part 3 — Repeatability and reuse

3. **Reuse code for similar but different resources:**

   The same module or config can be reused across:
   - Multiple environments (dev, staging, prod)
   - Multiple regions (us-east-1, eu-west-2)
   - Multiple projects

   ```hcl
   module "networking" {
     source   = "./modules/networking"
     env      = var.environment
     cidr     = "10.${var.index}.0.0/16"
   }
   ```

### Part 4 — Automation and disaster recovery

4. **Automate manual deployment tasks:**

   ```bash
   # Instead of clicking through a console or running 10 CLI commands:
   terraform apply  # One command provisions everything
   ```

5. **Disaster recovery:**

   With IaC, recovering from infrastructure failure means:

   ```bash
   # In a new region or account:
   git clone <repo>
   terraform init
   terraform apply   # Exact replica of production infra
   ```

   No manual re-creation, no guesswork about what was configured.

### Part 5 — Accessibility and ease of learning

6. **IaC is accessible:**

   HCL (HashiCorp Configuration Language) is designed to be human-readable:

   ```hcl
   resource "aws_instance" "web" {
     ami           = "ami-abc"
     instance_type = "t2.micro"
   }
   ```

   Even without a programming background, operators and sysadmins can read and write IaC.

### Part 6 — What IaC does NOT do

7. **IaC does not replace application development languages:**

   HCL is for **infrastructure provisioning**, not application logic. You still write applications in Go, Python, Java, .NET, etc. IaC and application code are complementary, not competing.

## Files

- `main.tf` — reusable, parameterized config demonstrating IaC advantages
- `outputs.tf` — output values
- `solution/` — reference implementation

