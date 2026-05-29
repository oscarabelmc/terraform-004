# Module Source — Public Registry Exercise

**Domain:** Modules
**Topic:** Public registry source format

## Description

You are performing a code review of a colleague's Terraform code and see the following code. Where is this module stored

## Learning Objectives

- Examine the source format
- Understand the public registry naming convention
- Compare with other source formats
- Understand versioning with the public registry

## Background

Terraform modules can come from several sources. The `source` argument uses a prefix-based format that tells Terraform where to find the module:

| Source Pattern | Location | Example |
|---------------|----------|---------|
| `<namespace>/<name>/<provider>` | **Public Registry** | `hashicorp/consul/aws` |
| `<hostname>/<namespace>/<name>/<provider>` | **Private Registry** | `app.terraform.io/my-org/vpc/aws` |
| `./path` or `../path` | **Local filesystem** | `./modules/networking` |
| `git::https://...` | **Git repository** | `git::https://github.com/org/repo.git` |
| `http://...` | **HTTP URL** | `https://example.com/module.zip` |

## Steps

### Part 1 — Examine the source format

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The source is `terraform-aws-modules/transit-gateway/aws` — no hostname prefix, three-part path. This is the standard Terraform Public Registry format.

### Part 2 — Understand the public registry naming convention

2. **Break down the source string:**

   ```
   terraform-aws-modules/transit-gateway/aws
   └─────────────────────┘ ┌─────────────┘ └──┘
          namespace          module name    provider
   ```

   | Part | Value | Meaning |
   |------|-------|---------|
   | **Namespace** | `terraform-aws-modules` | The organization or individual that published the module |
   | **Module name** | `transit-gateway` | The name of the module (often matches the repo name) |
   | **Provider** | `aws` | The target provider (always the last segment) |

3. **Search the registry (conceptual):**

   The module can be found at:
   ```
   https://registry.terraform.io/modules/terraform-aws-modules/transit-gateway/aws
   ```

### Part 3 — Compare with other source formats

4. **A private registry module would look like:**

   ```hcl
   source = "app.terraform.io/my-org/transit-gateway/aws"
   ```

5. **A local module would look like:**

   ```hcl
   source = "./modules/transit-gateway"
   ```

6. **A git module would look like:**

   ```hcl
   source = "git::https://github.com/terraform-aws-modules/terraform-aws-transit-gateway.git"
   ```

### Part 4 — Understand versioning with the public registry

7. **The version argument:**

   ```hcl
   version = "3.0.3"
   ```

   The `version` argument is only valid for **registry modules** (public or private). Local and git sources use different versioning mechanisms (git tags/refs).

## Files

- `main.tf` — module block with public registry source
- `outputs.tf` — output values
- `solution/` — reference implementation

