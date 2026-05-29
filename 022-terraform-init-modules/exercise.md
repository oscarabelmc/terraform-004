# Module Initialization Exercise

**Domain:** Modules
**Topic:** Module installation — `terraform init` downloads modules

## Description

You added a new module block to an existing Terraform configuration to reuse infrastructure code from a remote source. What do you need to do so that Terraform downloads the module and makes it available in your working directory

## Learning Objectives

- Add a module block
- Try to plan before initializing
- Run `terraform init` (the correct answer)
- Apply to confirm

## Steps

### Part 1 — Add a module block

1. **Inspect the configuration:**

   ```bash
   cat main.tf
   ```

   A `module` block has been added that references `./modules/demo`. For a **remote** source (like a registry or git repo), the module code is not yet on your machine — it must be downloaded.

### Part 2 — Try to plan before initializing

2. **Attempt to plan without downloading the module:**

   ```bash
   terraform plan
   ```

   This fails with an error:

   ```
   Error: Module not installed

     on main.tf line 4, in module "demo":
      4:   source = "./modules/demo"

   This module is not yet installed. Run "terraform init" to install all modules
   required by this configuration.
   ```

   Terraform cannot evaluate the module block because the module's code hasn't been fetched yet.

### Part 3 — Run `terraform init` (the correct answer)

3. **Initialize to download the module:**

   ```bash
   terraform init
   ```

   Terraform scans all `module` blocks and downloads any that aren't already in the `.terraform/modules/` directory. Output:

   ```
   Initializing modules...
   - demo in ./modules/demo

   Initializing the backend...
   Initializing provider plugins...
   Terraform has been successfully initialized!
   ```

4. **Verify the module was downloaded:**

   ```bash
   ls -R .terraform/modules/
   ```

   The module's code is now available locally. For remote sources (registry, git, HTTP), the `.terraform/modules/` directory acts as a local cache.

5. **Now plan works:**

   ```bash
   terraform plan
   ```

   No error — the module is installed and Terraform can evaluate it.

### Part 4 — Apply to confirm

6. **Apply and check the output:**

   ```bash
   terraform apply -auto-approve
   terraform output
   ```

## Files
- `main.tf` — configuration with a module block
- `modules/demo/` — example local module (remote sources work the same way)
- `modules/demo/main.tf` — creates a random_pet resource
- `solution/` — reference implementation

