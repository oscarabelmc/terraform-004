# Explanation

The correct answer is **B**.

> Terraform compares the desired state in the configuration with the current state in the state file to build the plan.

---

## Why B Is Correct

Terraform's planning engine is a **two-input diff**:

```
Configuration (desired)  ──────┐
                                ├──→ terraform plan → execution plan
State file (current)     ──────┘
```

| Resource in config? | Resource in state? | Plan outcome |
|--------------------|-------------------|-------------|
| Yes | Yes, matching | **No changes** (no-op) |
| Yes | Yes, different | **Update in-place** (~) |
| Yes | No | **Create** (+) |
| No | Yes | **Destroy** (-) |

This diff logic is deterministic and does not require querying cloud APIs (unless `-refresh-only` is used).

### Example Walkthrough

```
Config declares:                    State contains:
  aws_vpc.main          ────────→    aws_vpc.main (id: vpc-123)
  aws_subnet.public     ────────→    aws_subnet.public (id: subnet-456)
  aws_instance.web      ────────→    (not in state)

Plan result:
  + aws_instance.web  (create — in config, missing from state)
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Terraform queries all cloud APIs | By default, `plan` uses the **state file** as the source of current state, not API calls. API queries only happen with `-refresh-only` or during `refresh`. |
| C — Checks Git history | Terraform has no awareness of Git history. It only reads the current config files from disk and the current state file. |
| D — Reuses last plan output | Every `plan` is a fresh comparison. Terraform does not cache or reuse previous plan outputs for determining changes. |
| E — Random ordering | Resource changes are determined by the config-vs-state diff, not randomness. Dependencies affect execution order, not what changes. |

## The Plan Decision Tree

```
                    ┌──────────────────────────┐
                    │  Resource exists in      │
                    │  configuration?          │
                    └───────────┬──────────────┘
                                │
                ┌───────────────┴───────────────┐
                ▼                               ▼
        ┌─────────────────┐            ┌─────────────────┐
        │  Yes            │            │  No             │
        └────────┬────────┘            └────────┬────────┘
                 │                              │
        ┌────────┴────────┐                     │
        ▼                 ▼                     ▼
  ┌──────────┐    ┌──────────────┐     ┌────────────────┐
  │In state? │    │  In state?   │     │  In state?     │
  └───┬──┬───┘    └───┬──┬───────┘     └───┬──┬─────────┘
      │  │            │  │                 │  │
      ▼  ▼            ▼  ▼                 ▼  ▼
    Yes No          Yes No                Yes No
     │   │           │   │                 │   │
     ▼   ▼           ▼   ▼                 ▼   ▼
   No-op Create   Update Create         Destroy (impossible)
```
