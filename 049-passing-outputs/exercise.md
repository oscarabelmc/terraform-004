# Passing Module Outputs Exercise

**Exam Question:** You're invoking a module that creates a subnet. The root load balancer module requires that subnet's ID. How should you expose the ID and pass it to the load balancer module?

```hcl
# modules/subnets/main.tf
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "outputs-subnet"
  }
}
```

## Background

Module internals are **private** — resources created inside a module cannot be directly referenced from outside that module. To pass values between modules, the source module must **export** them via `output` blocks, and the root module passes them as **inputs** to the destination module.

## Steps

### Part 1 — Examine the broken state

1. **Open `main.tf` (root module):**

   ```bash
   cat main.tf
   ```

   The root module calls two children: `subnets` and `load_balancer`. The load balancer needs the subnet ID, but the subnet module doesn't export it.

2. **Examine the subnet module:**

   ```bash
   cat modules/subnets/main.tf
   ```

   No `output` block — the subnet ID is trapped inside the module.

### Part 2 — Examine the load balancer module

3. **Open the load balancer module:**

   ```bash
   cat modules/load_balancer/variables.tf
   ```

   It expects a `subnet_id` input variable. But nothing provides it.

### Part 3 — Fix by adding an output to the subnet module

4. **Add an output block to `modules/subnets/outputs.tf`:**

   ```hcl
   output "subnet_id" {
     description = "The ID of the created subnet"
     value       = aws_subnet.main.id
   }
   ```

5. **Reference the output in the root module:**

   In `main.tf`, pass the subnet module's output to the load balancer:

   ```hcl
   module "load_balancer" {
     source    = "./modules/load_balancer"
     subnet_id = module.subnets.subnet_id
   }
   ```

### Part 4 — Verify the data flow

6. **Initialize and validate:**

   ```bash
   terraform init
   terraform validate
   ```

   No errors. The data flows correctly:

   ```
   module.subnets
     ├── aws_subnet.main.id  (internal)
     └── output "subnet_id"  →  module.subnets.subnet_id
                                     │
                                     ▼
   module.load_balancer
     └── variable "subnet_id"  =  module.subnets.subnet_id
   ```

### Part 5 — Test with a plan

7. **Run plan:**

   ```bash
   terraform plan
   ```

   The plan shows subnet creation first, then load balancer — Terraform correctly orders them based on the implicit dependency created by the output reference.

### Put It Together

You're invoking a module that creates a subnet. The root load balancer module requires that subnet's ID. How should you expose the ID and pass it to the load balancer module?

- A. Add an output block to the subnet module and pass the value to the load balancer module using `module.subnets.subnet_id`
- B. Reference the resource directly in the load balancer module: `aws_subnet.main.id`
- C. Hardcode the subnet ID in the load balancer module's configuration
- D. Use `terraform output` to capture the subnet ID and pass it as an environment variable
- E. Create a data source in the load balancer module to look up the subnet

## Files

- `main.tf` — root module calling both subnets and load_balancer
- `modules/subnets/main.tf` — subnet resource (missing output initially)
- `modules/subnets/variables.tf` — subnet module inputs
- `modules/subnets/outputs.tf` — **the fix**: exports subnet_id
- `modules/load_balancer/main.tf` — load balancer resource
- `modules/load_balancer/variables.tf` — expects subnet_id input
- `solution/answer.md` — explanation and exam tips
