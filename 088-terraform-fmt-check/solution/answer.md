# Explanation

The correct answer is **C**.

> `terraform fmt -check`

---

## Why C Is Correct

`terraform fmt -check` is the **read-only** formatting check:

```
┌──────────────────────────────────────────────────────────┐
│  terraform fmt -check                                    │
│                                                          │
│  • Reads all .tf files                                   │
│  • Compares against canonical HCL formatting             │
│  • Prints names of non-conforming files                  │
│  • Exits with non-zero code if issues found              │
│  • Does NOT modify any files                             │
│  • Suitable for CI/CD gating                             │
└──────────────────────────────────────────────────────────┘
```

### Why it's the right CI/CD choice

| Requirement | How `fmt -check` satisfies it |
|-------------|------------------------------|
| No file modifications | ✅ Read-only — files are not changed |
| Fails on issues | ✅ Non-zero exit code stops the pipeline |
| Identifies problem files | ✅ Lists each non-conforming file |
| Fast | ✅ Runs locally, no API calls |

### CI/CD integration

```bash
# This will fail the pipeline if formatting is off:
terraform fmt -check -recursive
if [ $? -ne 0 ]; then
  echo "Formatting issues found. Run 'terraform fmt' locally."
  exit 1
fi
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — `terraform fmt` | This **rewrites** files in place. In CI/CD, you want a check that doesn't modify source files. `-check` is the read-only variant. |
| B — `terraform validate` | Validate checks **syntax and references** — not formatting. A file can be syntactically valid but poorly formatted. |
| D — `terraform plan` | Plan checks state changes — not formatting. It also requires credentials and is much slower. |
| E — `terraform fmt -recursive` | Recursive applies fmt to all subdirectories but **still rewrites** files without `-check`. |

## Fmt Commands Reference

| Command | Read-only? | Scope | Exit code |
|---------|-----------|-------|-----------|
| `terraform fmt` | ❌ No (rewrites) | Current dir | 0 |
| `terraform fmt -check` | ✅ Yes | Current dir | Non-zero if issues |
| `terraform fmt -recursive` | ❌ No (rewrites) | All subdirs | 0 |
| `terraform fmt -check -recursive` | ✅ Yes | All subdirs | Non-zero if issues |
| `terraform fmt -diff` | ❌ No (rewrites) | Shows diff of changes | 0 |
| `terraform fmt -check -diff` | ✅ Yes | Shows diff without applying | Non-zero if issues |
