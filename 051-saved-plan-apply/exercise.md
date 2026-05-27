# Saved Plan — Apply Exercise

**Exam Question:** Your team's change management process requires that all Terraform changes be reviewed and approved before execution. You run `terraform plan -out=saved-plan.tfplan` and send the output for review. After approval is granted two hours later, what command should you run to execute the exact changes that were reviewed?

## Background

Terraform plans can be **saved to a file** with the `-out` flag. This captures the exact set of changes — resource actions, ordering, and all computed values — in a binary file. Applying the saved plan guarantees that **exactly** the reviewed changes are executed, even if the infrastructure has drifted or configuration has changed in the meantime.

## Steps

### Part 1 — Generate a saved plan

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

2. **Initialize:**

   ```bash
   terraform init
   ```

3. **Generate a saved plan:**

   ```bash
   terraform plan -out=saved-plan.tfplan
   ```

   This creates a binary plan file:

   ```bash
   ls -la saved-plan.tfplan
   ```

### Part 2 — Review the plan (simulated)

4. **View the plan for review:**

   ```bash
   terraform show saved-plan.tfplan
   ```

   You can share this output with your team for approval. The `tfplan` file itself can also be inspected later.

### Part 3 — Apply the exact reviewed plan

5. **After approval, apply the saved plan:**

   ```bash
   terraform apply saved-plan.tfplan
   ```

   Terraform uses the **exact** plan saved earlier — it doesn't re-evaluate the configuration or state. This ensures the applied changes match what was reviewed.

### Part 4 — Understand why saved plans are used

6. **Why not just run `terraform apply` without a saved plan?**

   Without `-out`, `terraform apply` runs a **new plan** during the apply command. If the infrastructure or config has drifted in the two hours since review, the new plan could differ from what was approved.

   ```bash
   # WITHOUT saved plan — risks executing unapproved changes:
   terraform apply  # ← generates a fresh plan at apply time
   ```

   With a saved plan:

   ```bash
   # WITH saved plan — guaranteed to match what was reviewed:
   terraform plan -out=plan.tfplan  # ← reviewed content
   terraform apply plan.tfplan      # ← executes exact same content
   ```

### Put It Together

Your team's change management process requires that all Terraform changes be reviewed and approved before execution. You run `terraform plan -out=saved-plan.tfplan` and send the output for review. After approval is granted two hours later, what command should you run to execute the exact changes that were reviewed?

- A. `terraform apply saved-plan.tfplan`
- B. `terraform apply`
- C. `terraform plan -out=saved-plan.tfplan` again, then `terraform apply`
- D. `terraform apply -auto-approve saved-plan.tfplan`
- E. `terraform init && terraform apply`

## Files

- `main.tf` — simple config for plan-apply workflow
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
