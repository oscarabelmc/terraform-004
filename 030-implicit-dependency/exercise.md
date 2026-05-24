# Implicit vs Explicit Dependency Exercise

**Exam Question:** Your colleague provided the code snippet below and is looking for assistance in identifying the implicit dependency. What is the implicit dependency in this code?

```hcl
resource "aws_eip" "public_ip" {
    vpc      = true
    instance = aws_instance.web_server.id
}

resource "aws_instance" "web_server" {
  ami           = "ami-502b7f631"
  instance_type = "t2.micro"
  depends_on    = [aws_s3_bucket.company_data]
}
```

## Background

Terraform builds a **dependency graph** from two types of dependencies:

| Dependency | How It's Created | Example |
|------------|-----------------|---------|
| **Implicit** | Attribute reference: `resource_type.name.attribute` | `aws_eip` references `aws_instance.web_server.id` |
| **Explicit** | `depends_on` meta-argument | `depends_on = [aws_s3_bucket.company_data]` |

Terraform uses this graph to determine:
- **Creation order** — dependencies are created first
- **Parallelism** — resources with no dependency chain can run in parallel
- **Destroy order** — dependencies are destroyed in reverse order

## Steps

### Part 1 — Read the config

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The config has three resources:
   - `aws_s3_bucket.company_data`
   - `aws_instance.web_server` (explicitly depends on S3 bucket)
   - `aws_eip.public_ip` (implicitly depends on EC2 instance)

### Part 2 — Trace the implicit dependency

2. **Look at the Elastic IP resource:**

   ```hcl
   resource "aws_eip" "public_ip" {
     vpc      = true
     instance = aws_instance.web_server.id
   }
   ```

   The attribute reference `aws_instance.web_server.id` creates an **implicit** dependency. Terraform knows: "I must create `aws_instance.web_server` before I can create `aws_eip.public_ip`."

### Part 3 — Trace the explicit dependency

3. **Look at the EC2 instance resource:**

   ```hcl
   resource "aws_instance" "web_server" {
     ami           = "ami-502b7f631"
     instance_type = "t2.micro"
     depends_on    = [aws_s3_bucket.company_data]
   }
   ```

   The `depends_on` meta-argument creates an **explicit** dependency. Terraform knows: "I must create `aws_s3_bucket.company_data` before I can create `aws_instance.web_server`."

### Part 4 — Understand the resulting dependency graph

4. **Generate the dependency graph:**

   ```bash
   terraform init
   terraform graph | dot -Tsvg > graph.svg
   ```

   The graph shows the order:
   ```
   aws_s3_bucket.company_data
         ↓
   aws_instance.web_server
         ↓
   aws_eip.public_ip
   ```

### Put It Together

Your colleague provided the code snippet below. What is the **implicit** dependency in this code?

```hcl
resource "aws_eip" "public_ip" {
    vpc      = true
    instance = aws_instance.web_server.id
}

resource "aws_instance" "web_server" {
  ami           = "ami-502b7f631"
  instance_type = "t2.micro"
  depends_on    = [aws_s3_bucket.company_data]
}
```

- A. `aws_s3_bucket.company_data`
- B. `aws_instance.web_server`
- C. `aws_eip.public_ip`
- D. There is no implicit dependency

## Files

- `main.tf` — configuration with both implicit and explicit dependencies
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
