# Explanation

The correct answer is **A**.

> It provides a common workflow and reusable modules, enabling consistent CI/CD and policy across clouds.

---

## Why A Is Correct

### Common Workflow

Terraform uses the same **init → plan → apply** workflow regardless of the target cloud:

| Step | Command | Purpose |
|------|---------|---------|
| Initialize | `terraform init` | Downloads all provider plugins + modules |
| Validate | `terraform validate` | Checks HCL syntax across all providers |
| Plan | `terraform plan` | Shows changes for all clouds in one output |
| Apply | `terraform apply` | Executes changes across all clouds |

No matter whether you're deploying to AWS, Azure, or GCP, the commands are identical — reducing cognitive overhead and training requirements.

### Reusable Modules

Modules written in HCL can be reused across providers as long as they only use Terraform's built-in functions:

```hcl
# modules/naming/main.tf — works for ANY cloud
resource "random_pet" "this" {
  prefix = var.prefix
  length = 2
}

locals {
  name = "${var.prefix}-${var.env}-${random_pet.this.id}"
}
```

The same module is called for each environment with different inputs:

```hcl
module "aws_naming" {
  source = "./modules/naming"
  prefix = "prod"
}

module "azure_naming" {
  source = "./modules/naming"
  prefix = "prod"
}
```

### Consistent CI/CD

A single CI/CD pipeline can handle multiple clouds:

```yaml
# Same pipeline for any cloud
steps:
  - run: terraform init
  - run: terraform validate
  - run: terraform plan
  - run: terraform apply
```

Compare this to maintaining separate pipelines for CloudFormation (AWS), ARM templates (Azure), and Deployment Manager (GCP) — each with its own CLI, syntax, and approval workflow.

### Consistent Policy Enforcement

With tools like Sentinel or OPA, a single policy-as-code framework can enforce rules across all clouds:

```rego
# One policy: enforce tags on ALL clouds
deny[msg] {
  resource := input.resource_changes[_]
  not resource.change.after.tags
  msg := sprintf("All resources must have tags: %v", [resource.address])
}
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — Automatically syncs resources between clouds | Terraform does not automatically sync resources between clouds. You must define resources explicitly for each provider. |
| C — Eliminates the need for cloud provider expertise | You still need to understand each cloud's services, quotas, and limitations. Terraform abstracts the workflow, not the cloud-specific concepts. |
| D — Runs faster than cloud-native tools | Performance depends on API latency, number of resources, and provider efficiency. Terraform is not inherently faster. |
| E — Requires fewer lines of code than any cloud-native template | Line count varies by resource complexity. Terraform is often more concise, but this is not the primary benefit of a single tool for multi-cloud. |
