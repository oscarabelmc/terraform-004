# Answer

The correct answers are **A** and **B**.

> A. Local state is simple and works offline, but lacks shared access, locking, and org-level controls.
>
> B. Remote state centralizes storage with encryption, locking, and access policies for collaboration.

---

## Why A and B Are Correct

### A — Local State Tradeoffs

| Advantage | Disadvantage |
|-----------|-------------|
| No setup required (default behavior) | No shared access — only one machine has it |
| Works fully offline | No state locking — concurrent runs cause corruption |
| Simple to understand | No encryption at rest (unless manually encrypted) |
| Good for learning/single-user | No audit trail or access controls |

Local state is appropriate for:
- Personal projects / learning Terraform
- Development environments where state loss is acceptable
- Offline or air-gapped environments

It is **not** appropriate for:
- Team collaboration
- Production infrastructure
- Environments requiring audit trails

### B — Remote State Tradeoffs

| Advantage | Disadvantage |
|-----------|-------------|
| Centralized — all team members share one state | Requires network connectivity |
| State locking prevents corruption | More complex setup (backend config) |
| Encryption at rest (S3 SSE, Azure SSE, GCS encryption) | Additional cloud costs (storage, API calls) |
| Access control via IAM policies | Latency for state operations |

Remote state is appropriate for:
- Team collaboration
- Production and shared environments
- CI/CD pipelines
- Compliance and audit requirements

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| C — Local state provides better security | Local state has **no encryption at rest** and relies on OS file permissions. Remote backends like S3 offer encryption, access policies, and audit logging — typically **more** secure than local. |
| D — Remote state is required for all deployments | Local state is the **default** and works fine for single-user, non-production use. Remote state is recommended for teams but not required. |
| E — Local state supports locking via `.terraform.lock` | The `.terraform.lock.hcl` file is a **dependency lock file** (provider version pinning), not a state lock. Local state has **no locking mechanism**. |

## Feature Comparison

| Feature | Local | S3 | S3 + DynamoDB | AzureRM | GCS |
|---------|-------|----|--------------|---------|-----|
| Sharing | ❌ | ✅ | ✅ | ✅ | ✅ |
| Locking | ❌ | ❌ | ✅ | ✅ | ✅ |
| Encryption | ❌ | ✅ | ✅ | ✅ | ✅ |
| Access control | ❌ | ✅ | ✅ | ✅ | ✅ |
| Versioning | ❌ | ✅ | ✅ | ✅ | ✅ |
| Works offline | ✅ | ❌ | ❌ | ❌ | ❌ |

## Exam Tips

- Local state is **simple** and **offline** — two key exam descriptors
- Remote state = **shared**, **locked**, **encrypted**, **access-controlled**
- The `.terraform.lock.hcl` is **not** a locking mechanism — it's a dependency lock file
- State locking is only available with **remote backends that support it**
- Common exam pattern: "Which backend features are missing in local state?" — locking, shared access, encryption
- If the question says "two team members running apply simultaneously" — think about locking (remote) vs no locking (local)
- Local state path defaults to `terraform.tfstate` in the working directory
- Backend migration is done via `terraform init -migrate-state` or `terraform init -reconfigure`
