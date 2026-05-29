# Explanation

The correct answer is **A — Terraform is an immutable, declarative Infrastructure as Code language based on HashiCorp Configuration Language or JSON.**

## Why This Statement Is Correct

Each keyword in the statement corresponds to a fundamental characteristic of Terraform:

| Keyword | Meaning | Evidence |
|---------|---------|----------|
| **Immutable** | Resources are replaced, not modified in-place | Changing `length` from 2 → 4 shows `-/+` (destroy + create) in the plan, not `~` (in-place update). Most Terraform resources are immutable — if a change requires replacement, Terraform destroys the old and creates the new. |
| **Declarative** | You declare the desired end state; Terraform figures out the steps | The config has `resource` blocks with properties, but no `if/else`, no `for` loops, no sequencing logic. Terraform's engine determines the dependency graph and execution order. |
| **Infrastructure as Code** | Manage infrastructure through version-controlled configuration files | `.tf` files are plain text, can be committed to git, code-reviewed, and treated like application code. |
| **HCL or JSON** | Two syntax options with identical semantics | `main.tf` (HCL) and `main.tf.json` (JSON) produce the exact same plan. Terraform reads both formats from the same directory. |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — Mutable, procedural scripting | **Mutable** is wrong — Terraform replaces resources (immutable). **Procedural** is wrong — Terraform is declarative, you don't write step-by-step instructions. **Scripting** is wrong — it's a configuration language, not a general-purpose scripting language. |
| C — Only supports HCL | Wrong — Terraform also accepts JSON syntax (`.tf.json` files). The functional difference between HCL and JSON is zero. |
| D — Imperative, only JSON | **Imperative** is wrong — Terraform is declarative, you specify the end state, not the steps. **Only JSON** is wrong — HCL is the primary syntax and more commonly used. |
