# Root Module vs Child Module Exercise

**Domain:** Modules
**Topic:** Root vs child module identification

## Description

You are reviewing the following Terraform configuration in `main.tf`. Which statements about this configuration are correct? (Select two.)

## Learning Objectives

- Identify the root module
- Identify local child modules
- How the module relationship works
- Module source types

## Background

Every Terraform configuration has a **root module** — the directory where you run `terraform plan/apply`. Any module referenced via `module` block is a **child module**. Local child modules use a path starting with `./` or `../`.

## Steps

### Part 1 — Identify the root module

1. **Examine the file structure:**

   ```bash
   find . -type f -name "*.tf"
   ```

   ```
   ./main.tf                          ← Root module
   ./outputs.tf                       ← Root module outputs
   ./modules/local-cluster/main.tf      ← Child module
   ./modules/local-cluster/outputs.tf   ← Child module outputs
   ```

2. **Which is the root module?**

   `main.tf` at the top level is the **root (calling) module**. This is where Terraform is executed from.

### Part 2 — Identify local child modules

3. **The `source` path tells you the module type:**

   ```hcl
   module "servers" {
     source  = "./modules/local-cluster"  # ← Local path
     servers = 5
   }
   ```

   | Source prefix | Module type |
   |---------------|-------------|
   | `./` or `../` | **Local child module** on disk |
   | `terraform-aws-modules/vpc/aws` | **Registry module** (Terraform public registry) |
   | `github.com/org/repo` | **Git module** |
   | `http://...` | **HTTP module** |

4. **Since `source = "./modules/local-cluster"`, this is a local child module.**

### Part 3 — How the module relationship works

5. **Data flow:**

   ```
   Root Module (main.tf)              Child Module (./modules/local-cluster/)
   ┌──────────────────────────┐       ┌──────────────────────────────┐
   │ module "servers" {       │       │ variable "servers" {         │
   │   source = "./modules/   │ ───→  │   type = number              │
   │     local-cluster"         │ input │ }                            │
   │   servers = 5            │       │                              │
   │ }                        │       │ resource "aws_instance"      │
   │                          │       │   .server[count.index]       │
   │ output "server_count" {  │       │                              │
   │   value = 5              │       │ output "server_ids" {        │
   │ }                        │ ←───  │   value = aws_instance.     │
   └──────────────────────────┘ output │   server[*].id              │
                                       └──────────────────────────────┘
   ```

### Part 4 — Module source types

6. **Common source types for modules:**

   ```hcl
   # Local module (relative path)
   source = "./modules/networking"

   # Registry module
   source = "terraform-aws-modules/vpc/aws"
   version = "~> 5.0"

   # Git module
   source = "git::https://github.com/org/repo.git"

   # HTTP module
   source = "https://example.com/module.zip"
   ```

## Files

- `main.tf` — root module calling a local child module
- `outputs.tf` — root module outputs
- `modules/local-cluster/main.tf` — child module
- `modules/local-cluster/outputs.tf` — child module outputs
- `solution/` — reference implementation

