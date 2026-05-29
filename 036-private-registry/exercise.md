# HCP Terraform Private Registry Exercise

**Domain:** HCP Terraform
**Topic:** Private registry for org-only modules

## Description

Which feature of HCP Terraform enables you to publish and maintain a set of custom modules that can only be used within your organization

## Learning Objectives

- Private registry vs public registry
- Using a module from the private registry
- Publishing a module to the private registry
- Version constraints with private modules

## Background

HCP Terraform (formerly Terraform Cloud) provides a **private module registry** that allows organizations to publish, version, and share their own Terraform modules exclusively within their organization. This is distinct from the public Terraform Registry (registry.terraform.io), which is open to everyone.

## Steps

### Part 1 — Private registry vs public registry

1. **Understand the difference:**

   | Aspect | Public Registry | Private Registry |
   |--------|---------------|-----------------|
   | Access | Anyone | Your organization only |
   | Modules | Community/verified | Your custom modules |
   | Authentication | None | HCP Terraform token |
   | Versioning | Semver tags | Same |
   | Documentation | Generated from README | Same |

### Part 2 — Using a module from the private registry

2. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The module source references the private registry using the HCP Terraform hostname:

   ```hcl
   module "networking" {
     source  = "app.terraform.io/my-org/networking/aws"
     version = "~> 1.0"
   }
   ```

   The format is: `<hostname>/<organization>/<module-name>/<provider>`

### Part 3 — Publishing a module to the private registry

3. **Understand the publishing workflow:**

   ```bash
   # Create a module repository with a specific structure
   terraform-module-name/
   ├── README.md
   ├── main.tf
   ├── variables.tf
   ├── outputs.tf
   └── modules/
   ```

4. **Tag a release:**

   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

5. **Connect the repository in HCP Terraform:**
   - Navigate to Registry → Modules → Connect
   - Select your VCS provider (GitHub, GitLab, etc.)
   - Choose the repository
   - HCP Terraform automatically detects semantic version tags

### Part 4 — Version constraints with private modules

6. **Same versioning rules apply:**

   ```hcl
   # Private registry modules support the same version constraints
   module "networking" {
     source  = "app.terraform.io/my-org/networking/aws"
     version = "~> 1.0"    # pessimistic constraint
   }

   module "database" {
     source  = "app.terraform.io/my-org/rds/aws"
     version = ">= 2.0, < 3.0"  # range constraint
   }
   ```

## Files

- `main.tf` — example using a module from the private registry
- `modules/custom-vpc/` — example module that could be published to the private registry
- `solution/` — reference implementation

