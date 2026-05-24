# Module Version Update Exercise

**Exam Question:** You maintain an existing Terraform configuration that uses a public module pinned to a specific version. A new minor version 5.3.0 of the module is available, and you want your configuration to use it. What steps are required to update the module version safely? (Select two.)

```hcl
module "compute" {
  source  = "azure/compute/azurerm"
  version = "5.2.0"
  # …module inputs…
}
```

## Background

Modules from the Terraform Registry should be **version-pinned** for reproducibility. When a new version is available, updating requires two steps:

1. **Change the version constraint** in the module block to target the new version
2. **Run `terraform init -upgrade`** to instruct Terraform to fetch the newer version

Simply editing the `version` argument in code is not enough — Terraform caches downloaded modules in `.terraform/modules/` and will not re-download them unless told to.

## Steps

### Part 1 — Examine the pinned module

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The module is pinned to exactly `5.2.0` using `version = "5.2.0"`. The `=` prefix means "exactly this version only."

### Part 2 — Understand how module versions work

2. **Check cached modules:**

   ```bash
   terraform init
   ls .terraform/modules/
   ```

   After init, the module is downloaded and cached in `.terraform/modules/`. Terraform will **not** re-download it unless the version constraint changes or `-upgrade` is specified.

3. **What happens if you only change the version in code:**

   Edit the version to `5.3.0` and run:

   ```bash
   terraform init
   ```

   Without `-upgrade`, Terraform sees the cached module and skips downloading. It will **not** fetch the new version even though the constraint changed.

### Part 3 — Safely upgrade the module

4. **Step 1: Update the version constraint in code:**

   Change:
   ```hcl
   version = "5.2.0"
   ```
   To:
   ```hcl
   version = "~> 5.3.0"
   ```

   The `~> 5.3.0` constraint allows `5.3.x` versions (>= 5.3.0, < 5.4.0). This is a **pessimistic constraint** — it permits the minor upgrade while protecting against major breaking changes.

   Alternatively, you could use:
   - `~> 5.3` — allows any 5.3.x patch
   - `>= 5.3.0, < 5.4.0` — explicit range (equivalent to `~> 5.3.0`)
   - `= 5.3.0` — exact pin (requires re-pinning for every patch)

5. **Step 2: Run `terraform init -upgrade`:**

   ```bash
   terraform init -upgrade
   ```

   The `-upgrade` flag tells Terraform to:
   - Ignore the cached module version
   - Consult the registry for versions matching the new constraint
   - Download the latest matching version (5.3.0)
   - Update the lock file (`.terraform.lock.hcl`)

### Part 4 — Verify the upgrade

6. **Confirm the new version is installed:**

   ```bash
   cat .terraform/modules/modules.json | grep -A 2 compute
   ```

   Or check the module's version in the lock file:

   ```bash
   grep -A 5 "azure/compute/azurerm" .terraform.lock.hcl
   ```

7. **Run plan to check for changes:**

   ```bash
   terraform plan
   ```

   Review the plan to ensure the new module version doesn't introduce unexpected changes. A minor version bump should be backward-compatible, but it's always good practice to review.

### Put It Together

You maintain an existing Terraform configuration that uses a public module pinned to a specific version. A new minor version 5.3.0 of the module is available, and you want your configuration to use it. What steps are required to update the module version safely? (Select two.)

```hcl
module "compute" {
  source  = "azure/compute/azurerm"
  version = "5.2.0"
  # …module inputs…
}
```

- A. Change `version = "5.2.0"` to `version = "5.3.0"`
- B. Update the version argument to allow 5.3.0 using `version = "~> 5.3.0"`
- C. Run `terraform apply` to download the new module version
- D. Run `terraform init -upgrade` to download the new module version
- E. Delete the `.terraform` directory and re-run `terraform init`

## Files

- `main.tf` — config with Azure module pinned to version 5.2.0
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
