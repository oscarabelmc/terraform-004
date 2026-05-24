# Answer

The correct answer is **A**.

> On HCP Terraform infrastructure with results streamed back to your terminal.

---

## Why A Is Correct

In a **CLI-driven workflow** with HCP Terraform, the Terraform CLI runs on your machine, but the actual **Terraform execution** (plan/apply) runs on HCP Terraform's infrastructure:

```
┌─────────────────────┐         ┌─────────────────────────────┐
│    Your Machine     │         │    HCP Terraform            │
│                     │         │                             │
│  terraform plan     │ ──────→ │  Queue run                  │
│  terraform apply    │         │  Execute plan/apply         │
│                     │         │  Store state                │
│  See streamed       │ ←────── │  Record run history         │
│  output in terminal │         │  Stream output back         │
└─────────────────────┘         └─────────────────────────────┘
```

### What Happens Step by Step

1. You run `terraform plan` on your local machine
2. Your configuration is uploaded to HCP Terraform
3. HCP Terraform queues a **run** in the workspace
4. HCP Terraform executes `terraform plan` on its infrastructure
5. The plan output is **streamed back** to your terminal in real-time
6. The plan is also saved in the workspace's **run history** (viewable in UI)
7. If you run `terraform apply`, the same flow applies — apply runs on HCP Terraform

### What Shows in the Terminal

```
$ terraform plan

Running plan in HCP Terraform. Output will stream here.

Terraform used the selected providers to generate the following
execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # random_pet.server will be created
  + resource "random_pet" "server" {
      + id        = (known after apply)
      + length    = 2
      + prefix    = "cli-demo"
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — Local machine, results uploaded | In CLI-driven workflow, the plan runs **remotely** on HCP Terraform, not locally. Your machine only sends the config and displays the results. |
| C — Both local and remote simultaneously | Only one execution location — HCP Terraform. There is no local plan in this mode. |
| D — Local machine only | If the `cloud` block is configured and the workspace uses remote execution, the plan runs on HCP Terraform, not locally. |
| E — Only visible in web UI | The results are **streamed to your terminal** AND saved in the UI. You see the output in real-time in your CLI. |

## Workflow Comparison

| Aspect | CLI-Driven (remote exec) | VCS-Driven | API-Driven |
|--------|------------------------|-----------|------------|
| **Trigger** | `terraform plan` locally | Git push / PR | API call |
| **Where plan runs** | HCP Terraform | HCP Terraform | HCP Terraform |
| **Where apply runs** | HCP Terraform | HCP Terraform | HCP Terraform |
| **Stream to terminal** | ✅ | ❌ (UI only) | ❌ (API response) |
| **Run history in UI** | ✅ | ✅ | ✅ |
| **Requires CLI** | ✅ | ❌ (web UI / merge) | ❌ (API calls) |

## When to Use CLI-Driven Workflow

| Use Case | Why CLI-Driven |
|----------|---------------|
| **Local development** | Test changes with HCP Terraform's remote execution |
| **CI/CD pipelines** | Run `terraform plan` in CI with results in HCP Terraform |
| **Scripting/automation** | Combine CLI with shell scripts |
| **Hybrid workflows** | Develop locally, deploy via HCP Terraform |

## Exam Tips

- **CLI-driven workflow** = you type commands, HCP Terraform executes them
- The **execution mode** in the workspace settings determines where runs happen — not the workflow type alone
- CLI-driven workflow with **remote execution** = plan/apply on HCP Terraform
- CLI-driven workflow with **local execution** = plan/apply on your machine, state in HCP Terraform
- The `cloud` block (or `remote` backend) enables CLI-driven workflow
- Run output is **streamed** to your terminal — you see it in real-time
- Runs also appear in the **HCP Terraform UI** run history
- Common exam scenario: "You run `terraform plan` locally but it executes remotely — how?" — CLI-driven workflow with remote execution
