# Implicit Dependencies — True or False Exercise

**Exam Question:** True or False? Terraform can only manage dependencies between resources if the `depends_on` argument is explicitly set for the dependent resources.

## Background

Terraform has **two** mechanisms for managing resource dependencies:

| Mechanism | How it works | Example |
|-----------|-------------|---------|
| **Implicit** (automatic) | Terraform detects references between resources | `instance = aws_instance.web.id` |
| **Explicit** (`depends_on`) | You manually declare a dependency | `depends_on = [aws_instance.web]` |

The statement claims Terraform **can only** manage dependencies via `depends_on` — this ignores implicit dependencies, which are the **primary** and **recommended** way to express dependencies.

## Steps

### Part 1 — Implicit dependencies (the default)

1. **Examine the config:**

   ```bash
   cat main.tf
   ```

   The config has two resources with a **reference** from one to the other:

   ```hcl
   resource "random_pet" "server" {
     length = 2
   }

   resource "local_file" "config" {
     content  = "Server: ${random_pet.server.id}"   # ← implicit dependency
     filename = "config.txt"
   }
   ```

   The `local_file.config` references `random_pet.server.id`. This creates an **implicit dependency**.

2. **Apply and observe the order:**

   ```bash
   terraform apply -auto-approve
   ```

   Output:

   ```
   random_pet.server: Creating...
   random_pet.server: Creation complete after 0s
   local_file.config: Creating...         ← created AFTER the pet
   local_file.config: Creation complete after 0s
   ```

   Terraform automatically ordered them correctly — no `depends_on` needed.

### Part 2 — Explicit dependencies with `depends_on`

3. **Sometimes you need `depends_on`:**

   When there's **no attribute reference** but an ordering requirement exists:

   ```hcl
   resource "aws_instance" "web" {
     # No reference to the S3 bucket, but we need it created first
   }

   resource "aws_s3_bucket" "logs" {
     # Must exist before the instance sends logs
   }
   ```

   Without a cross-reference, Terraform might create them in parallel. To enforce order:

   ```hcl
   resource "aws_instance" "web" {
     depends_on = [aws_s3_bucket.logs]   # ← explicit dependency
     # ...
   }
   ```

### Part 3 — The dependency graph

4. **Terraform builds a dependency graph from both mechanisms:**

   ```
   Config                           Dependency Graph
   ┌──────────────────────┐        ┌────────────────────┐
   │ random_pet.server    │        │ random_pet.server  │
   │   length = 2         │        │         │          │
   └──────────────────────┘        │   implicit ref     │
          │                        │         │          │
          │ reference              ▼         ▼          │
          ▼                       ┌────────────────────┐│
   ┌──────────────────────┐        │ local_file.config  ││
   │ local_file.config    │        │   ↑ depends_on?    ││
   │ content = server.id  │        │   No — implicit!  ││
   └──────────────────────┘        └────────────────────┘
   ```

   Implicit dependencies are automatically added to the graph. `depends_on` adds **additional** edges that cannot be inferred.

### Part 4 — When `depends_on` is necessary

5. **Scenarios requiring explicit `depends_on`:**

   | Scenario | Example |
   |----------|---------|
   | **No attribute reference** | Resource A must exist before B, but B has no attribute reference to A |
   | **Provisioner ordering** | A `file` provisioner needs a resource to exist before another is created |
   | **Destroy ordering** | Override default destroy order (reverse of create) |
   | **Indirect dependency** | A depends on C through B, but only A and C are in config |

### Put It Together

True or False? Terraform can only manage dependencies between resources if the `depends_on` argument is explicitly set for the dependent resources.

- A. True
- B. False

## Files

- `main.tf` — config demonstrating implicit dependency via attribute reference
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
