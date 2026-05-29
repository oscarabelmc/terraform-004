# Module Version Pinning Exercise

**Domain:** Modules
**Topic:** Module version pinning — why include `version` argument

## Description

In a Terraform module block that sources a module from a registry, why should you include the `version` argument

## Learning Objectives

- Why version matters
- Initialize with version locking
- Apply and see the result
- The real risk (registry scenario)

## Steps

### Part 1 — Why version matters

1. **Inspect `main.tf`:**

   ```bash
   cat main.tf
   ```

   Two module blocks calling the same local module:
   - `module.pinned` — specifies `version = "~> 1.0"`
   - `module.unpinned` — no version argument

   For **registry modules**, the difference is critical: without `version`, Terraform downloads the **latest** version every time `terraform init` runs. With `version`, a specific release is locked.

### Part 2 — Initialize with version locking

2. **Initialize:**

   ```bash
   terraform init
   ```

   For the local module, `version` is metadata (local modules don't use registry versioning), but the principle is the same — the constraint declares an expectation.

3. **Check the dependency lock file:**

   ```bash
   cat .terraform.lock.hcl
   ```

   This records the exact provider versions used, similar to how `version` pins module releases.

### Part 3 — Apply and see the result

4. **Apply:**

   ```bash
   terraform apply -auto-approve
   ```

5. **Check outputs:**

   ```bash
   terraform output
   ```

   Both modules create resources with different names — identical except for the input.

### Part 4 — The real risk (registry scenario)

6. **Simulate the registry scenario** — without version pinning:

   - **Today:** `version` is omitted → `terraform init` downloads `v5.0.0` (works fine)
   - **Next month:** A new teammate runs `terraform init` → downloads `v6.0.0`
   - **v6.0.0** has a breaking change → the module fails to plan

   With `version = "~> 5.0.0"`, both the original and the teammate would get `v5.0.x`, never `v6.x`.

## Files
- `main.tf` — two module blocks: pinned vs unpinned
- `modules/demo/` — local example module
- `modules/demo/main.tf` — creates a random_pet with the given name
- `modules/demo/variables.tf` — name input variable
- `outputs.tf` — root module outputs
- `solution/` — reference implementation

