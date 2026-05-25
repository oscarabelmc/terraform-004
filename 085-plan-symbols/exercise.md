# Plan Symbols Exercise

**Exam Question:** After executing a `terraform plan` in your working directory, you notice that a resource has a tilde (~) next to it. What does this indicate?

## Background

Terraform uses symbols in plan output to indicate the type of change each resource will undergo. Understanding these symbols is essential for reading plans correctly.

## Steps

### Part 1 — Examine the config

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The config uses a variable `instance_type` with default `t2.micro`.

### Part 2 — Run plan and see the symbols

2. **Apply, then modify and plan:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

3. **Change the instance type to see the ~ symbol:**

   Edit `main.tf` and change the instance type variable or override it:

   ```bash
   terraform plan -var="instance_type=t3.medium"
   ```

   Output:

   ```
   # aws_instance.web will be updated in-place
   ~ resource "aws_instance" "web" {
       id              = "i-0a1b2c3d"
       ~ instance_type = "t2.micro" -> "t3.medium"
       tags            = {
           "Name" = "plan-symbols-web"
       }
     }

   Plan: 0 to add, 1 to change, 0 to destroy.
   ```

   The tilde `~` next to the resource and the attribute means **update in-place**.

### Part 3 — All plan symbols

4. **Symbol reference:**

   | Symbol | Meaning | Example |
   |--------|---------|---------|
   | `+` | **Create** — new resource will be added | `+ resource "aws_vpc" "main"` |
   | `~` | **Update in-place** — resource modified without replacement | `~ instance_type = "t2" -> "t3"` |
   | `-` | **Destroy** — resource will be removed | `- resource "aws_subnet" "public"` |
   | `-/+` | **Replace** — destroy then recreate | `-/+ resource "aws_instance" "web"` |
   | `<=` | **Read** — data source being read | `<= data "aws_ami" "ubuntu"` |

5. **See the destroy symbol in action:**

   Remove the subnet block from `main.tf` and run plan:

   ```bash
   terraform plan
   ```

   Output:

   ```
   # aws_subnet.public will be destroyed
   - resource "aws_subnet" "public" {
       - cidr_block = "10.0.1.0/24" -> null
     }
   ```

6. **See the replace symbol in action:**

   Change a force-new attribute like `ami` or the VPC's `cidr_block`:

   ```bash
   terraform plan -var="instance_type=t3.medium" 2>/dev/null || true
   # Force-new attributes show -/+
   ```

   A replace `-/+` means Terraform will destroy the existing resource and create a new one.

### Part 4 — Why update in-place matters

7. **Update in-place (~) vs replace (-/+):**

   | Change type | Symbol | Downtime? | Risk |
   |------------|--------|-----------|------|
   | Update in-place | `~` | Usually none | Low — modifies existing resource |
   | Replace | `-/+` | Yes — destroy then create | High — resource is recreated |

   Recognizing `~` tells you the change is **safe** — existing resource attributes are modified without recreation.

### Put It Together

After executing a `terraform plan` in your working directory, you notice that a resource has a tilde (~) next to it. What does this indicate?

- A. The resource will be destroyed
- B. The resource will be updated in place
- C. The resource will be created
- D. The resource will be replaced (destroyed and recreated)
- E. The resource is being read from a data source

## Files

- `main.tf` — config for demonstrating plan symbols
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
