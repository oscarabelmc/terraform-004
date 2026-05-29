# Explanation

The correct answer is **B**.

> Run `terraform validate`

---

## Why B Is Correct

`terraform validate` is the fastest verification tool after refactoring because:

```
┌─────────────────────────────────────────────────────────┐
│              terraform validate                          │
├─────────────────────────────────────────────────────────┤
│  ✅ Checks syntax in all .tf files                      │
│  ✅ Verifies cross-file references (intra-config)       │
│  ✅ Validates resource and attribute names              │
│  ✅ Detects missing variables, locals, and resources    │
│  ✅ Works entirely offline (no API calls)               │
│  ✅ Fast — milliseconds to seconds                      │
│  ✅ No credentials or state required                    │
└─────────────────────────────────────────────────────────┘
```

### Why validate is the right choice after refactoring

| Requirement | How validate satisfies it |
|-------------|--------------------------|
| Fast verification | ✅ Runs offline, no network calls |
| Catch split-file errors | ✅ Parses all `.tf` files together, catches broken references |
| No changes to infrastructure | ✅ Read-only, never modifies anything |
| Pre-apply safety check | ✅ Catches errors before you get to plan/apply |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — `terraform plan` | Plan is **slower** than validate (contacts state, may refresh). While it would catch syntax errors, validate is faster and sufficient for syntax checking. Plan adds unnecessary overhead after a refactoring. |
| C — `terraform fmt` | Fmt only checks and rewrites **code formatting** (indentation, alignment). It does not validate syntax, attribute names, or reference consistency. |
| D — `terraform apply` | Apply **modifies infrastructure**. Running apply just to check syntax is dangerous and slow. Always validate first. |
| E — Manual review | Error-prone and time-consuming. Validate catches errors automatically that a human could miss. |

## The Refactoring Workflow

```
1. Split monolithic file into multiple files
         │
         ▼
2. terraform fmt          ← Normalize formatting
         │
         ▼
3. terraform validate     ← Quick syntax and reference check ✅
         │
         ▼
4. terraform plan         ← Preview actual changes (if any)
         │
         ▼
5. terraform apply        ← Apply if plan is clean
```

### What validate catches during refactoring

| Refactoring action | Validate catches? |
|-------------------|-------------------|
| Move resources to new file | ✅ Cross-file references still valid |
| Rename resources | ✅ All references updated? |
| Split variables into separate file | ✅ Variable definitions and references match |
| Reorganize locals | ✅ Locals referenced correctly |
| Remove unused resources | ✅ No dangling references? |
| Add new resources | ✅ Syntax and attribute names correct |

## Validate vs Plan Timing

```bash
# After refactoring, run this loop:
while editing:
    terraform validate    # < 1 second — instant feedback

# Only when ready to deploy:
terraform plan            # 10-30 seconds — full check
terraform apply           # deploy
```
