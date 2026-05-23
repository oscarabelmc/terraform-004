# Terraform Language Exercise

**Exam Question:** Which of the following statements is the most accurate about the Terraform language?

## Background

Understanding how Terraform describes infrastructure is foundational to the exam. The correct answer defines three key characteristics: **immutability**, **declarative** syntax, and **HCL or JSON** support.

## Steps

### Part 1 — Declarative (what, not how)

1. **Inspect `main.tf`:**

   ```bash
   cat main.tf
   ```

   The config declares **what** the end state should be:
   - A random pet with prefix "web" and length 2
   - A file with specific content

   There are no `if` statements, no `for` loops, no step-by-step instructions — Terraform determines **how** to reach this state automatically.

   Contrast this with a procedural bash script that would need explicit steps:
   ```bash
   # Procedural: step-by-step instructions
   PET_NAME=$(random-pet --prefix web --length 2)
   echo "Server: $PET_NAME" > /tmp/info.txt
   ```

### Part 2 — Immutability

2. **Apply the config:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

3. **Change the resource configuration — edit `main.tf`:**

   Change `length = 2` to `length = 4`.

4. **Run `terraform plan`:**

   ```bash
   terraform plan
   ```

   Notice the plan shows `-/+` (destroy + create) for `random_pet.server` — this is **immutable** behavior. Terraform replaces the resource rather than modifying it in place. The `create_before_destroy` lifecycle ensures the new one is created before the old one is destroyed.

5. **Restore `length = 2`** before continuing.

### Part 3 — HCL and JSON

6. **Compare the two syntax options:**

   ```bash
   cat main.tf.json
   ```

   This is the **exact same configuration** expressed in JSON instead of HCL. Terraform accepts both formats interchangeably.

7. **Validate that JSON works:**

   ```bash
   terraform validate
   ```

   Terraform reads both `.tf` and `.tf.json` files in the directory.

### Put It Together

Which of the following statements is the most accurate about the Terraform language?

- A. Terraform is an immutable, declarative Infrastructure as Code language based on HashiCorp Configuration Language or JSON.
- B. Terraform is a mutable, procedural scripting language for infrastructure management.
- C. Terraform is a declarative Infrastructure as Code language that only supports HashiCorp Configuration Language.
- D. Terraform is an immutable, imperative programming language based on JSON.

## Files
- `main.tf` — HCL syntax
- `main.tf.json` — JSON equivalent of the same config
- `solution/answer.md` — explanation and exam tips
