# Explanation

The correct answer is **C**.

> Infrastructure as Code allows infrastructure to be described using a configuration syntax that can be versioned, reused, and shared.

---

## Why C Is Correct

The fundamental difference between IaC and manual approaches is that IaC **codifies infrastructure in files**:

```
Manual (Console/CLI):         IaC (Terraform):
  Ephemeral commands            Persistent config files
  No version history            Git-tracked history
  One-off executions            Reusable across envs
  Individual knowledge          Team-shared code
```

### Three key properties of IaC config

| Property | What it means | Manual equivalent |
|----------|---------------|-------------------|
| **Versioned** | Config is text files committed to Git. Full history of changes, who made them, and why. | ❌ No history — CLI commands are ephemeral |
| **Reusable** | Same config deployed to dev, staging, prod with different variables. Modules shared across projects. | ❌ Must re-enter CLI commands each time |
| **Shared** | Config is reviewed via pull requests. Team members collaborate on infrastructure code. | ❌ Knowledge lives in individuals' heads or stale docs |

### The IaC difference in practice

```hcl
# This file IS the infrastructure definition.
# It's in Git. It was code-reviewed. It deploys identically
# across environments. Anyone on the team can read it.
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```

vs.

```bash
# This CLI command ran once and left no trace of intent.
# No one knows who ran it or why, except the person who did.
aws ec2 create-vpc --cidr-block 10.0.0.0/16
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — IaC requires more manual steps | IaC **reduces** manual steps through automation. A single `terraform apply` replaces many CLI commands or console clicks. |
| B — IaC makes it harder to track changes | IaC **improves** change tracking via Git. Every change is recorded with author, timestamp, and diff — far better than manual CLI. |
| D — IaC eliminates need for cloud credentials | IaC still requires provider-specific credentials (AWS keys, Azure service principals, etc.) to authenticate with cloud APIs. |
| E — IaC is only suitable for small deployments | IaC **excels** at large, complex deployments. The larger the infrastructure, the more valuable IaC's automation, consistency, and version control become. |

## Manual vs IaC: Complete Comparison

| Criterion | Console / CLI | Infrastructure as Code |
|-----------|--------------|----------------------|
| **Config format** | Imperative commands | Declarative HCL/JSON |
| **Storage** | No persistent storage | Git repository |
| **Change history** | CloudTrail (opaque) | Git log (clear, searchable) |
| **Code review** | Not possible | Pull requests |
| **Testing** | Manual | `terraform plan`, `validate`, CI |
| **Reusability** | Copy-paste commands | Modules, variables, workspaces |
| **Automation** | Custom scripts | `terraform apply` in CI/CD |
| **Rollback** | Manual reverse | Git revert + `terraform apply` |
| **Team collaboration** | Share docs | Share code |
| **Audit trail** | API logs | Git + state history |
| **Drift detection** | None | `terraform plan` |
| **Disaster recovery** | Manual rebuild | `terraform apply` from Git |

## Objective Reference

This question tests the fundamental understanding of IaC vs manual infrastructure management — a core concept assessed in the Terraform Associate exam.
