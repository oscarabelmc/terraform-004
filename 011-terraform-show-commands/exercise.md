# Terraform Show Commands Exercise

**Exam Question:** A colleague asks what the difference is between `terraform show` and `terraform state show`. What is the correct explanation? (Select three.)

## Steps

### Part 1 — Create the baseline

1. **Initialize and apply:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

   Four resources are now tracked in state: two `random_pet` and two `local_file`.

### Part 2 — `terraform show` (broad overview)

2. **Display the entire state:**

   ```bash
   terraform show
   ```

   This prints **every resource** in the state file with all their attributes — no arguments needed. It gives a **complete overview of all managed infrastructure**.

3. **Compare with plan file output (optional):**

   ```bash
   terraform plan -out=tfplan
   terraform show tfplan
   ```

   `terraform show` also works with saved plan files, not just state — the behavior is the same: full output with no required arguments.

### Part 3 — `terraform state show` (targeted view)

4. **Show a specific resource:**

   ```bash
   terraform state show random_pet.server
   ```

   This requires a **resource address** as an argument. It returns only the attributes of that single resource.

5. **Try without an argument:**

   ```bash
   terraform state show
   ```

   This produces an error like:

   ```
   Error: You must provide a resource address to show.
   ```

   `terraform state show` **must** specify a resource address; it cannot show the entire state.

### Part 4 — Side-by-side comparison

| Aspect | `terraform show` | `terraform state show` |
|--------|-----------------|----------------------|
| Arguments | None required | Resource address **required** |
| Output | Entire state (all resources) | Single resource attributes |
| Use case | Broad overview of all infra | Inspecting a specific resource |
| Also works with | Plan files (`terraform show tfplan`) | State only |

### Put It Together

A colleague asks what the difference is between `terraform show` and `terraform state show`. What is the correct explanation? (Select three.)

- A. `terraform show` displays the entire state file without requiring any additional arguments.
- B. `terraform state show` requires you to specify a resource address to view that specific resource.
- C. `terraform show` is useful when you want a complete overview of all managed infrastructure.
- D. `terraform state show` displays the entire state file without requiring any additional arguments.
- E. `terraform show` requires you to specify a resource address to view that specific resource.
- F. `terraform state show` can display saved plan files as well as state files.

## Files
- `main.tf` — creates 4 resources (2 random_pet, 2 local_file)
- `outputs.tf` — outputs for verification
- `solution/answer.md` — explanation and exam tips
