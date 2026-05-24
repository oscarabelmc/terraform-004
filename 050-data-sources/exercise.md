# Terraform Data Sources Exercise

**Exam Question:** Which statement best describes a Terraform data source?

## Background

Terraform has two primary block types for interacting with infrastructure:

| Block Type | Purpose | State Impact |
|------------|---------|-------------|
| `resource` | Creates, updates, or destroys infrastructure | ✅ Writes to state |
| `data` (data source) | Reads existing infrastructure or computes values | Reads from state only |

A **data source** queries a provider API to fetch information about resources that exist outside of Terraform (or were created by another Terraform config). It does **not** create or manage infrastructure.

## Steps

### Part 1 — Examine a data source

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   A `data "aws_ami" "ubuntu"` block queries AWS for the latest Ubuntu AMI. This AMI already exists in AWS — Terraform is just reading its attributes.

### Part 2 — Compare resource vs data

2. **Look at the difference:**

   ```hcl
   # Resource: creates/manages infrastructure
   resource "aws_instance" "web" {
     ami           = data.aws_ami.ubuntu.id
     instance_type = "t2.micro"
   }

   # Data source: reads existing infrastructure
   data "aws_ami" "ubuntu" {
     most_recent = true
     owners      = ["099720109477"]

     filter {
       name   = "name"
       values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
     }
   }
   ```

   - `data` block reads from AWS API — no resource created
   - `resource` block uses the data to create an instance

### Part 3 — Reference data source attributes

3. **Data sources are referenced as `data.<type>.<name>.<attribute>`:**

   ```bash
   terraform init
   terraform plan
   ```

   The plan shows:
   - Data source reads the AMI ID (known at plan time)
   - Instance uses that AMI ID (known after data read)

### Part 4 — Common data source use cases

4. **Fetching existing infrastructure:**

   ```hcl
   data "aws_vpc" "default" {
     default = true
   }

   data "aws_subnets" "default" {
     filter {
       name   = "vpc-id"
       values = [data.aws_vpc.default.id]
     }
   }

   resource "aws_instance" "web" {
     subnet_id = data.aws_subnets.default.ids[0]
     ami       = data.aws_ami.ubuntu.id
   }
   ```

### Part 5 — Data sources vs modules vs caches

5. **Compare the concepts:**

   | Concept | Purpose | Example |
   |---------|---------|---------|
   | **Data source** | Read-only API query | `data.aws_ami.ubuntu.id` |
   | **Module** | Reusable package of resources | `module "vpc" { source = "./vpc" }` |
   | **Cache** | Store computed values between runs | No Terraform equivalent |

### Put It Together

Which statement best describes a Terraform data source?

- A. A read-only construct that queries provider APIs and returns attributes for use elsewhere in the configuration
- B. A local cache that stores computed values between runs to speed up `terraform apply`
- C. A reusable package that defines multiple resources and outputs to be instantiated by other configurations
- D. A mechanism for persisting variable defaults into state so they can be reused by other workspaces

## Files

- `main.tf` — data source + resource using the fetched data
- `outputs.tf` — output values from data source
- `solution/answer.md` — explanation and exam tips
