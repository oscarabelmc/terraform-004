# Answer

The variable that causes a type error is **A — `names`**.

## Why

`variable "names"` declares `type = list(string)` but provides `default = {}` (an empty map). The type system catches this mismatch at validation time:

```
Error: Invalid default value for variable
  This default value is not compatible with the variable's type constraint:
  list(string) required, but map of any given.
```

| Variable | Declared Type | Default Value | Matches? |
|----------|---------------|---------------|----------|
| `names` | `list(string)` | `{}` (empty map) | **No** — map ≠ list |
| `instance_count` | `number` | `3` | Yes — 3 is a number |
| `enabled` | `bool` | `true` | Yes — true is a bool |
| `tags` | `map(string)` | `{ Environment = "prod", Owner = "platform-team" }` | Yes — map of strings |

## When Does Terraform Detect Type Errors?

Terraform validates types at several stages:

| Stage | Type checking? | Example error |
|-------|---------------|--------------|
| `terraform validate` | **Yes** | Catches default mismatches, invalid constraints |
| `terraform plan` | **Yes** | Catches mismatched values passed via `-var` or `TF_VAR_` |
| `terraform apply` | **Yes** | Same as plan — types are validated before any resources are created |

The exam question asks "before apply" — both `validate` and `plan` catch this error before `apply` runs.

## Common Type Mismatches

| Declared Type | Invalid Default | Why It Fails |
|---------------|----------------|-------------|
| `list(string)` | `{}` | Map is not a list |
| `map(string)` | `[]` | List is not a map |
| `string` | `42` | Number is not a string |
| `number` | `"hello"` | String is not a number |
| `bool` | `"true"` | String `"true"` is not bool `true` |
| `list(string)` | `[1, 2, 3]` | List of numbers ≠ list of strings |

## Quick Reference

| Symbol | Type | Example |
|--------|------|---------|
| `{}` | Empty **map** | `type = map(string)` → OK |
| `[]` | Empty **list** | `type = list(string)` → OK |
| `""` | Empty **string** | `type = string` → OK |

## Exam Tips

- `{}` = **map** (even when empty) — always a map
- `[]` = **list** (even when empty) — always a list
- Terraform performs **static type checking** — it validates before any infrastructure changes
- The error message says "list(string) required, but map of any given" — the key words are **"required"** (type constraint) vs **"given"** (actual default)
- When you see `default = {}` in the exam, check if the type is `list(something)` — if so, it's an error
