# Answer

The three correct answers are: **A, B, and C**.

---

## A — `terraform show` displays the entire state file without requiring any additional arguments

Running `terraform show` with no arguments prints the complete state in a human-readable format — every resource, every attribute. No resource address or flag is needed.

## B — `terraform state show` requires you to specify a resource address to view that specific resource

`terraform state show` is a **subcommand of the `terraform state` family** designed for targeted inspection. Running it without a resource address produces:

```
Error: You must provide a resource address to show.
```

Example with an address:

```bash
terraform state show random_pet.server
```

## C — `terraform show` is useful when you want a complete overview of all managed infrastructure

Because `terraform show` prints the entire state without arguments, it's the go-to command for getting a full picture of what Terraform is managing. This is especially useful in CI/CD or during incident response to quickly understand the current state of all resources.

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| D — `terraform state show` displays the entire state without arguments | **False.** `terraform state show` requires a resource address. Without one, it errors. This is the opposite of its behavior. |
| E — `terraform show` requires a resource address | **False.** `terraform show` requires no arguments to display state. It's `state show` that needs an address. |
| F — `terraform state show` can display saved plan files | **False.** Only `terraform show` works with plan files (`terraform show tfplan`). `terraform state show` operates exclusively on state, not plan files. |

## Quick Reference

| Command | Arguments | Shows | Also reads |
|---------|-----------|-------|------------|
| `terraform show` | None | Entire state | Plan files (saved output) |
| `terraform state show` | Resource address (required) | Single resource | State only |

## Exam Tips

- `terraform show` = **broad** (full state / plan, no args needed)
- `terraform state show` = **targeted** (single resource, address required)
- `terraform state` is a family of subcommands: `list`, `show`, `mv`, `rm`, `pull`, `push` — all require specific arguments
- Don't confuse `terraform show` with `terraform state show` — they sound similar but behave very differently
- If the question mentions "no arguments" → think `terraform show`
- If the question mentions "resource address" → think `terraform state show`
