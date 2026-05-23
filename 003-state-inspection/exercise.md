# State Inspection Exercise

**Scenario:** You applied a Terraform configuration and now need to inspect the state to understand what was created, examine specific resource attributes, and manage state entries.

## Steps

1. **Apply the configuration:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

2. **List all resources in state:**

   ```bash
   terraform state list
   ```

   What resources are tracked in state?

3. **Inspect a specific resource's attributes:**

   ```bash
   terraform state show random_pet.server
   ```

   What attributes does the `random_pet.server` resource have in state?

4. **Move a resource in state:**

   ```bash
   terraform state mv random_pet.server random_pet.server_v2
   ```

   What happens to the resource? Run `terraform plan` to see the effect.

5. **Remove a resource from state:**

   ```bash
   terraform state rm local_file.server_info
   ```

   Run `terraform plan` again. What does Terraform want to do now?

6. **Re-import the resource into state** (optional):

   ```bash
   terraform import local_file.server_info "$(pwd)/server-prod-*.txt"
   ```

   (Replace the filename with the actual file path.)

## Files
- `main.tf` — creates a random pet name and a local file
- `outputs.tf` — outputs the pet name and file path
- `solution/answer.md` — explanation and exam tips
