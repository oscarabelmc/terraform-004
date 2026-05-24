# Answer

The correct answer is **A**.

> No changes. Block order doesn't affect the plan because Terraform parses all `.tf` files in a module together during execution.

---

## Why A Is Correct

Terraform does not treat `.tf` files as independent units. It loads them all into memory and merges them into a **single configuration** before processing:

```
Directory contents:
├── main.tf           \
├── vpc.tf             │
├── subnets.tf         ├── All loaded, sorted alphabetically,
├── variables.tf      │    merged into one config
├── outputs.tf        │
└── terraform.tf       /
         │
         ▼
    Single configuration tree
    ├── terraform {} block (from terraform.tf or main.tf)
    ├── provider blocks
    ├── variable blocks
    ├── resource "aws_vpc" "main" { ... }
    ├── resource "aws_subnet" "public" { ... }
    └── output blocks
         │
         ▼
    terraform plan  →  Identical result regardless of file organization
```

### Terraform's File Loading Rules

1. **All `.tf` files loaded** — every file ending in `.tf` in the directory
2. **Alphabetical sort** — files are sorted by name before parsing
3. **Single namespace** — all resources, variables, outputs share one namespace
4. **No file-level isolation** — `main.tf` can reference resources in `vpc.tf` freely
5. **No ordering** — block order within or across files doesn't matter

The only exception is `override.tf` (and `override.tf.json`), which is loaded **last** regardless of alphabetical order, allowing it to override values from other files.

### Why Rearranging Blocks Has No Effect

The plan output is determined by:

- **What resources are declared** — types, names, arguments
- **What dependencies exist** — references between resources
- **The current state** — what already exists

File names, block positions, line numbers, and comment placement are **not** part of the plan. They are discarded during parsing.

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — Destruction and recreation | Nothing changed in the configuration content. `terraform plan` compares config to state — identical config produces identical plan. |
| C — Parse failure | Terraform explicitly supports multiple `.tf` files. This is a standard practice, not an error. |
| D — Alphabetical creation | Terraform's dependency graph, not file/block order, determines creation order. Content determines dependencies, not file names. |
| E — Different order in output | The plan output order is deterministic and based on the dependency graph, not file or block order. |

## Best Practices for Organizing `.tf` Files

| Pattern | Description |
|---------|-------------|
| `main.tf` | Primary resource declarations |
| `variables.tf` | All input variable declarations |
| `outputs.tf` | All output value declarations |
| `providers.tf` / `terraform.tf` | Provider and backend configuration |
| `versions.tf` | Version constraints |
| `<resource>.tf` | Split by resource type for large configs |
| `override.tf` | Override values (loaded last) |

All of these patterns produce **identical plans** — organization is purely for human readability.

## Exam Tips

- Terraform merges **all `.tf` files** in a directory into one configuration
- File names, block order, and number of files do **not** affect the plan
- Only the **content** of declarations matters
- `override.tf` is the only file with special loading behavior (loaded last)
- This concept applies to **all** block types: resources, variables, outputs, providers, etc.
- Common exam scenario: "Split a config into multiple files — what happens?" — nothing, plan is identical
- Common exam trap: thinking block order in a file affects creation order — it doesn't; dependencies do
