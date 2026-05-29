# Explanation

The correct answers are **A** and **B**.

> **A.** `local-cluster` refers to a local child module on disk.
>
> **B.** `main.tf` is the root (calling) module.

---

## Why A and B Are Correct

### A — Local child module

The `source = "./modules/local-cluster"` path indicates a **local module**:

```
source = "./modules/local-cluster"
          │
          ├── ./  → relative path (current directory)
          │
          └── modules/local-cluster/ → directory on local disk
```

This means the module code lives in a subdirectory of the project, not in an external registry.

### B — Root module

The file where Terraform is executed (`main.tf` at the project root) is the **root module**. It calls (references) the child module via the `module` block.

```
Root Module:         /home/.../092-root-child-module/   (where terraform runs)
                     └── main.tf (calls module "servers")

Child Module:        /home/.../092-root-child-module/modules/local-cluster/
                     └── main.tf (defines resources)
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| C — Registry module | Registry modules use a three-part format like `terraform-aws-modules/vpc/aws`. The `./` prefix indicates a **local path**, not a registry reference. |
| D — `servers = 5` sets an output | `servers = 5` passes an **input** to the child module (matching `variable "servers"` in the child). Outputs use `output` blocks and are accessed via `module.servers.<output_name>`. |
| E — Module cannot accept inputs | The child module declares `variable "servers" { type = number }` — it clearly accepts input variables. |

## Module Source Types

| Source format | Type | Example |
|---------------|------|---------|
| `./path` or `../path` | **Local** child module | `./modules/local-cluster` |
| `namespace/name/provider` | **Public registry** | `hashicorp/consul/aws` |
| `git::https://...` | **Git repository** | `git::https://github.com/org/repo.git` |
| `http://...` or `https://...` | **HTTP URL** | `https://example.com/module.zip` |

## Root vs Child Module Summary

| Aspect | Root Module | Child Module |
|--------|-------------|--------------|
| **Location** | Where `terraform` runs | Referenced via `source` in `module` block |
| **Inputs** | Variables from tfvars, CLI | Variables passed via `module` block arguments |
| **Outputs** | Exported via `output` blocks | Accessed as `module.<name>.<output>` |
| **State** | Owns the state file | State managed by root module |
