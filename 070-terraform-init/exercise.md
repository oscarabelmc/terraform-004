# Terraform Init Exercise

**Exam Question:** Which of the following actions are performed during a `terraform init`? (Select three.)

## Background

`terraform init` is the **first command** run in any Terraform working directory. It prepares the directory for use by downloading dependencies, configuring the backend, and verifying the environment.

It is **idempotent** — safe to run multiple times.

## Steps

### Part 1 — Examine a config that needs init

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   This configuration requires `terraform init` to prepare three things:

   ```
   ┌─────────────────────────────────────────────────┐
   │             What terraform init does            │
   ├─────────────────────────────────────────────────┤
   │ 1. 📥 Downloads provider plugins                │
   │    (aws, random)                                │
   │                                                 │
   │ 2. 📦 Downloads modules                         │
   │    (terraform-aws-modules/vpc/aws)              │
   │                                                 │
   │ 3. ⚙️  Initializes backend                      │
   │    (S3 backend configuration)                   │
   └─────────────────────────────────────────────────┘
   ```

### Part 2 — Run init and observe

2. **Initialize the directory:**

   ```bash
   terraform init
   ```

   Output shows the three actions:

   ```
   Initializing modules...
   - vpc in .terraform/modules/vpc

   Initializing the backend...

   Initializing provider plugins...
   - Finding hashicorp/aws versions matching "~> 5.0"...
   - Finding hashicorp/random versions matching "~> 3.5"...
   - Installing hashicorp/aws v5.x.x...
   - Installing hashicorp/random v3.x.x...

   Terraform has been successfully initialized!
   ```

### Part 3 — Examine what init created

3. **Check the `.terraform/` directory:**

   ```bash
   ls -la .terraform/
   ```

   ```
   .terraform/
   ├── modules/          ← downloaded modules cached here
   │   └── modules.json
   ├── providers/        ← downloaded provider plugins
   │   └── ...
   └── terraform.tfstate ← backend configuration saved here
   ```

4. **Module cache:**

   ```bash
   ls .terraform/modules/
   ```

   The VPC module is downloaded and cached.

5. **Provider cache:**

   ```bash
   ls .terraform/providers/
   ```

   Shows provider binaries for your platform.

### Part 4 — What init does NOT do

6. **Init does NOT provision resources:**

   ```
   ❌ terraform init → provisions resources
   ✅ terraform apply → provisions resources
   ```

   Provisioning happens during `apply`, not `init`. Init only prepares the working directory.

### Put It Together

Which of the following actions are performed during a `terraform init`? (Select three.)

- A. Provisions the declared resources in your configuration
- B. Initializes the backend configuration
- C. Downloads the required modules referenced in the configuration
- D. Downloads the providers/plugins required to execute the configuration

## Files

- `main.tf` — config requiring init (providers, modules, backend)
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
