# Answer

The correct answer is **B — `terraform fmt -recursive`**.

## Why

`terraform fmt` rewrites all `.tf` files in the current directory to canonical HCL format (2-space indentation, aligned assignment operators, consistent spacing).

Without `-recursive`, it only formats the current directory. Adding `-recursive` extends it to all subdirectories.

## Key Flags

| Flag | Purpose |
|------|---------|
| (no flags) | Format all `.tf` files in the current directory |
| `-recursive` | Also process files in subdirectories |
| `-check` | Exit with non-zero status if files need formatting (no changes made) |
| `-diff` | Display diffs of formatting changes |
| `-list` | List files that would be changed (or were changed) |
| `-write=false` | Don't write changes — dry run (often combined with `-diff`) |

## What `terraform fmt` Does

- Fixes indentation to 2 spaces
- Aligns `=` signs for assignments of the same type
- Normalizes blank lines
- Moves the `{` to the same line for blocks
- Does **not** touch:
  - `.tfstate` files
  - `.json` files (use `terraform fmt -json`)
  - `.terraform/` directory

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — `terraform validate` | Checks config **correctness** (syntax, references), not formatting style. |
| C — `terraform format` | **No such command.** The correct name is `fmt`. |
| D — `terraform lint` | **No such command.** Terraform has no built-in linter. |
| E — `terraform fmt` | Correct for a single directory, but **missing `-recursive`** which is needed for subdirectories. |

## Exam Tips

- `terraform fmt` rewrites files in place — it's the fastest way to fix formatting across a whole project.
- In CI/CD, use `terraform fmt -check -recursive` to enforce formatting standards.
- If you want to format JSON files too, use `-json` flag (e.g., `terraform fmt -json`).
- The command is **`fmt`** (format), not `format`, `lint`, or `style`.
