# .terraform.lock.hcl Dependency Lock File Exercise

**Exam Question:** What is the `.terraform.lock.hcl` file and when does Terraform create or modify it?

## Background

The `.terraform.lock.hcl` file is Terraform's **dependency lock file**. It records the exact version, checksums, and source of every provider used in the configuration. It ensures **consistent, reproducible** provider installations across different machines and team members.

```
Role:  lock file (like package-lock.json, Cargo.lock, go.sum)
Scope: providers only (not modules)
When:  created/updated by terraform init
```

## Steps

### Part 1 — Examine the config

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The config declares two providers: `random` and `local`.

### Part 2 — Run `terraform init` to create the lock file

2. **Initialize:**

   ```bash
   terraform init
   ```

3. **Examine the lock file:**

   ```bash
   cat .terraform.lock.hcl
   ```

   ```hcl
   # This file is maintained automatically by "terraform init".
   # Manual edits may be overwritten.
   provider "registry.terraform.io/hashicorp/local" {
     version     = "2.5.2"
     constraints = "~> 2.5"
     hashes = [
       "h1:6sSdW0ioGzLPSgHjBftr7Ns6eR+GkKB3ys3SJ33hI0=",
       "h1:gZ6h0U1apJPqkRsLQH+Q4WA7h7JC0qijHrP9nKmL+0=",
       "zh:136fa545bbad2f08b48fb022b6e8d35a0e552a1a68c894a78ac28b7e14d1a92",
       ...
     ]
   }

   provider "registry.terraform.io/hashicorp/random" {
     version     = "3.6.3"
     constraints = "~> 3.6"
     hashes = [
       "h1:fXq9E8w+6Vj6iR32/b7RUI50P0R6SDXc7mfhnYpGq0=",
       ...
     ]
   }
   ```

   The lock file records:
   - **Provider source** — `registry.terraform.io/hashicorp/random`
   - **Version** — the exact version installed (e.g., `3.6.3`)
   - **Version constraints** — the constraint from config (e.g., `~> 3.6`)
   - **Hashes** — checksums to verify integrity on future installs

### Part 3 — How the lock file ensures reproducibility

4. **On another machine (or CI), running `terraform init`:**

   - Terraform reads `.terraform.lock.hcl`
   - Installs the **exact** versions recorded in the lock file
   - Verifies checksums match
   - Result: **identical provider versions** across all environments

   ```
   Developer A                    Developer B
   ┌──────────────┐               ┌──────────────┐
   │ terraform    │               │ terraform    │
   │ init         │               │ init         │
   │     │        │               │     │        │
   │     ▼        │               │     ▼        │
   │ Installs     │               │ Reads lock   │
   │ random 3.6.3 │               │ file         │
   │ local 2.5.2  │               │     │        │
   │     │        │               │     ▼        │
   │     ▼        │               │ Installs     │
   │ Writes lock  │               │ random 3.6.3 │  ← same version
   │ file         │               │ local 2.5.2  │  ← same version
   └──────────────┘               └──────────────┘
   ```

### Part 4 — When the lock file changes

5. **Scenarios that update the lock file:**

   | Scenario | What happens |
   |----------|-------------|
   | **First `terraform init`** | Lock file created from scratch |
   | **Adding a new provider** | New provider entry added to lock file |
   | **Upgrading providers** (`-upgrade`) | Lock file updated with new version + hashes |
   | **Removing a provider** | Provider entry removed from lock file |
   | **No provider changes** | Lock file remains unchanged |

6. **Explicitly upgrade providers:**

   ```bash
   terraform init -upgrade
   ```

   This ignores the lock file constraints and fetches the **latest** version matching the version constraint string, then **updates** the lock file.

### Part 5 — Should you commit `.terraform.lock.hcl`?

7. **YES — commit it to version control.**

   ```
   ✅ Commit .terraform.lock.hcl to Git
   ❌ Do NOT commit .terraform/ directory or terraform.tfstate
   ```

   | File | Commit? | Reason |
   |------|:-------:|--------|
   | `.terraform.lock.hcl` | ✅ Yes | Ensures consistent provider versions across the team |
   | `.terraform/` | ❌ No | Local cache, platform-specific binaries |
   | `terraform.tfstate` | ❌ No | Contains secrets, changes constantly |

8. **Check the `.gitignore`:**

   ```bash
   cat .gitignore
   ```

   The `.terraform/` directory and `*.tfstate` files are ignored. The `.terraform.lock.hcl` file is **not** ignored — it should be tracked.

### Put It Together

What is the `.terraform.lock.hcl` file and when does Terraform create or modify it?

- A. A configuration file that defines provider versions; it is created by `terraform plan`
- B. A dependency lock file used by Terraform; it is created or updated every time you run `terraform init`
- C. A state backup file created when you run `terraform apply`
- D. A log file that records all API calls made by providers during `terraform apply`
- E. A module cache file that stores downloaded modules from the registry

## Files

- `main.tf` — config with providers to demonstrate lock file creation
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
