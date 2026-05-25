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
| 15 | VCS-driven workflow — code, PR, plan, approve | HCP Terraform | [015-vcs-workflow](./015-vcs-workflow) |
| 16 | `length()` function — count elements in a list | Functions | [016-length-function](./016-length-function) |
| 17 | Variable type errors — `list(string)` with `default = {}` | Input Variables | [017-variable-type-errors](./017-variable-type-errors) |
| 18 | Sensitive data in state — stored as plaintext despite `sensitive = true` | State Management | [018-sensitive-data-state](./018-sensitive-data-state) |
| 19 | Module version pinning — why include `version` argument | Modules | [019-module-version-pinning](./019-module-version-pinning) |
| 20 | Passing module outputs between modules — `module.<name>.<output>` | Modules | [020-module-output-passing](./020-module-output-passing) |
| 21 | Backend reconfiguration — `terraform init -reconfigure` | State Management | [021-backend-reconfigure](./021-backend-reconfigure) |
| 22 | Module installation — `terraform init` downloads modules | Modules | [022-terraform-init-modules](./022-terraform-init-modules) |
| 23 | Selective resource decommission — remove from config, then `apply` | IaC Workflow | [023-remove-resources](./023-remove-resources) |
| 24 | Import existing resources — write config + import blocks + `apply` | IaC Workflow | [024-import-existing-resources](./024-import-existing-resources) |
| 25 | Single tool for multi-cloud deployments | IaC Concepts | [025-multi-cloud-benefits](./025-multi-cloud-benefits) |
| 26 | State locking with remote backends | State Management | [026-state-locking](./026-state-locking) |
| 27 | `terraform init` in multi-directory environments | IaC Workflow | [027-terraform-init-multi-dir](./027-terraform-init-multi-dir) |
| 28 | Variable type `map(string)` for region to image ID lookup | Input Variables | [028-variable-type-map](./028-variable-type-map) |
| 29 | `terraform validate` — syntax, attribute names, types | IaC Workflow | [029-terraform-validate](./029-terraform-validate) |
| 30 | Implicit dependency from attribute reference | State & DAG Management | [030-implicit-dependency](./030-implicit-dependency) |
| 31 | Local vs remote state tradeoffs | State Management | [031-local-vs-remote-state](./031-local-vs-remote-state) |
| 32 | `TF_LOG` — detailed Terraform logging | Troubleshooting | [032-terraform-logging](./032-terraform-logging) |
| 33 | HCP Terraform local execution mode | HCP Terraform | [033-hcp-local-execution](./033-hcp-local-execution) |
| 34 | Multiple implicit dependencies | State & DAG Management | [034-implicit-dependency-two](./034-implicit-dependency-two) |
| 35 | `version` in module block is optional but recommended | Modules | [035-module-version-optional](./035-module-version-optional) |
| 36 | Private registry for org-only modules | HCP Terraform | [036-private-registry](./036-private-registry) |
| 37 | Variable validation error timing | Input Variables | [037-variable-validation](./037-variable-validation) |
| 38 | Resource attribute reference creates implicit dependency | State & DAG Management | [038-resource-reference](./038-resource-reference) |
| 39 | Purpose of `.terraform/` directory | IaC Workflow | [039-dot-terraform-directory](./039-dot-terraform-directory) |
| 40 | Missing module output — unsupported attribute error | Modules | [040-module-output-export](./040-module-output-export) |
| 41 | Public registry source format | Modules | [041-public-registry-source](./041-public-registry-source) |
| 42 | CLI-driven workflow in HCP Terraform | HCP Terraform | [042-cli-driven-workflow](./042-cli-driven-workflow) |
| 43 | Validation block — enforce exact instance count | Input Variables | [043-validation-exact-value](./043-validation-exact-value) |
| 44 | Why not commit `terraform.tfstate` to VCS | State Management | [044-state-no-vcs](./044-state-no-vcs) |
| 45 | Import blocks to adopt existing resources | IaC Workflow | [045-import-resources](./045-import-resources) |
| 46 | `alias` — duplicate provider configurations | IaC Workflow | [046-provider-alias](./046-provider-alias) |
| 47 | Advantages of Infrastructure as Code (select three) | IaC Concepts | [047-iac-advantages](./047-iac-advantages) |
| 48 | Multiple `.tf` files merged automatically | IaC Workflow | [048-multiple-tf-files](./048-multiple-tf-files) |
| 49 | Expose and pass module outputs between modules | Modules | [049-passing-outputs](./049-passing-outputs) |
| 50 | Data sources — read-only API queries | IaC Concepts | [050-data-sources](./050-data-sources) |
| 51 | Apply a saved plan file | IaC Workflow | [051-saved-plan-apply](./051-saved-plan-apply) |
| 52 | `required_providers` block | IaC Workflow | [052-required-providers](./052-required-providers) |
| 53 | `data` block — query existing resources | IaC Concepts | [053-data-block-query](./053-data-block-query) |
| 54 | Protect sensitive input values (select two) | Security | [054-sensitive-secrets](./054-sensitive-secrets) |
| 55 | Provider plugin storage location after `init` | IaC Workflow | [055-provider-plugins-location](./055-provider-plugins-location) |
| 56 | Declarative IaC vs imperative scripts | IaC Concepts | [056-iac-declarative](./056-iac-declarative) |
| 57 | Why Terraform requires state (select three) | State Management | [057-why-state](./057-why-state) |
| 58 | S3 partial backend configuration | State Management | [058-s3-backend-partial-config](./058-s3-backend-partial-config) |
| 59 | Provider version constraints | Modules | [059-provider-version-constraints](./059-provider-version-constraints) |
| 60 | How `terraform plan` determines changes | IaC Workflow | [060-plan-state-comparison](./060-plan-state-comparison) |
| 61 | Resource creation order via DAG | State & DAG Management | [061-resource-creation-order](./061-resource-creation-order) |
| 62 | Safe module version upgrade (select two) | Modules | [062-module-version-update](./062-module-version-update) |
| 63 | Config-driven import with `import` block | IaC Workflow | [063-config-driven-import](./063-config-driven-import) |
| 64 | Data source to reference existing VNet | IaC Concepts | [064-data-source-reference](./064-data-source-reference) |
| 65 | Multi-cloud benefits of Terraform (select two) | IaC Concepts | [065-multi-cloud-benefits](./065-multi-cloud-benefits) |
| 66 | Sensitive data and state best practices (select four) | Security | [066-sensitive-data-state-best-practices](./066-sensitive-data-state-best-practices) |
| 67 | Three core steps of Terraform workflow | IaC Workflow | [067-core-workflow](./067-core-workflow) |
| 68 | Advantages of IaC (select five) | IaC Concepts | [068-iac-advantages](./068-iac-advantages) |
| 69 | `terraform validate` — syntax without remote calls | IaC Workflow | [069-terraform-validate](./069-terraform-validate) |
| 70 | Actions during `terraform init` (select three) | IaC Workflow | [070-terraform-init](./070-terraform-init) |
| 71 | Terraform logging with `TF_LOG` | Troubleshooting | [071-terraform-logging](./071-terraform-logging) |
| 72 | HCP Terraform run tasks | HCP Terraform | [072-run-tasks](./072-run-tasks) |
| 73 | What `terraform plan` does against remote state | IaC Workflow | [073-terraform-plan-execution](./073-terraform-plan-execution) |
| 74 | Map variable bracket notation `["build-tag"]` | Input Variables | [074-map-variable-reference](./074-map-variable-reference) |
| 75 | HCP Terraform variable scopes (select three) | HCP Terraform | [075-hcp-variable-scopes](./075-hcp-variable-scopes) |
| 76 | IaC vs manual console/CLI — versioned, reusable, shared | IaC Concepts | [076-iac-vs-manual](./076-iac-vs-manual) |
| 77 | Module output reference `module.vpc.default_sg_id` | Modules | [077-module-output-reference](./077-module-output-reference) |
| 78 | Identify managed resources with `terraform state show` | State Management | [078-state-show-identify](./078-state-show-identify) |
| 79 | Postcondition in lifecycle block | IaC Workflow | [079-postcondition](./079-postcondition) |
| 80 | Primary reason to use `terraform import` | IaC Workflow | [080-terraform-import-reason](./080-terraform-import-reason) |
| 81 | Fastest syntax check after refactoring — `terraform validate` | IaC Workflow | [081-terraform-validate-refactor](./081-terraform-validate-refactor) |
| 82 | Child module variable isolation — no auto-inheritance | Modules | [082-module-variable-access](./082-module-variable-access) |
| 83 | `merge()` function — combine common + resource-specific tags | Functions | [083-merge-function-tags](./083-merge-function-tags) |
| 84 | State locking — not all remote backends support it by default | State Management | [084-state-locking-backends](./084-state-locking-backends) |
| 85 | Tilde (~) in plan means update in-place | IaC Workflow | [085-plan-symbols](./085-plan-symbols) |
| 86 | `sensitive = true` does not prevent state storage | Security | [086-sensitive-output-state](./086-sensitive-output-state) |
| 87 | HCP Terraform — one VCS repo per workspace | HCP Terraform | [087-hcp-vcs-mapping](./087-hcp-vcs-mapping) |

## Contributing

New exercises are welcome! Open a PR with:

- A numbered exercise directory (e.g., `003-*`)
- An `exercise.md` with clear steps
- Starter config files and a `solution/answer.md`
