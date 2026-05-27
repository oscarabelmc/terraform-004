# Multiple Implicit Dependencies Exercise

**Exam Question:** True or False? In the configuration below, the `aws_volume_attachment.attach_data` resource has an implicit dependency on both the instance and the volume.

```hcl
resource "aws_instance" "app_core" {
  ami               = "ami-0c55b159cbfafe1f0"
  instance_type     = "t3.micro"
  availability_zone = "ca-central-1a"

  tags = { Owner = "implicit-team", Env = "pr0d-east" }
}

resource "aws_ebs_volume" "data_pr0d_east" {
  availability_zone = "ca-central-1a"
  size              = 10
}

resource "aws_volume_attachment" "attach_data" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.data_pr0d_east.id
  instance_id = aws_instance.app_core.id
}
```

## Background

A resource can have **multiple implicit dependencies** — every attribute reference to another resource's attribute creates a separate implicit dependency. Terraform builds the full dependency graph from all attribute references combined.

## Steps

### Part 1 — Examine the config

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   Three resources: an EC2 instance, an EBS volume, and a volume attachment.

### Part 2 — Trace each attribute reference

2. **Look at the volume attachment resource:**

   ```hcl
   resource "aws_volume_attachment" "attach_data" {
     device_name = "/dev/xvdf"
     volume_id   = aws_ebs_volume.data_pr0d_east.id
     instance_id = aws_instance.app_core.id
   }
   ```

   Two attribute references, two implicit dependencies:

   | Reference | Implicit Dependency |
   |-----------|-------------------|
   | `aws_ebs_volume.data_pr0d_east.id` | `aws_ebs_volume.data_pr0d_east` |
   | `aws_instance.app_core.id` | `aws_instance.app_core` |

### Part 3 — Visualize the dependency graph

3. **Generate the graph:**

   ```bash
   terraform init
   terraform graph | dot -Tsvg > graph.svg
   ```

   The graph shows:
   ```
   aws_instance.app_core ──────┐
                               ├──→ aws_volume_attachment.attach_data
   aws_ebs_volume.data       ──┘
   ```

   Both `app_core` and `data_pr0d_east` must be created **before** `attach_data`.

### Part 4 — Verify the dependency count

4. **Check `terraform plan` output:**

   ```bash
   terraform plan
   ```

   The plan shows the creation order: the instance and volume are planned before the attachment. Terraform knows it can create the instance and volume **in parallel** (no dependency between them), but must create the attachment **last**.

### Put It Together

True or False? The `aws_volume_attachment.attach_data` resource has an implicit dependency on **both** the instance and the volume.

```hcl
resource "aws_instance" "app_core" {
  ami               = "ami-0c55b159cbfafe1f0"
  instance_type     = "t3.micro"
  availability_zone = "ca-central-1a"

  tags = { Owner = "implicit-team", Env = "pr0d-east" }
}

resource "aws_ebs_volume" "data_pr0d_east" {
  availability_zone = "ca-central-1a"
  size              = 10
}

resource "aws_volume_attachment" "attach_data" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.data_pr0d_east.id
  instance_id = aws_instance.app_core.id
}
```

- A. True
- B. False

## Files

- `main.tf` — config with multiple implicit dependencies
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
