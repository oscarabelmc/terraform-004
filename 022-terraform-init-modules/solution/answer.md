# Explanation

The correct answer is **B — Run `terraform init` to install the module into the current working directory.**

## Why

`terraform init` is the command that scans all `module` blocks in the configuration and downloads any modules that aren't already cached in `.terraform/modules/`. This includes:

| Module source type | Example | Behavior in `init` |
|-------------------|---------|-------------------|
| **Registry** | `terraform-aws-modules/vpc/aws` | Downloads from registry, version-pinned |
| **Git** | `git::https://github.com/org/repo.git` | Clones the repository |
| **HTTP** | `https://example.com/module.tar.gz` | Downloads and extracts the archive |
| **Local path** | `./modules/demo` | Recorded in `.terraform/modules/` symlink |

After `init` completes, modules are available in `.terraform/modules/` and Terraform can evaluate the module blocks.

## Module Installation Process

```
┌─────────────┐     ┌──────────────┐     ┌──────────────┐
│ Add module  │ ──> │ terraform    │ ──> │ .terraform/  │
│ block to    │     │ init         │     │ modules/     │
│ config      │     │              │     │ (cached)     │
└─────────────┘     └──────────────┘     └──────┬───────┘
                                                │
                                                ▼
                                         Ready for
                                         plan & apply
```

## When Does Each Command Install Modules?

| Command | Installs modules? | Notes |
|---------|------------------|-------|
| `terraform init` | **Yes** | The primary mechanism — also installs providers and configures backends |
| `terraform get` | **Yes** | Legacy command that only installs modules (not providers/backends). `init` supersedes it. |
| `terraform plan` | **No** | Errors with "Module not installed" if missing |
| `terraform apply` | **No** | Errors with "Module not installed" if missing |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — `terraform plan` | `plan` only evaluates the existing config — it does not download modules. It will error if modules are missing. |
| C — `terraform get` before `init` | `terraform get` was the old command for downloading modules, but `terraform init` handles everything (`get` is redundant). `init` runs `get` internally. |
| D — `terraform apply` | `apply` also does not download modules. It will fail with the same "Module not installed" error as `plan`. |
| E — Manual copy | Never manually manipulate `.terraform/`. Terraform manages this directory exclusively through `init`. |
