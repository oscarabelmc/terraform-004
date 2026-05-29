# Postcondition Validation Exercise

**Domain:** IaC Workflow
**Topic:** Postcondition in lifecycle block

## Description

You're deploying a GCP Compute Engine instance and want to verify that the instance receives a public IP address after creation. If it doesn't, you want Terraform to fail with an error. Which validation mechanism should you use

## Learning Objectives

- Examine the postcondition
- How postconditions work
- Compare with other validation mechanisms
- Postcondition use cases

## Background

Terraform provides several validation mechanisms at different stages:

| Mechanism | When it runs | Purpose |
|-----------|-------------|---------|
| **Variable validation** | Before plan | Validate input variables |
| **Check blocks** | After plan, during apply | Validate infrastructure (warning, not blocking) |
| **Precondition** | Before resource create/update | Validate state before making changes |
| **Postcondition** | **After resource create/update** | Validate the result of resource creation |

A **postcondition** is the correct choice when you need to verify a resource's attributes **after** it has been created or updated, and fail if expectations aren't met.

## Steps

### Part 1 — Examine the postcondition

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The `lifecycle` block contains a `postcondition`:

   ```hcl
   lifecycle {
     postcondition {
       condition     = self.network_interface[0].access_config[0].nat_ip != ""
       error_message = "Instance did not receive a public IP address."
     }
   }
   ```

   - `condition` — an expression that must evaluate to `true`
   - `error_message` — the error shown if the condition is `false`
   - `self` — refers to the resource's attributes after creation

### Part 2 — How postconditions work

2. **The postcondition execution flow:**

   ```
   terraform apply
        │
        ▼
   Resource is created/updated
        │
        ▼
   Postcondition checked
        │
        ├── ✅ Condition is true → continue (no error)
        │
        └── ❌ Condition is false → Terraform fails with error_message
   ```

   If the instance doesn't receive a public IP:

   ```
   Error: Resource postcondition failed

     on main.tf line 21, in resource "google_compute_instance" "web":
     21:     condition     = self.network_interface[0].access_config[0].nat_ip != ""

     Instance did not receive a public IP address.
   ```

### Part 3 — Compare with other validation mechanisms

3. **Variable validation (not suitable here):**

   ```hcl
   variable "public_ip" {
     type = string
     validation {
       condition     = var.public_ip != ""
       error_message = "Public IP cannot be empty."
     }
   }
   ```

   ❌ This validates **input** — but you don't know the public IP before creating the instance. The value is assigned by GCP after creation.

4. **Precondition (not suitable here):**

   ```hcl
   lifecycle {
     precondition {
       condition     = var.assign_public_ip == true
       error_message = "Must assign public IP."
     }
   }
   ```

   ❌ This checks **before** creation — useful for validating assumptions about state, but can't verify the result of the creation.

5. **Check blocks (not suitable here):**

   ```hcl
   check "public_ip_check" {
     data "http" "health_check" {
       url = "http://${google_compute_instance.web.network_interface[0].access_config[0].nat_ip}"
     }
     assert {
       condition     = data.http.health_check.status_code == 200
       error_message = "Instance is not reachable."
     }
   }
   ```

   ❌ Check blocks are **informational** — they report failures but do **not** block apply. They're for post-deployment validation, not hard gating.

### Part 4 — Postcondition use cases

6. **Common postcondition patterns:**

   ```hcl
   # Verify instance has a public IP
   postcondition {
     condition     = self.network_interface[0].access_config[0].nat_ip != ""
     error_message = "No public IP assigned."
   }

   # Verify bucket versioning is enabled
   postcondition {
     condition     = self.versioning[0].enabled == true
     error_message = "Bucket versioning is not enabled."
   }

   # Verify deployment finished with expected result
   postcondition {
     condition     = self.status == "RUNNING"
     error_message = "Instance is not running after creation."
   }
   ```

## Files

- `main.tf` — config with postcondition to verify public IP assignment
- `outputs.tf` — output values
- `solution/` — reference implementation

