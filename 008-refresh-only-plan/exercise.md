# Refresh-Only Plan Exercise

**Exam Question:** A resource was changed manually outside of Terraform. You don't want to make any changes yet, but you want to see how the state would be updated to match the current real-world values. Which command should you run?

## Steps

### Part 1 — Create the baseline

1. **Initialize and apply:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

2. **Note the created file:**

   ```bash
   cat *.txt
   ```

   The file contains: `Server: web-xxx` — this matches what Terraform has in state.

### Part 2 — Simulate outside change

3. **Manually edit the file** (simulating someone editing it outside Terraform):

   ```bash
   echo "INTRUDER WAS HERE" >> *.txt
   ```

   The real-world resource now differs from what Terraform's state records.

### Part 3 — Compare approaches

4. **Run a regular `terraform plan`:**

   ```bash
   terraform plan
   ```

   This refreshes state and displays the drift — but it mixes **state drift** with **config changes** in the same output. You can't tell what's a state update vs a config change.

5. **Run `terraform plan -refresh-only` (the correct answer):**

   ```bash
   terraform plan -refresh-only
   ```

   This updates only the state values to match real-world resources — it shows **only** the drift without proposing any config changes. No modifications are made to state or infrastructure.

### Part 4 — Apply the refresh (optional)

6. **If you want to update the state to match reality:**

   ```bash
   terraform apply -refresh-only -auto-approve
   ```

   The state is now updated. Running `terraform plan` again shows no changes.

### Put It Together

A resource was changed manually outside of Terraform. You don't want to make any changes yet, but you want to see how the state would be updated to match the current real-world values. Which command should you run?

- A. `terraform plan -refresh-only`
- B. `terraform plan`
- C. `terraform refresh`
- D. `terraform apply`
- E. `terraform validate`

## Files
- `main.tf` — creates a local file you can edit manually
- `outputs.tf` — outputs for verification
- `solution/answer.md` — explanation and command comparison
