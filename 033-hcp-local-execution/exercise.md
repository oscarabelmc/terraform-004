# HCP Terraform Local Execution Mode Exercise

**Exam Question:** You have configured a workspace in HCP Terraform to use local execution. In this mode, what does HCP Terraform do?

## Background

HCP Terraform (formerly Terraform Cloud) offers two execution modes:

| Mode | Runs plan/apply | Stores state | Use Case |
|------|----------------|-------------|----------|
| **Remote** (default) | On HCP Terraform's infrastructure | In HCP Terraform | CI/CD, team collaboration, audit trail |
| **Local** | On your local machine | In HCP Terraform | Hybrid: local control + remote state |

In **local execution mode**, HCP Terraform acts as a **remote state backend only** — it stores, versions, and locks the state file, but all `terraform plan` and `terraform apply` operations run on your local machine.

## Steps

### Part 1 — Examine the remote backend config

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The `cloud` block connects to HCP Terraform but only for state management — the workspace is configured with local execution mode.

### Part 2 — Understand the local execution workflow

2. **Initialize the config:**

   ```bash
   terraform init
   ```

   Terraform authenticates with HCP Terraform and configures it as the state backend.

3. **Run plan locally:**

   ```bash
   terraform plan
   ```

   The plan is computed on your local machine. HCP Terraform only provides the current state and receives the new state after apply.

4. **Run apply locally:**

   ```bash
   terraform apply -auto-approve
   ```

   The apply runs on your machine. After completion, the resulting state is pushed to HCP Terraform.

### Part 3 — Verify state is in HCP Terraform

5. **Check the state location:**

   ```bash
   terraform state list
   ```

   The state is managed by HCP Terraform. If you check the HCP Terraform UI, you'll see the state version history even though the runs were executed locally.

### Part 4 — Compare with remote execution

6. **Contrast what differs:**

   | Aspect | Local Execution | Remote Execution |
   |--------|----------------|-----------------|
   | Plan runs | On your machine | On HCP Terraform |
   | Apply runs | On your machine | On HCP Terraform |
   | State stored | In HCP Terraform | In HCP Terraform |
   | State locked | ✅ | ✅ |
   | State versioned | ✅ | ✅ |
   | Run history in UI | ❌ | ✅ |
   | Requires CLI | ✅ | ✅ (or VCS/API) |
   | Works offline | ❌ (needs HCP for state) | ❌ |

### Put It Together

You have configured a workspace in HCP Terraform to use local execution. In this mode, what does HCP Terraform do?

- A. HCP Terraform only stores and syncs the workspace's state file, while you run plan and apply locally on your own machine
- B. HCP Terraform runs plan and apply on its infrastructure, and stores the state
- C. HCP Terraform only stores provider plugins, while you run all Terraform commands locally
- D. HCP Terraform disables all remote functionality and reverts to local state
- E. HCP Terraform runs plan locally but apply remotely on its infrastructure

## Files

- `main.tf` — config with `cloud` block for HCP Terraform local execution
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
