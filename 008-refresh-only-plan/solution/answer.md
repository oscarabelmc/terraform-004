# Explanation

The correct answer is **A — `terraform plan -refresh-only`**.

## Why

`terraform plan -refresh-only` (introduced in Terraform 1.0) tells Terraform to:

1. Query the real-world state of all tracked resources
2. Compare it to what's recorded in state
3. Show what state updates would be needed
4. **Make no changes** — neither to infrastructure nor to state

This gives you a **read-only preview** of drift, exactly as the question asks.

## Command Comparison

| Command | Updates state? | Changes infra? | Purpose |
|---------|---------------|----------------|---------|
| `terraform plan -refresh-only` | No (preview only) | No | Preview state drift without any side effects |
| `terraform plan` | No (preview only) | No | Previews full plan: refresh + config changes (mixed output) |
| `terraform refresh` | **Yes** | No | Immediately updates state to match reality (no preview) |
| `terraform apply -refresh-only` | **Yes** | No | Applies the state refresh (writes to state) |
| `terraform apply` | Yes | Yes | Full apply: refresh + config changes + resource changes |
| `terraform validate` | No | No | Checks syntax and config validity, never touches state |

## Evolution of This Command

| Terraform Version | Available Commands |
|------------------|-------------------|
| < 0.15.4 | `terraform refresh` only — no preview, writes directly to state |
| 0.15.4+ | `terraform plan -refresh-only` added — preview without side effects |
| 1.0+ | `terraform apply -refresh-only` added — safe state-only update |
| 1.0+ | `terraform plan -refresh=false` disables refresh entirely (speeds up planning for large states) |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — `terraform plan` | Does refresh state, but the output mixes drift with config changes. You can't isolate the refresh preview. |
| C — `terraform refresh` | Immediately **writes** to state — the question says "don't want to make any changes yet." No preview mode. |
| D — `terraform apply` | Makes both state and infrastructure changes — the opposite of "don't want to make any changes." |
| E — `terraform validate` | Only checks HCL syntax and config validity. Never interacts with state or real resources. |
