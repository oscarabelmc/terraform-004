# Explanation

The correct answers are **B** and **C**.

> **B.** Reduces operational overhead by allowing teams to learn and govern a single tool across all environments.
>
> **C.** Delivers a consistent declarative workflow and language across providers and hypervisors.

---

## Why B and C Are Correct

### B — Reduces operational overhead

With Terraform, teams manage **all cloud providers** using a single tool and workflow:

| Without Terraform | With Terraform |
|------------------|----------------|
| AWS: CloudFormation (different syntax) | All clouds: Terraform (same HCL) |
| Azure: ARM templates (different syntax) | All clouds: same CLI commands |
| GCP: Deployment Manager (different syntax) | All clouds: same init/plan/apply |
| Different CI/CD pipelines per cloud | One set of pipeline templates |

This reduces:
- **Training costs** — learn one tool, apply to all clouds
- **Governance complexity** — one policy engine (Sentinel/OPA) for all clouds
- **CI/CD maintenance** — one pipeline pattern, parameterized per cloud

### C — Consistent declarative workflow

```
┌──────────────────────────────────────────────────────────┐
│                    Terraform Workflow                     │
│                                                          │
│   Write HCL  ──→  terraform init  ──→  terraform plan   │
│   (any cloud)     (download plugins)  (preview changes)  │
│                                                          │
│   terraform apply  ──→  terraform destroy                │
│   (execute plan)        (tear down)                      │
└──────────────────────────────────────────────────────────┘
```

This workflow is **identical** whether you're deploying to AWS, Azure, GCP, or all three simultaneously:

```hcl
# Same tool, same commands, same language:
resource "random_pet" "aws_main" { ... }      # AWS
resource "random_pet" "azure_main" { ... }     # Azure
resource "random_pet" "gcp_main" { ... }       # GCP
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Standardizes pricing and usage models | Terraform is an **infrastructure provisioning tool**, not a billing/cost management tool. Each cloud provider has its own pricing model (on-demand, reserved, spot instances, committed use discounts, etc.) that Terraform does not abstract or standardize. |
| D — Removes need for provider credentials | Each provider requires **its own authentication**. Terraform passes credentials through but does not replace them. AWS needs access keys, Azure needs service principal credentials, GCP needs service account keys. |

## What Terraform Provides vs Does Not Provide

| Capability | Terraform provides? |
|-----------|-------------------|
| Consistent HCL syntax across providers | ✅ Yes |
| Same CLI workflow (init/plan/apply) | ✅ Yes |
| Multi-cloud in a single config | ✅ Yes |
| Reusable modules across environments | ✅ Yes |
| State management and locking | ✅ Yes |
| Standardize cloud pricing models | ❌ No |
| Eliminate provider credentials | ❌ No |
| Abstract away provider API differences | ⚠️ Partially — syntax is consistent, but resource attributes are provider-specific |
| Make all clouds behave identically | ❌ No — each cloud has unique services and behaviors |

## Objective Reference

**Objective 1c** — Explain how Terraform manages multi-cloud, hybrid cloud, and service-agnostic workflows.

Key points:
- A common workflow (init/plan/apply) enhances consistency
- A single tool lowers training, governance, and CI/CD complexity
- Providers still vary in behavior and capabilities
- Credentials are still needed per provider
- Pricing and billing are not standardized
