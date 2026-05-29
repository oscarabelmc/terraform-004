# Local vs Remote State Exercise

**Domain:** State Management
**Topic:** Local vs remote state tradeoffs

## Description

Which statements accurately describe tradeoffs between local and remote Terraform state? (Select two.)

## Learning Objectives

- Local state (default behavior)
- Local state limitations (simulated)
- Remote state configuration
- Compare the tradeoffs

## Background

Terraform stores information about managed infrastructure in a **state file**. The choice between local and remote state storage has significant implications for collaboration, security, and reliability.

## Steps

### Part 1 — Local state (default behavior)

1. **Create a simple config and apply it:**

   ```bash
   cat > main.tf << 'EOF'
   terraform {
     required_providers {
       random = {
         source  = "hashicorp/random"
         version = "~> 3.6"
       }
     }
   }

   resource "random_pet" "example" {
     prefix = "local-test"
     length = 2
   }
   EOF
   ```

2. **Initialize and apply:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

3. **Observe the local state:**

   ```bash
   ls -la terraform.tfstate
   cat terraform.tfstate | head -20
   ```

   The state file sits on your local disk. You can read it, edit it (not recommended), and it works completely offline.

### Part 2 — Local state limitations (simulated)

4. **Simulate losing shared access** — move the `.terraform` folder and state to a separate directory and try to run `terraform plan` from a different location:

   ```bash
   mkdir -p /tmp/other-user
   cp terraform.tfstate /tmp/other-user/
   cd /tmp/other-user
   terraform init
   terraform plan
   ```

   Terraform has no idea this state file exists in another location. The "other user" starts with a blank slate — no collaboration possible.

5. **Simulate no locking** — open two terminals and run `terraform apply` in both simultaneously. The second run will succeed but may corrupt the state:

   ```bash
   # Terminal 1:
   terraform apply -auto-approve &
   # Terminal 2 (immediately after):
   terraform apply -auto-approve &
   ```

   With local state, there's no lock mechanism. Both writes can interleave, corrupting the state.

### Part 3 — Remote state configuration

6. **Examine a remote backend config:**

   ```bash
   cat main.tf
   ```

   ```hcl
   terraform {
     backend "s3" {
       bucket         = "my-terraform-state"
       key            = "team-infra/terraform.tfstate"
       region         = "us-east-1"
       encrypt        = true
       dynamodb_table = "terraform-locks"
     }
   }
   ```

   This setup provides:
   - **Centralized storage** — all team members access the same state file
   - **Encryption at rest** — `encrypt = true` enables S3 server-side encryption
   - **State locking** — DynamoDB prevents concurrent writes
   - **Access policies** — IAM controls who can read/write state

### Part 4 — Compare the tradeoffs

7. **Build the comparison table mentally:**

   | Feature | Local State | Remote State |
   |---------|-----------|--------------|
   | Setup effort | None (default) | Requires backend config |
   | Works offline | ✅ | ❌ (needs network) |
   | Team collaboration | ❌ | ✅ |
   | State locking | ❌ | ✅ (with DynamoDB, etc.) |
   | Encryption at rest | ❌ (manual) | ✅ (configurable) |
   | Access control | ❌ (filesystem) | ✅ (IAM/policies) |
   | Backup/recovery | Manual | Automated (versioning) |
   | Cost | Free | Storage costs apply |

## Files

- `main.tf` — starter config (for local state demo)
- `solution/` — reference implementation

