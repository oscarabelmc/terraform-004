# Terraform Associate 004 — Practice Exercises

A curated set of hands-on exercises designed to help you prepare for the **HashiCorp Terraform Associate (003/004)** certification exam.

Each exercise presents a real-world scenario that tests your understanding of core Terraform concepts, workflows, and troubleshooting.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5 installed
- A cloud provider account (AWS, Azure, or GCP) — varies by exercise

## How to Use

```bash
git clone https://github.com/oscarabelmc/terraform-004.git
cd terraform-004/<exercise-directory>
terraform init
terraform plan
```

Each exercise directory contains:

| File | Purpose |
|------|---------|
| `exercise.md` | The problem statement and step-by-step instructions |
| `main.tf` | Starter Terraform configuration |
| `variables.tf` | Input variable declarations |
| `outputs.tf` | Output value definitions |
| `solution/answer.md` | Explanation and exam tips (peek when stuck) |

## Exercises

| # | Concept | Domain | Directory |
|---|---------|--------|-----------|
| 1 | Provider initialization — `terraform init` | Infrastructure as Code (IaC) Workflow | [001-provider-initialization](./001-provider-initialization) |
| 2 | Dependency graph — resource ordering & parallelism | State & DAG Management | [002-dependency-graph](./002-dependency-graph) |
| 3 | Provider dependencies — three ways to establish | IaC Workflow | [003-provider-dependencies](./003-provider-dependencies) |
| 4 | Environment variable prefix — `TF_VAR_` | Input Variables | [004-env-var-prefix](./004-env-var-prefix) |
| 5 | Format all config files — `terraform fmt -recursive` | IaC Workflow | [005-terraform-fmt](./005-terraform-fmt) |
| 6 | Delete `terraform.tfstate` — resources become orphaned | State Management | [006-state-file-deletion](./006-state-file-deletion) |
| 7 | Run triggers — auto-queue downstream runs after apply | HCP Terraform | [007-run-triggers](./007-run-triggers) |
| 8 | Preview state drift without making changes | State Management | [008-refresh-only-plan](./008-refresh-only-plan) |
| 9 | Terraform language — immutable, declarative, HCL/JSON | IaC Concepts | [009-terraform-language](./009-terraform-language) |
| 10 | `terraform plan` as a review artifact before deployment | IaC Workflow | [010-terraform-plan-review](./010-terraform-plan-review) |
| 11 | `terraform show` vs `terraform state show` | State Management | [011-terraform-show-commands](./011-terraform-show-commands) |
| 12 | What is "drift" in the context of state? | State Management | [012-state-drift](./012-state-drift) |
| 13 | Module input variables — `name`, `cidr`, `azs` as module arguments | Modules | [013-module-inputs](./013-module-inputs) |
| 14 | `terraform destroy` prompts for confirmation by default | IaC Workflow | [014-terraform-destroy-confirm](./014-terraform-destroy-confirm) |

## Contributing

New exercises are welcome! Open a PR with:

- A numbered exercise directory (e.g., `003-*`)
- An `exercise.md` with clear steps
- Starter config files and a `solution/answer.md`
