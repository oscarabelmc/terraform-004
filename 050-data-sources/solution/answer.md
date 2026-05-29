# Explanation

The correct answer is **A**.

> A read-only construct that queries provider APIs and returns attributes for use elsewhere in the configuration.

---

## Why A Is Correct

A **data source** is defined with a `data` block and has these characteristics:

| Characteristic | Description |
|---------------|-------------|
| **Read-only** | Does not create, modify, or destroy infrastructure |
| **Queries APIs** | Makes API calls to the provider (AWS, Azure, GCP, etc.) |
| **Returns attributes** | Exposes the fetched data as attributes |
| **Used elsewhere** | Referenced as `data.<type>.<name>.<attribute>` |

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}
```

### Data Source Lifecycle

```
terraform plan / apply
        │
        ▼
  data "aws_ami" "ubuntu" {  ← queries AWS API
    most_recent = true
  }
        │
        ▼
  Returns: ami-0c55b159cbfafe1f0  ← known at plan time
        │
        ▼
  resource "aws_instance" "web" {
    ami = data.aws_ami.ubuntu.id  ← uses fetched value
  }
```

## Data Source vs Resource vs Module

| Aspect | Data Source (`data`) | Resource (`resource`) | Module (`module`) |
|--------|---------------------|----------------------|-------------------|
| Creates infrastructure? | ❌ | ✅ | ✅ (contains resources) |
| Reads existing infra? | ✅ | ❌ | ❌ |
| Writes to state? | ❌ (reads only) | ✅ | ✅ (via contained resources) |
| Reusable package? | ❌ | ❌ | ✅ |
| Example | `data.aws_ami.ubuntu` | `aws_instance.web` | `module "vpc" { ... }` |

## Why the Others Are Wrong

| Option | What It Describes | Why Incorrect for Data Source |
|--------|------------------|------------------------------|
| B — Local cache storing values between runs | **Not a real Terraform concept** | Terraform doesn't cache data source results between runs. Each plan/apply re-queries the API. |
| C — Reusable package with resources and outputs | **Module** | Modules package resources, variables, and outputs. Data sources are individual queries, not reusable packages. |
| D — Persisting variable defaults into state | **Not a real Terraform concept** | Variable defaults are defined in `variable` blocks, not persisted via data sources. |

## Common Data Source Use Cases

| Use Case | Example |
|----------|---------|
| **Look up latest AMI** | `data.aws_ami.ubuntu { ... }` |
| **Get default VPC** | `data.aws_vpc.default { default = true }` |
| **List subnets in VPC** | `data.aws_subnets.all { filter { ... } }` |
| **Read existing S3 bucket** | `data.aws_s3_bucket.existing { bucket = "..." }` |
| **Get current caller identity** | `data.aws_caller_identity.current` |
| **Read secret from vault** | `data.vault_generic_secret.db { path = "..." }` |

## Data Source Reference Syntax

```hcl
# Accessing data source attributes
data.<PROVIDER_TYPE>.<NAME>.<ATTRIBUTE>

# Examples:
data.aws_ami.ubuntu.id
data.aws_vpc.default.cidr_block
data.aws_subnets.all.ids
data.aws_caller_identity.current.account_id
data.aws_region.current.name
```
