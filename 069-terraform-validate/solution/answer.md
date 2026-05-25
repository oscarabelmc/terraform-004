# Answer

The correct answer is **B**.

> `terraform validate`

---

## Why B Is Correct

`terraform validate` checks the configuration for:

```
┌──────────────────────────────────────┐
│         terraform validate           │
├──────────────────────────────────────┤
│ • HCL syntax correctness             │
│ • Valid resource and attribute names │
│ • Internal reference consistency     │
│ • Variable type constraints          │
│ • Required argument presence         │
│ • Circular dependency detection      │
│ • Module source format               │
├──────────────────────────────────────┤
│ ✅ No remote services contacted      │
│ ✅ No credentials required           │
│ ✅ Fast (milliseconds to seconds)    │
└──────────────────────────────────────┘
```

It works by parsing all `.tf` and `.tf.json` files and comparing them against provider schemas (downloaded during `init`) — all locally, without making any network calls.

### When to use validate

- After every config change during development
- Before committing code to version control
- In CI/CD pipelines as a pre-apply gate
- To catch syntax and reference errors early

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — `terraform plan` | Plan checks more than validate (state comparison, API readiness) but **contacts remote services** (state backend, provider APIs for refresh). The question specifies "without contacting any remote services." |
| C — `terraform apply` | Apply provisions infrastructure — it definitely contacts remote services. It also requires human confirmation. |
| D — `terraform fmt` | Fmt only checks and rewrites **code formatting** (indentation, alignment). It does not validate syntax, attribute names, or reference consistency. |
| E — `terraform refresh` | Refresh contacts the provider APIs to update state with real-world resource attributes — it requires remote service access. |

## Validation in the Development Workflow

```
Write code
    │
    ▼
terraform fmt        ← fix formatting
    │
    ▼
terraform validate   ← catch syntax/reference errors (fast, offline)
    │
    ▼
terraform plan       ← preview changes (contacts state backend)
    │
    ▼
terraform apply      ← provision infrastructure
```

## What Each Command Checks

| Command | Syntax | Attributes | References | State | Remote APIs | Credentials |
|---------|--------|------------|------------|-------|-------------|-------------|
| `validate` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `plan` | ✅ | ✅ | ✅ | ✅ | ✅ (refresh) | ✅ |
| `apply` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| `fmt` | ❌ (format only) | ❌ | ❌ | ❌ | ❌ | ❌ |
| `refresh` | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ |

## Objective Reference

**Objective 2b** — Differentiate between Terraform commands and subcommands.

`terraform validate` is the command for offline, pre-apply validation of configuration syntax and internal consistency.

## Exam Tips

- `terraform validate` = **offline, no remote calls, checks syntax + references**
- Requires `terraform init` first (to download provider schemas locally)
- Does **not** check credentials, API availability, or real-world resource state
- Fast feedback loop — run it frequently during development
- Common exam trap: confusing validate with plan — plan contacts state/APIs, validate does not
- Another trap: thinking fmt validates syntax (fmt only formats, validate checks correctness)
