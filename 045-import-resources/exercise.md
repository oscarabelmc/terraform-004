# Import Existing Resources Exercise

**Exam Question:** Some of your production resources were created manually in the Azure portal. The company requires all production resources to be managed through Terraform. What should you do to bring those existing resources under Terraform management without disrupting them?

## Background

When resources exist outside of Terraform (created via console, CLI, or other tools), you can **import** them into Terraform management without destroying or recreating them. The modern approach (Terraform 1.5+) uses `import` blocks in configuration.

## Steps

### Part 1 — Understand the import workflow

1. **The three-step process:**

   ```
   Step 1: Write resource blocks matching existing resources
   Step 2: Add import blocks mapping addresses to real-world IDs
   Step 3: Run terraform apply to import into state
   ```

   The key constraint: **no disruption** — resources are not modified, only adopted.

### Part 2 — Simulate existing resources

2. **First, create resources outside of Terraform (simulated):**

   ```bash
   cd /home/terraform-004/045-import-resources/modules/existing
   terraform init
   terraform apply -auto-approve
   cd ../..
   ```

   These resources now exist in "reality" but not in the root module's state.

3. **Note the resource IDs:**

   ```bash
   terraform output -state=modules/existing/terraform.tfstate
   ```

   You'll need these IDs for the import blocks.

### Part 3 — Write matching configuration

4. **Examine the root config:**

   ```bash
   cat main.tf
   ```

   It has provider declarations but no resource blocks yet.

5. **Add resource blocks matching the existing resources:**

   ```hcl
   resource "random_pet" "server" {
     prefix = "existing"
     length = 2
   }

   resource "local_file" "config" {
     filename = "${path.module}/server-config.txt"
     content  = "Server: ${random_pet.server.id}"
   }
   ```

   The config must **match** the existing resource's settings.

### Part 4 — Add import blocks

6. **Add import blocks to `main.tf`:**

   ```hcl
   import {
     to = random_pet.server
     id = "<actual-server-id-from-step-2>"
   }

   import {
     to = local_file.config
     id = "<actual-file-path>"
   }
   ```

   The `import` block tells Terraform: "There's an existing real resource with this ID; link it to this resource address."

### Part 5 — Run terraform apply

7. **Initialize and apply:**

   ```bash
   terraform init
   terraform apply -auto-approve
   ```

   Terraform reads the import blocks, fetches the real resources, writes them to state, and **does not modify them** — because the config matches reality.

8. **Verify successful import:**

   ```bash
   terraform state list
   terraform plan
   ```

   Both commands confirm the resources are under Terraform management with no changes needed.

### Part 6 — Clean up import blocks

9. **After successful import, remove the import blocks:**

   The import blocks have served their purpose. The resources are now fully managed by Terraform.

### Put It Together

Some of your production resources were created manually in the Azure portal. The company requires all production resources to be managed through Terraform. What should you do to bring those existing resources under Terraform management without disrupting them?

- A. Use the `import` block to import the existing resources under Terraform management
- B. Delete the resources in the portal and recreate them with Terraform
- C. Use data sources to reference the existing resources
- D. Run `terraform apply` and Terraform will automatically detect and adopt the resources
- E. Copy the resources into a new Terraform configuration in a different region

## Files

- `main.tf` — starter configuration (needs resource blocks + import blocks)
- `modules/existing/` — simulates resources created outside Terraform
- `modules/existing/main.tf` — the "manually created" resources
- `solution/main.tf` — complete config with import blocks + resource blocks
- `solution/answer.md` — explanation and exam tips
