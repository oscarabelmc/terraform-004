# Module Output Export Exercise

**Exam Question:** You are calling a child module named `network` from your root module. In your root module, you attempt to reference the VPC ID as displayed below. When you run `terraform plan`, Terraform returns an error that `vpc_id` is not a valid attribute for `module.network`. What is the most likely cause of this error?

```hcl
resource "aws_subnet" "primary_core" {
  vpc_id     = module.network.vpc_id
  cidr_block = "10.5.0.0/23"
}
```

## Background

In Terraform, a **child module's resources are private** — the root module cannot access them directly. Only values that the child module **explicitly exports** via `output` blocks are accessible from outside the module.

```
Root Module
├── module "network" { ... }         ← Can only access module.network.<output_name>
│                                     NOT module.network.aws_vpc.main.id
└── resource "aws_subnet" "primary_core"
```

## Steps

### Part 1 — Examine the broken config

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The root module references `module.network.vpc_id`, but the network module may not expose that value.

2. **Open the network module:**

   ```bash
   cat modules/network/main.tf
   ```

   The module creates an `aws_vpc` resource but has **no output block** to export its ID.

### Part 2 — Reproduce the error

3. **Initialize and plan:**

   ```bash
   terraform init
   terraform plan
   ```

   Expected error:

   ```
   │ Error: Unsupported attribute
   │
   │   on main.tf line 13, in resource "aws_subnet" "primary_core":
   │   13:   vpc_id = module.network.vpc_id
   │     ├────────────────
   │     │ module.network is a object, known only after apply
   │
   │ This object does not have an attribute named "vpc_id".
   ```

### Part 3 — Fix by adding an output block

4. **Edit `modules/network/outputs.tf`** to export the VPC ID:

   ```hcl
   output "vpc_id" {
     value = aws_vpc.main.id
   }
   ```

5. **Re-plan:**

   ```bash
   terraform plan
   ```

   The error is resolved. The root module can now access `module.network.vpc_id`.

### Part 4 — Understand the access boundary

6. **Attempt to access a resource directly (will fail):**

   If you tried `module.network.aws_vpc.main.id` in the root module, Terraform would also error. Module internals are **never** accessible from outside — only `output` blocks create the public interface.

### Part 5 — Multiple outputs

7. **Examine the complete module interface:**

   ```bash
   cat modules/network/outputs.tf
   ```

   The module exports the VPC ID, CIDR, and public subnets — each value that the root module needs must have its own output block.

### Put It Together

You are calling a child module named `network` from your root module. In your root module, you attempt to reference the VPC ID as `module.network.vpc_id`. When you run `terraform plan`, Terraform returns an error that `vpc_id` is not a valid attribute for `module.network`. What is the most likely cause of this error?

- A. The network module did not define an output block that exports the VPC ID
- B. The VPC resource does not have an `id` attribute
- C. The root module must use `depends_on` before accessing module outputs
- D. The module source is incorrect and cannot be downloaded
- E. The `module.network` block needs a `version` argument

## Files

- `main.tf` — root module referencing `module.network.vpc_id`
- `modules/network/main.tf` — network module (missing output initially)
- `modules/network/variables.tf` — module inputs
- `modules/network/outputs.tf` — **fixed version** with output blocks
- `solution/answer.md` — explanation and exam tips
