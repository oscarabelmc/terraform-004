# Answer

The correct answer is **A**.

> `terraform validate`

---

## Why A Is Correct

`terraform validate` checks the configuration files in a directory for:

| Check | What It Validates | Example Error |
|-------|------------------|---------------|
| **HCL syntax** | Braces, quotes, brackets | `Unclosed configuration block` |
| **Attribute names** | Arguments exist for the resource type | `Unsupported argument "contnt"` |
| **Value types** | Values match declared types | `Incorrect attribute value type: string required, bool given` |
| **Module references** | Module sources exist, inputs/outputs match | `Module source not found` |
| **Resource references** | Cross-resource references are reachable | `Reference to undeclared resource` |

It runs **without any cloud connectivity** — it's purely a static analysis of your configuration files. This makes it fast and safe to run in CI/CD pipelines before any infrastructure is touched.

## Why the Others Are Wrong

| Option | Purpose | Why Not Correct |
|--------|---------|-----------------|
| B — `terraform fmt` | Formats HCL syntax | Only reformats _style_ (indentation, spacing). Does not check attribute names, types, or module validity. |
| C — `terraform plan` | Shows changes against real infrastructure | Requires a configured backend and provider connectivity. Checks more than validation (drift detection, resource counts) but is slower and requires auth. |
| D — `terraform init` | Initializes working directory | Downloads providers and modules. May catch module source errors but does not validate attribute names, types, or references. |
| E — `terraform apply` | Executes changes | Would actually create/change infrastructure — far too late to catch simple syntax or type errors. |

## Validation vs. Plan

| Aspect | `terraform validate` | `terraform plan` |
|--------|-------------------|-----------------|
| **Connection required** | No | Yes (backend + providers) |
| **Speed** | Fast (milliseconds) | Slow (seconds to minutes) |
| **Catches syntax errors** | ✅ | ✅ |
| **Catches type errors** | ✅ | ✅ |
| **Catches missing modules** | ✅ | ✅ |
| **Catches cloud auth errors** | ❌ | ✅ |
| **Detects drift** | ❌ | ✅ |
| **Shows resource changes** | ❌ | ✅ |

**Best practice:** run `terraform validate` early and often — in your editor, pre-commit hooks, and CI pipelines — then `terraform plan` after to verify against real infrastructure.

## Exam Tips

- `terraform validate` = **static analysis** (no cloud calls)
- `terraform plan` = **dynamic analysis** (calls cloud APIs, reads state)
- `terraform fmt` = **formatting only** (like `gofmt` or `prettier`)
- `terraform validate` requires `terraform init` to have been run (needs provider schemas)
- Common question pattern: "Which command checks X without making any changes?" — could be `validate` or `plan`, depending on whether cloud connectivity is needed
- If the question mentions "syntactically valid" and "internally consistent" — that's `validate`
- If the question mentions "compare with real infrastructure" — that's `plan`
