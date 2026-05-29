# IaC vs Manual Console/CLI Exercise

**Domain:** IaC Concepts
**Topic:** IaC vs manual console/CLI — versioned, reusable, shared

## Description

Management wants to understand how adopting Infrastructure as Code with Terraform differs from your current method of using the console and CLI to deploy and manage infrastructure. Which statement correctly identifies a major difference

## Learning Objectives

- Examine the IaC approach
- Compare IaC with manual console/CLI
- Key differences table
- Demo: IaC workflow vs manual

## Background

Managing infrastructure through a cloud console (clicking through a web UI) or via ad-hoc CLI commands is fundamentally different from Infrastructure as Code. The key difference is that IaC codifies infrastructure in **versionable, reusable, shareable configuration files**.

## Steps

### Part 1 — Examine the IaC approach

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   This is a complete infrastructure definition in a **single file** that can be:
   - ✅ **Versioned** — committed to Git, tracked with history
   - ✅ **Reused** — deploy to dev/staging/prod with different variables
   - ✅ **Shared** — teammates review via pull requests
   - ✅ **Automated** — CI/CD pipelines run `terraform apply`

### Part 2 — Compare IaC with manual console/CLI

2. **Manual approach (console + CLI):**

   ```bash
   # Step-by-step CLI commands, no record of what was done:
   aws ec2 create-vpc --cidr-block 10.0.0.0/16
   aws ec2 create-subnet --vpc-id vpc-123 --cidr-block 10.0.1.0/24
   aws ec2 create-security-group --group-name web-sg
   aws ec2 run-instances --subnet-id subnet-456 --ami ami-abc
   ```

   Problems:
   - ❌ **No version history** — who changed what, when?
   - ❌ **Not repeatable** — different result each time
   - ❌ **Not shareable** — send a doc? Hope it's up to date?
   - ❌ **Error-prone** — miss a step, wrong order, typo in CLI

3. **IaC approach (Terraform):**

   ```hcl
   # Declarative config in a file, versioned in Git:
   resource "aws_vpc" "main" {
     cidr_block = "10.0.0.0/16"
   }

   resource "aws_instance" "web" {
     ami           = "ami-abc"
     instance_type = "t2.micro"
   }
   ```

   Benefits:
   - ✅ **Versioned** — full change history in Git
   - ✅ **Reusable** — same code, different environments
   - ✅ **Shareable** — code review via pull requests
   - ✅ **Automated** — CI/CD pipeline, no manual steps
   - ✅ **Idempotent** — same result every time
   - ✅ **Drift detection** — `terraform plan` shows changes

### Part 3 — Key differences table

4. **Side-by-side comparison:**

   | Aspect | Manual (Console/CLI) | IaC (Terraform) |
   |--------|---------------------|-----------------|
   | **Definition** | Imperative steps | Declarative config |
   | **Version control** | ❌ Not possible | ✅ Git-tracked |
   | **Repeatability** | ❌ Manual each time | ✅ Same result every deploy |
   | **Code review** | ❌ No | ✅ Pull requests |
   | **Automation** | ❌ Manual execution | ✅ CI/CD integration |
   | **Drift detection** | ❌ No automatic check | ✅ `terraform plan` |
   | **Rollback** | ❌ Manual reverse steps | ✅ Revert to previous state |
   | **Collaboration** | ❌ Share docs/screenshots | ✅ Share code |
   | **Audit trail** | ❌ CloudTrail (resource-level) | ✅ Git + state history |
   | **Documentation** | ❌ Separate docs (stale) | ✅ Code is documentation |

### Part 4 — Demo: IaC workflow vs manual

5. **IaC workflow for a change:**

   ```bash
   # 1. Edit config
   # 2. Run plan to preview
   terraform plan

   # 3. Apply (or create PR for review)
   terraform apply

   # 4. Everything is in Git
   git log --oneline
   ```

6. **Manual workflow for the same change:**

   ```bash
   # 1. Research what to change
   # 2. Run CLI commands (hope they're right)
   aws ec2 modify-instance-attribute --instance-id i-123 --instance-type t3.large

   # 3. Note it down somewhere (if you remember)
   # 4. No audit trail of who approved what
   ```

## Files

- `main.tf` — config demonstrating IaC approach
- `outputs.tf` — output values
- `solution/` — reference implementation

