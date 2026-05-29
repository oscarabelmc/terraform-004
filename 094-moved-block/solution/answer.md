# Explanation

The correct answer is **B — False**.

> You should keep the `moved` block for at least one full apply cycle (often more) so that all team members and automation runs can update their state. Removing it too soon can cause Terraform to think the old resource address was destroyed and the new one must be created.

---

## Why the Answer Is False

Removing a `moved` block immediately risks **unintended resource destruction**:

```
Safe timeline:
┌──────────┐     ┌──────────┐     ┌──────────┐
│  Add     │     │  Apply   │     │  Remove  │
│  moved   │ ──→ │ (state   │ ──→ │  moved   │
│  block   │     │ updated) │     │  block   │
└──────────┘     └──────────┘     └──────────┘
                     │                  │
               Keep for ≥1 full    Only after all
               apply cycle        state is migrated
```

### Why you must keep the moved block

| Reason | Explanation |
|--------|-------------|
| **Team sync** | Team members may not have applied yet — their state still has the old address |
| **CI/CD runs** | Automation pipelines may have queued runs with the old state |
| **Safety net** | The moved block acts as a bridge — removing it breaks the connection |
| **Idempotency** | Running plan a second time with the moved block is a safe no-op |

### What happens if you remove it too soon

```
Team member A:
  Applies moved block → state updated to new address ✅

Team member B (hasn't applied yet):
  Pulls latest code (moved block removed)
  Runs terraform plan
  Sees:
    - aws_instance.application: create (new address in config, not in state)
    - aws_instance.web_server: destroy (old address in state, not in config)
  
  Result: Terraform wants to destroy and recreate the resource! ❌
```

## Why "True" Is Incorrect

Choosing "True" assumes the moved block is only for the initial migration. In reality:

- Other team members need to sync their state
- CI/CD pipelines need a complete run cycle
- The moved block is **safe to keep** — it becomes a no-op after the first apply

## Moved Block Best Practices

| Step | Action | Why |
|------|--------|-----|
| 1 | Add `moved` block + rename resource in config | Single commit |
| 2 | Apply | Migrates state from old to new address |
| 3 | Keep moved block for ≥1 cycle | Allows team/CI to sync state |
| 4 | Remove moved block in separate commit | Clean code after migration complete |
