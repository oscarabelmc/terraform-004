# Local vs Remote State — Tradeoffs Exercise

**Exam Question:** You're comparing local state versus remote state backends for your team's infrastructure. Which statements below correctly describe the key differences or tradeoffs between these approaches? (Select three.)

## Background

Terraform state can be stored **locally** (default) or in a **remote backend**. Each approach has distinct tradeoffs for security, collaboration, and operational complexity.

```
Local State                        Remote State
┌──────────────────────┐          ┌──────────────────────┐
│  terraform.tfstate   │          │  S3 / AzureRM / GCS  │
│                      │          │                      │
│  ✅ Simple setup     │          │  ✅ Team collaboration│
│  ✅ No infra needed  │          │  ✅ Encryption at rest│
│  ❌ No sharing       │          │  ✅ State locking     │
│  ❌ No locking       │          │  ❌ Requires config   │
│  ❌ Filesystem sec   │          │  ❌ Requires infra    │
└──────────────────────┘          └──────────────────────┘
```

## Steps

### Part 1 — Local state characteristics

1. **Examine the local state setup:**

   ```bash
   cat main.tf
   ```

   No `backend` block means Terraform uses the **local backend** by default. State is stored in `terraform.tfstate` in the current directory.

2. **Apply and observe:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

   A local `terraform.tfstate` file is created.

3. **Local state advantages:**

   | Advantage | Detail |
   |-----------|--------|
   | **Simple setup** | No configuration needed — default behavior |
   | **No additional infrastructure** | No S3 bucket, DynamoDB table, or cloud account required |
   | **Offline-friendly** | Works without network access |
   | **Fast** | No network latency for state operations |

4. **Local state disadvantages:**

   | Disadvantage | Detail |
   |--------------|--------|
   | **No team collaboration** | State file is on one machine; cannot be shared |
   | **No state locking** | Concurrent runs can corrupt state |
   | **Filesystem-only security** | Protection depends entirely on OS file permissions |
   | **No encryption** | State data (may contain secrets) is stored as plaintext |
   | **Easy to lose** | No backup unless manually copied |

### Part 2 — Remote state characteristics

5. **Remote backend setup (conceptual):**

   ```hcl
   terraform {
     backend "s3" {
       bucket         = "company-terraform-state"
       key            = "prod/terraform.tfstate"
       region         = "us-east-1"
       encrypt        = true
       dynamodb_table = "terraform-locks"
     }
   }
   ```

6. **Remote state advantages:**

   | Advantage | Detail |
   |-----------|--------|
   | **Team collaboration** | Centralized state accessible by all team members |
   | **State locking** | Prevents concurrent writes (e.g., S3 + DynamoDB) |
   | **Encryption at rest** | Most backends encrypt data (e.g., S3 SSE-S3/AES-256) |
   | **Access controls** | IAM policies, RBAC, audit logging |
   | **Backup & versioning** | S3 versioning, Azure soft-delete, etc. |
   | **Integration with HCP Terraform** | Run history, policy checks, VCS-driven runs |

7. **Remote state disadvantages:**

   | Disadvantage | Detail |
   |--------------|--------|
   | **Requires configuration** | Must configure `backend` block and run `init` |
   | **Requires infrastructure** | Need S3 bucket, DynamoDB table, etc. |
   | **Network dependency** | Must have network access to the backend |
   | **Operational overhead** | Managing backend infrastructure, permissions, costs |

### Part 3 — Compare side by side

8. **Key tradeoff table:**

   | Aspect | Local State | Remote State |
   |--------|:-----------:|:------------:|
   | Setup effort | None | Moderate (backend config + infra) |
   | Team collaboration | ❌ Manual file sharing | ✅ Centralized access |
   | State locking | ❌ Not available | ✅ Supported |
   | Encryption at rest | ❌ Filesystem only | ✅ Built-in (most backends) |
   | Access controls | ❌ OS permissions only | ✅ IAM/RBAC |
   | Operational cost | None | Backend infra cost |
   | Offline capability | ✅ Full | ❌ Requires network |
   | Backup/recovery | ❌ Manual | ✅ Versioning/backup |

### Put It Together

Which statements correctly describe the key differences or tradeoffs between local and remote state? (Select three.)

- A. Remote backends typically provide encryption at rest and access controls for state data, while local state security depends entirely on filesystem permissions
- B. Local state is simple to set up with no additional infrastructure required, while remote backends require configuration and maintenance of backend services
- C. Remote backends provide centralized state access for team collaboration, while local state requires manual file sharing between team members
- D. Local state automatically provides encryption at rest and in transit, while remote backends store everything in plaintext by default
- E. Local state supports more Terraform providers than remote backends because it has direct filesystem access

## Files

- `main.tf` — config using local state (no backend block)
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
