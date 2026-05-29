# Destroy Confirmation Exercise

**Domain:** IaC Workflow
**Topic:** `terraform destroy` prompts for confirmation by default

## Description

True or False? By default, the `terraform destroy` command will prompt the user for confirmation before proceeding.

## Learning Objectives

- Create resources to destroy
- Default behavior (with prompt)
- Skipping the prompt
- Preview without destroying

## Steps

### Part 1 — Create resources to destroy

1. **Initialize and apply:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

### Part 2 — Default behavior (with prompt)

2. **Run `terraform destroy`:**

   ```bash
   terraform destroy
   ```

   Terraform shows the destroy plan and then **pauses for confirmation**:

   ```
   Do you really want to destroy all resources?
     Terraform will destroy all your managed infrastructure...
     There is no undo. Only 'yes' will be accepted to confirm.

     Enter a value:
   ```

3. **Enter `no`** to cancel:

   ```bash
   no
   ```

   The destroy is aborted. Resources remain intact.

4. **Enter `yes`** to proceed:

   ```bash
   terraform destroy
   yes
   ```

   All resources are destroyed.

### Part 3 — Skipping the prompt

5. **Recreate the resources:**

   ```bash
   terraform apply -auto-approve
   ```

6. **Use `-auto-approve` to skip the prompt:**

   ```bash
   terraform destroy -auto-approve
   ```

   The destroy runs immediately without asking for confirmation.

### Part 4 — Preview without destroying

7. **Recreate and then preview:**

   ```bash
   terraform apply -auto-approve
   terraform plan -destroy
   ```

   This shows exactly what would be destroyed, but does nothing — no prompt, no changes.

## Files
- `main.tf` — simple config to destroy
- `solution/` — reference implementation

