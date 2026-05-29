# HCP Terraform CLI-Driven Workflow Exercise

**Domain:** HCP Terraform
**Topic:** CLI-driven workflow in HCP Terraform

## Description

Your team uses HCP Terraform with a CLI-driven workflow. After making changes to your configuration locally, you run `terraform plan`. Where does the plan operation execute

## Learning Objectives

- Examine the CLI-driven config
- See the execution flow
- Understand the data flow
- Compare with local execution

## Background

HCP Terraform offers three workflow types, which determine **where** Terraform operations execute:

| Workflow | Where Plan/Apply Runs | Trigger |
|----------|----------------------|---------|
| **CLI-driven** | On HCP Terraform infrastructure | Local `terraform plan`/`apply` commands |
| **VCS-driven** | On HCP Terraform infrastructure | Git push / PR |
| **API-driven** | On HCP Terraform infrastructure | API call |

In **CLI-driven workflow**, you run commands on your local machine, but the actual Terraform execution happens on HCP Terraform's infrastructure. Results are streamed back to your terminal.

## Steps

### Part 1 — Examine the CLI-driven config

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The `cloud` block connects this working directory to an HCP Terraform workspace configured with **CLI-driven workflow**.

### Part 2 — See the execution flow

2. **Initialize the config:**

   ```bash
   terraform init
   ```

   Terraform authenticates with HCP Terraform and configures the remote workspace.

3. **Run plan and observe where it executes:**

   ```bash
   terraform plan
   ```

   The output shows that the plan is running **on HCP Terraform**:

   ```
   Running plan in HCP Terraform. Output will stream here.
   ```

   The plan runs remotely, and the results stream to your terminal in real-time.

### Part 3 — Understand the data flow

4. **What happens during `terraform plan`:**

   ```
   Your Machine                        HCP Terraform
   ┌──────────────┐                   ┌──────────────────┐
   │ 1. terraform │ ──plan request──→ │ 2. Queue run     │
   │    plan      │                   │                  │
   │              │                   │ 3. Plan executes │
   │              │ ←──plan results── │    remotely      │
   │ 4. See       │                   │ 4. Store plan    │
   │    output    │                   │    in workspace  │
   └──────────────┘                   └──────────────────┘
   ```

   - Your machine sends the configuration to HCP Terraform
   - HCP Terraform queues a run and executes `terraform plan`
   - The plan output streams back to your terminal
   - The plan is also saved in the HCP Terraform workspace (visible in UI)

### Part 4 — Compare with local execution

5. **Contrast with local execution mode:**

   | Aspect | CLI-Driven (remote execution) | Local Execution |
   |--------|------------------------------|-----------------|
   | Where plan runs | HCP Terraform infrastructure | Your local machine |
   | Where apply runs | HCP Terraform infrastructure | Your local machine |
   | State stored | HCP Terraform | HCP Terraform |
   | Streams to terminal | ✅ | ✅ |
   | Shows in HCP Terraform UI | ✅ (run history) | ❌ |
   | Works offline | ❌ | ❌ (needs state from HCP) |

## Files

- `main.tf` — config with `cloud` block for CLI-driven workflow
- `outputs.tf` — output values
- `solution/` — reference implementation

