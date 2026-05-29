# Config-Driven Import Exercise

**Domain:** IaC Workflow
**Topic:** Config-driven import with `import` block

## Description

You have an existing Google Cloud Storage bucket that was created manually. You want to bring it under Terraform management using a modern config-driven approach, so you add the following configuration:

## Learning Objectives

- Examine the import block
- Run plan to preview the import
- Apply to complete the import
- How config-driven import differs

## Background

Terraform 1.5+ introduced **config-driven import** using `import` blocks. Unlike the older `terraform import` CLI command (which runs as a standalone operation), the config-driven approach integrates import into the normal `plan → apply` workflow.

| Approach | How it works |
|----------|-------------|
| **CLI import** (legacy) | `terraform import <address> <id>` — standalone command, no config change |
| **Config-driven import** (modern) | `import` block in `.tf` files — import happens during `plan`/`apply` |

## Steps

### Part 1 — Examine the import block

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The `import` block tells Terraform:

   ```hcl
   import {
     to = google_storage_bucket.data_lake   # Resource address in state
     id = "imported-data-lake"              # Real-world resource ID
   }
   ```

   - `to` — the Terraform resource address that will own this resource in state
   - `id` — the real-world identifier of the existing resource (GCS bucket name)

### Part 2 — Run plan to preview the import

2. **Initialize Terraform:**

   ```bash
   terraform init
   ```

3. **Run plan:**

   ```bash
   terraform plan
   ```

   The plan output shows:

   ```
   Terraform will perform the following actions:

     # google_storage_bucket.data_lake will be imported
     # (config-driven import)
     ...
     Plan: 1 to import, 0 to add, 0 to change, 0 to destroy.
   ```

   Note: the plan says **"1 to import"** — not "1 to create." Terraform recognizes the `import` block and knows this resource already exists.

### Part 3 — Apply to complete the import

4. **Apply the configuration:**

   ```bash
   terraform apply
   ```

   Terraform:
   - Reads the existing bucket from GCP via the provider API
   - Writes the resource into the state file at `google_storage_bucket.data_lake`
   - Records all attributes (name, location, etc.)
   - Does **not** modify the bucket (it already matches the config)

5. **Verify the import:**

   ```bash
   terraform state list
   # Output: google_storage_bucket.data_lake

   terraform state show google_storage_bucket.data_lake
   # Shows all attributes read from the real bucket
   ```

### Part 4 — How config-driven import differs

6. **Comparison with legacy CLI import:**

   | Aspect | Config-driven (`import` block) | CLI (`terraform import`) |
   |--------|-------------------------------|--------------------------|
   | **Config change?** | Yes — `import` block is code | No — standalone command |
   | **Review before apply?** | Yes — `terraform plan` previews it | No — imports immediately |
   | **Version control?** | Yes — `import` block is committed | No — command is ephemeral |
   | **Repeatable?** | Yes — re-run plan/apply anytime | No — must re-enter command |

7. **Post-import cleanup (optional):**

   After the import succeeds, you can remove the `import` block:

   ```hcl
   # Remove this block — the resource is now in state
   # import {
   #   to = google_storage_bucket.data_lake
   #   id = "imported-data-lake"
   # }
   ```

   The resource remains managed by Terraform. The `import` block is only needed for the initial import operation.

## Files

- `main.tf` — config with import block and matching resource
- `outputs.tf` — output values
- `solution/` — reference implementation

