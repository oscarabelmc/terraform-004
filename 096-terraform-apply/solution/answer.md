# Explanation

The correct answer is **B**.

> Applies the changes required in the target infrastructure in order to reach the desired configuration.

---

## Why B Is Correct

`terraform apply` is the **execution phase** of the core workflow:

```
Write (config) → Plan (preview) → Apply (execute)
                                    │
                                    ▼
                          ┌─────────────────────┐
                          │  Infrastructure     │
                          │  matches config     │
                          │  (desired state)    │
                          └─────────────────────┘
```

### What apply does step by step

| Step | Action |
|------|--------|
| 1 | Generates or reads a plan |
| 2 | Prompts for confirmation (unless `-auto-approve`) |
| 3 | Creates, updates, or destroys resources via provider APIs |
| 4 | Updates state file with new resource attributes |
| 5 | Displays output values |

### Key characteristics

| Feature | Detail |
|---------|--------|
| **Idempotent** | Safe to re-run — only changes what's needed |
| **Stateful** | Writes to state after successful execution |
| **Parallel** | Applies independent resources concurrently |
| **Confirmable** | Shows plan and requires `yes` by default |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Validates syntax | That's `terraform validate`, not apply. Apply assumes the config is already valid. |
| C — Downloads providers/modules | That's `terraform init`, not apply. Apply uses what init downloaded. |
| D — Formats files | That's `terraform fmt`, not apply. Apply doesn't touch file formatting. |
| E — Destroys all resources | That's `terraform destroy`, which is a special case of apply with an empty config. Apply by default provisions resources. |

## Apply vs Other Commands

| Command | Purpose |
|---------|---------|
| `terraform apply` | **Execute** changes to reach desired state |
| `terraform plan` | **Preview** changes without executing |
| `terraform init` | **Initialize** working directory |
| `terraform validate` | **Check** syntax and internal consistency |
| `terraform fmt` | **Format** configuration files |
| `terraform destroy` | **Destroy** all managed resources |
