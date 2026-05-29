# Explanation

The correct answers are **A**, **C**, and **D**.

> A. IaC allows you to save your configurations in version control, enabling safe collaboration on infrastructure.
>
> C. IaC code can be used to manage infrastructure on multiple cloud platforms.
>
> D. IaC uses a human-readable configuration language to help you write infrastructure code quickly.

---

## Why A, C, and D Are Correct

### A — Version Control & Collaboration

IaC configurations are plain text files that can be stored in Git (or any VCS):

```
git add main.tf
git commit -m "Add production web server"
git push origin main
```

This enables:
- **Change tracking** — full history of who changed what and when
- **Code review** — PRs with infrastructure diffs before deployment
- **Rollbacks** — revert to a previous known-good configuration
- **Audit trail** — every infrastructure change is documented
- **CI/CD** — automated validation, planning, and deployment

### C — Multi-Cloud Management

IaC with Terraform is **platform-agnostic**:

| Cloud | Provider | Same Workflow |
|-------|----------|--------------|
| AWS | `hashicorp/aws` | `init → plan → apply` |
| Azure | `hashicorp/azurerm` | `init → plan → apply` |
| GCP | `hashicorp/google` | `init → plan → apply` |

The same `terraform init`, `terraform plan`, and `terraform apply` commands work across all clouds. Modules, functions, and expressions are also consistent regardless of target provider.

### D — Human-Readable Configuration

Terraform uses **HCL (HashiCorp Configuration Language)** — purpose-built for readability:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "web-server"
  }
}
```

HCL is significantly more readable than:
- Raw JSON (CloudFormation)
- YAML (Ansible, Kubernetes)
- XML (Azure classic)
- Imperative shell scripts

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — IaC is imperative | IaC (especially Terraform) is **declarative**. You define the desired end state, not the sequence of commands. Terraform figures out the order and steps to reach that state. |
| E — IaC requires manual steps each time | One of IaC's primary advantages is **automation** — the same config can be applied repeatedly without manual steps. `terraform apply` handles everything. |

## Declarative vs Imperative

| Aspect | Declarative (Terraform) | Imperative (Scripts) |
|--------|------------------------|---------------------|
| What you write | Desired state | Step-by-step commands |
| Ordering | Terraform determines | You specify |
| Idempotent | ✅ (same result every time) | ❌ (may fail if state differs) |
| Drift detection | ✅ (`terraform plan`) | ❌ (no built-in check) |
| Parallelism | Automatic | Manual |

## Core Benefits Summary

| Benefit | Description |
|---------|-------------|
| **Version control** | Track, review, audit all changes |
| **Automation** | Repeatable, consistent deployments |
| **Multi-cloud** | One tool, one workflow for any cloud |
| **Readability** | HCL purpose-built for infrastructure |
| **Idempotency** | Same config = same result every time |
| **Drift detection** | Plan shows what differs from desired state |
| **Collaboration** | PRs, code review, team workflows |
| **Self-documenting** | Config IS documentation |
