# Answer

The correct answer is **A**.

> The `data` block queries AWS for the most recent AMI owned by the current account with a specific tag. This data can then be used within the Terraform configuration to reference the queried AMI for resource creation.

---

## Why A Is Correct

A `data` block is Terraform's mechanism for **reading** existing infrastructure:

```hcl
data "aws_ami" "btk-app" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:Owner"
    values = ["btk-platform"]
  }
}
```

This queries the AWS API for AMIs matching the criteria and returns attributes (like `id`, `name`, `architecture`) that can be used elsewhere:

```hcl
resource "aws_instance" "web" {
  ami           = data.aws_ami.btk-app.id  # ← using the fetched data
  instance_type = "m6g.xlarge"
}
```

Key characteristics:
- **Read-only** — does not create, modify, or destroy any infrastructure
- **Queries APIs** — fetches data from the provider at plan time
- **Returns attributes** — accessed as `data.<type>.<name>.<attribute>`
- **Integrates external data** — bridges Terraform with existing resources

## Why the Others Are Wrong

| Option | Construct | Purpose | Why Not Correct |
|--------|-----------|---------|----------------|
| B — Module | `module` block | Reusable package of resources | Modules contain/create resources. They don't query existing ones. |
| C — Locals | `locals` block | Define computed expressions | Locals are internal calculations, not API queries. |
| D — Provider | `provider` block | Configure provider connection | Provider configures auth/region, doesn't query data. |
| E — Resource | `resource` block | Create/manage infrastructure | Resources create/modify/destroy — they don't query existing. |

## Quick Reference

| Construct | Queries Existing? | Creates? | Use Case |
|-----------|------------------|----------|----------|
| `data` | ✅ | ❌ | Fetch AMI ID, VPC ID, existing bucket |
| `resource` | ❌ | ✅ | Create EC2, S3, VPC |
| `module` | ❌ | ✅ (contains resources) | Reusable component |
| `locals` | ❌ | ❌ | Local expression helpers |
| `provider` | ❌ | ❌ | Provider configuration |

## Exam Tips

- **Only `data` blocks** query existing infrastructure
- Data sources are referenced as `data.<type>.<name>.<attribute>`
- Common data source uses: AMI lookup, VPC lookup, caller identity, existing bucket
- Know the difference between `data` (read), `resource` (create/manage), `module` (package), `locals` (compute), and `provider` (configure)
- The question asks about "querying information about existing resources" — that's exclusively a `data` block
