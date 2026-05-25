# Answer

The correct answers are **A**, **C**, **D**, **E**, and **F**.

> **A.** Infrastructure as Code gives the user the ability to recreate an application's infrastructure for disaster recovery scenarios.
>
> **C.** Infrastructure as Code provides configuration consistency and standardization among deployments.
>
> **D.** Infrastructure as Code enables users to automate a manual task for easier deployment.
>
> **E.** Infrastructure as Code is easily repeatable, allowing the user to reuse code to deploy similar yet different resources.
>
> **F.** Infrastructure as Code is relatively easy to learn and write, regardless of a user's prior coding experience.

---

## Why A, C, D, E, and F Are Correct

### A — Disaster recovery

With IaC, the entire infrastructure is defined in code. Recovering from a disaster means:

```bash
git clone <repo>
terraform apply   # Reproduces exact infrastructure
```

No manual re-creation, no risk of missing a configuration step.

### C — Consistency and standardization

IaC ensures every deployment produces identical infrastructure:

```
Dev:   terraform apply -var="environment=dev"
Staging: terraform apply -var="environment=staging"
Prod:  terraform apply -var="environment=prod"
```

Same code → same infrastructure. No configuration drift between environments.

### D — Automation

Manual infrastructure tasks (clicking through a console, running 15 CLI commands in order) are replaced with a single command:

```bash
# Before (manual): 15+ clicks in AWS console
# After (IaC):     one command
terraform apply
```

### E — Repeatability and reuse

Code can be reused across environments, regions, and projects:

```hcl
module "networking" {
  source = "./modules/networking"
  env    = var.environment
}
```

Once written, the same module deploys similar infrastructure with different inputs.

### F — Easy to learn

HCL is a declarative language designed for readability:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-abc"
  instance_type = "t2.micro"
}
```

Operators, sysadmins, and developers can all read and write IaC without deep programming expertise.

## Why the Incorrect Option Is Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — Replaces programming languages like Go and .NET | IaC is for **infrastructure provisioning**, not application development. HCL cannot replace general-purpose programming languages. IaC and application code serve different purposes and coexist in a project. |

## Summary of IaC Advantages

| Advantage | What it means |
|-----------|---------------|
| **Consistency** | Identical infrastructure every deployment |
| **Repeatability** | Reuse code across environments/projects |
| **Automation** | Manual tasks replaced by `terraform apply` |
| **Disaster recovery** | Rebuild infrastructure from code |
| **Version control** | Full change history via Git |
| **Collaboration** | Code review, pull requests, team workflows |
| **Documentation** | Code is self-documenting (single source of truth) |
| **Easy to learn** | HCL is human-readable, accessible to non-programmers |
| **Cost savings** | Right-size resources, avoid over-provisioning |

## Objective Reference

**Objective 1b** — Describe the advantages of IaC patterns.

Key advantages:
- Consistency and repeatability
- Speed and agility (automation)
- Version control and change tracking
- Collaboration and documentation
- Cost savings
- Disaster recovery

## Exam Tips

- IaC advantages: **consistent, repeatable, automated, recoverable, accessible**
- IaC does **not** replace application programming languages
- IaC is declarative (desired state), not imperative (step-by-step)
- Code review, Git history, and team collaboration are key IaC benefits
- Common exam trap: thinking IaC replaces application code (it manages infrastructure, not applications)
- Another trap: overlooking disaster recovery as an IaC advantage (code-defined infra is fully recoverable)
