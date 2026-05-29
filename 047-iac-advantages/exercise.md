# Infrastructure as Code Advantages Exercise

**Domain:** IaC Concepts
**Topic:** Advantages of Infrastructure as Code

## Description

What are some advantages of using Infrastructure as Code in an organization? (Select three.)

## Learning Objectives

- Examine an IaC configuration
- Understand declarative vs imperative
- Version control and collaboration
- Multi-cloud management
- Human-readable configuration

## Background

Infrastructure as Code (IaC) is the practice of managing infrastructure through machine-readable definition files, rather than manual processes or interactive configuration tools. Terraform is a declarative IaC tool.

## Steps

### Part 1 — Examine an IaC configuration

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   This is a human-readable Terraform configuration that describes the **desired state** of infrastructure — not step-by-step commands to create it.

### Part 2 — Understand declarative vs imperative

2. **IaC is declarative:**

   You write **what** you want, not **how** to do it:

   ```hcl
   resource "aws_instance" "web" {
     ami           = "ami-abc123"
     instance_type = "t2.micro"
   }
   ```

   **Declarative** (Terraform): "I want an EC2 instance with this AMI and type."
   **Imperative** (manual/scripts): "Run this command, then that command, in this order."

   Terraform determines the **how** — ordering, dependencies, parallelism.

### Part 3 — Version control and collaboration

3. **IaC configs in version control:**

   ```bash
   git add main.tf
   git commit -m "Add web server configuration"
   git push
   ```

   Every change is tracked:
   - Who made the change
   - What changed
   - When it changed
   - Why (in the commit message)

   Teams collaborate via pull requests, code review, and CI/CD pipelines.

### Part 4 — Multi-cloud management

4. **Same tool, same workflow, multiple clouds:**

   The same `init → plan → apply` workflow works for AWS, Azure, GCP, and others:

   ```bash
   terraform init    # downloads AWS, Azure, GCP providers
   terraform plan    # shows changes across all clouds
   terraform apply   # deploys to all clouds
   ```

### Part 5 — Human-readable configuration

5. **HCL is purpose-built for readability:**

   ```hcl
   resource "aws_instance" "web" {
     ami           = "ami-0c55b159cbfafe1f0"
     instance_type = "t2.micro"

     tags = {
       Name        = "web-server"
       Environment = "production"
     }
   }
   ```

   Compare to raw API calls, CloudFormation JSON, or imperative scripts — HCL is much more readable.

## Files

- `main.tf` — IaC example showing declarative, multi-cloud, human-readable config
- `outputs.tf` — output values
- `solution/` — reference implementation

