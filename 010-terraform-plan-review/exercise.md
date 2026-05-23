# Plan-as-Review Exercise

**Exam Question:** Aside from traditional code reviews, which Terraform command provides an opportunity for team members to review each other's work before deployment?

## Steps

### Part 1 — Establish baseline

1. **Initialize and apply:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

2. **Inspect the deployed resources:**

   ```bash
   cat *.txt
   ```

### Part 2 — Simulate a proposed change

3. **Swap in the proposed change:**

   ```bash
   cp solution/proposed-change/main.tf main.tf
   ```

   This simulates a teammate opening a PR that changes `length = 2` to `length = 5` in the `random_pet` resource.

4. **Generate the plan (the review artifact):**

   ```bash
   terraform plan
   ```

   The output shows exactly what would happen:
   - `random_pet.server` will be **destroyed and recreated** (`-/+`) — the name changes because the length is different
   - `local_file.info` will be **updated in-place** (`~`) — because it references the new pet name

5. **Review the plan as a team member:**

   **Key questions to ask when reviewing a plan:**
   - Are any resources being **replaced** that shouldn't be? (e.g., stateful resources like databases)
   - Are any resources being **destroyed** unexpectedly?
   - Do the new attribute values match expectations?
   - Are the changes scoped to what the PR intended?

### Part 3 — The review workflow

6. **Restore the original config:**

   ```bash
   git checkout main.tf
   ```

   In a real workflow, the plan is reviewed and if approved, a teammate runs `terraform apply` to deploy. The plan output becomes a shareable review artifact.

### Part 4 — Plan vs other commands

How does `terraform plan` differ from other Terraform commands for review?

| Command | Review value |
|---------|-------------|
| `terraform plan` | Shows the full diff of what will change — the review artifact |
| `terraform validate` | Only checks syntax — no diff, no infra changes visible |
| `terraform fmt` | Only checks code style — no infra changes visible |
| `terraform apply` | Executes changes — skips review entirely |
| `terraform init` | Downloads providers — no review value |

### Put It Together

Aside from traditional code reviews, which Terraform command provides an opportunity for team members to review each other's work before deployment?

- A. `terraform apply`
- B. `terraform plan`
- C. `terraform validate`
- D. `terraform init`
- E. `terraform fmt`

## Files
- `main.tf` — baseline config (length = 2)
- `solution/proposed-change/main.tf` — simulated PR change (length = 5)
- `solution/answer.md` — explanation and exam tips
