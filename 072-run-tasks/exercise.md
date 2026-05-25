# HCP Terraform Run Tasks Exercise

**Exam Question:** Your organization wants to ensure that third-party security scanning tools can review Terraform plans before any infrastructure changes are applied. Which HCP Terraform feature allows you to integrate external tools into the workflow between the plan and apply phases?

## Background

HCP Terraform provides several gating mechanisms that run at different stages of the workflow:

| Feature | When it runs | Purpose |
|---------|-------------|---------|
| **Sentinel policies** | Before plan output is finalized | Policy as code (allow/deny based on rules) |
| **Run tasks** | **After plan, before apply** | Integrate external tools for scanning/validation |
| **Approval gates** | After run tasks, before apply | Human review and approval |

Run tasks are the mechanism for plugging external tools (security scanners, compliance checkers, cost estimators) into the Terraform workflow.

## Steps

### Part 1 — Examine the HCP Terraform workflow

1. **The HCP Terraform run lifecycle:**

   ```
   ┌─────────┐     ┌──────────┐     ┌──────────┐     ┌─────────┐
   │   Queued│ ──→ │   Plan   │ ──→ │Run Tasks │ ──→ │  Apply  │
   │         │     │          │     │(external)│     │         │
   └─────────┘     └──────────┘     └──────────┘     └─────────┘
                                        │
                                   ┌────┴────┐
                                   │ Security │
                                   │ Scanner  │
                                   ├─────────┤
                                   │ Cost     │
                                   │ Estimator│
                                   ├─────────┤
                                   │ Compliance│
                                   │ Check    │
                                   └──────────┘
   ```

### Part 2 — Understanding Run Tasks

2. **What run tasks do:**

   - Receive the plan JSON output
   - Send it to an external endpoint (a third-party service or custom tool)
   - The external tool analyzes the plan
   - Returns a pass/fail/error result to HCP Terraform
   - If it fails, the run is blocked from proceeding to apply

3. **Common use cases:**

   | External Tool | What it checks |
   |--------------|----------------|
   | **Checkov** | Security misconfigurations (open SGs, public buckets) |
   | **Snyk** | Infrastructure vulnerabilities |
   | **tfsec** | Security scanning for Terraform |
   | **Infracost** | Cost estimation and budgeting |
   | **Custom tool** | Organization-specific compliance rules |

### Part 3 — Run tasks vs other HCP features

4. **Comparison:**

   | Feature | Timing | Scope | Customizable? |
   |---------|--------|-------|---------------|
   | **Run tasks** | After plan, before apply | External tool integration | ✅ Yes — any HTTP endpoint |
   | **Sentinel** | During plan evaluation | Policy as code (in HCP) | ✅ Yes — custom policies |
   | **Manual confirm** | Before apply | Human approval | ✅ Yes — required reviewers |

5. **Example run task integration flow:**

   ```
   1. User queues a run in HCP Terraform
   2. Terraform generates the plan
   3. HCP Terraform sends the plan JSON to the run task endpoint
   4. Run task (e.g., Snyk) scans for security issues
   5. Run task returns: "PASS" or "FAIL" with details
   6. If PASS → proceed to manual confirm → apply
   7. If FAIL → block apply, notify the team
   ```

### Put It Together

Your organization wants to ensure that third-party security scanning tools can review Terraform plans before any infrastructure changes are applied. Which HCP Terraform feature allows you to integrate external tools into the workflow between the plan and apply phases?

- A. Sentinel policies
- B. Run tasks
- C. State versioning
- D. Workspace variables
- E. Module registry

## Files

- `main.tf` — config with HCP Terraform cloud block
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
