# Answer

The correct answer is **A**.

> The `.terraform/providers` directory in the current working directory.

---

## Why A Is Correct

When `terraform init` downloads provider plugins, they are stored in:

```
.terraform/providers/
└── registry.terraform.io/
    └── hashicorp/
        ├── aws/
        │   └── 5.84.0/
        │       └── linux_amd64/
        │           └── terraform-provider-aws_v5.84.0_x5
        └── time/
            └── 0.9.1/
                └── linux_amd64/
                    └── terraform-provider-time_v0.9.1_x5
```

### Full Path Pattern

```
.terraform/providers/<registry>/<namespace>/<type>/<version>/<os_arch>/<binary>
```

| Component | Example | Description |
|-----------|---------|-------------|
| `.terraform/` | | Terraform working directory (hidden, per-project) |
| `providers/` | | Provider plugin storage |
| `<registry>` | `registry.terraform.io` | Provider registry hostname |
| `<namespace>` | `hashicorp` | Provider publisher/org |
| `<type>` | `aws` | Provider name |
| `<version>` | `5.84.0` | Exact version |
| `<os_arch>` | `linux_amd64` | OS and architecture |
| `<binary>` | `terraform-provider-aws_v5.84.0_x5` | Executable plugin |

### Plugin Resolution Order

When Terraform loads a provider plugin, it checks these locations in order:

1. **`.terraform/providers/`** — working directory (always first)
2. **Global plugin cache** — `~/.terraform.d/plugin-cache/` (if configured)
3. **Provider registry** — downloads if not found locally

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — `/usr/local/bin/terraform/providers/` | Terraform does not install providers to system directories. Providers are per-project, not global. |
| C — `~/.terraform/providers/` | The user home directory stores the **Terraform CLI configuration** (`~/.terraformrc`), not provider plugins by default. The global **cache** (if configured) is at `~/.terraform.d/plugin-cache/`, not `~/.terraform/providers/`. |
| D — Stored in memory | Provider plugins are **binary executables** written to disk. They cannot run from memory alone. |
| E — `terraform.d/providers/` in the Terraform installation path | Terraform providers are not bundled with the Terraform binary. They are downloaded per-project. |

## Global Plugin Cache

You can configure a shared plugin cache to avoid re-downloading providers for every project:

```hcl
# ~/.terraformrc
plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
```

When configured, Terraform:
1. Checks the cache first for the requested provider/version
2. If found, creates a **hard link** in `.terraform/providers/` (no download)
3. If not found, downloads to the cache, then links to `.terraform/providers/`

The cache structure mirrors the working directory structure:

```
~/.terraform.d/plugin-cache/
└── registry.terraform.io/hashicorp/aws/5.84.0/linux_amd64/terraform-provider-aws
```

## When Providers Are Re-downloaded

| Event | What Happens |
|-------|-------------|
| First `terraform init` | Downloads all providers |
| `terraform init` (no changes) | No download — uses existing `.terraform/providers/` |
| `terraform init -upgrade` | Re-checks registry for newer versions matching constraints |
| Version constraint changed | Downloads new version |
| `.terraform/` deleted | Must re-download on next `init` |

## Exam Tips

- Default location: **`.terraform/providers/`** in the current working directory
- Path pattern: `<registry>/<namespace>/<type>/<version>/<platform>`
- Each project has its own copy of provider plugins
- Global cache is **optional** — configured via `plugin_cache_dir` in `.terraformrc`
- `.terraform/` is in `.gitignore` — providers are never committed
- Deleting `.terraform/` and re-running `init` re-downloads everything
- Common exam scenario: "Where does Terraform store downloaded providers?" — `.terraform/providers/`
- Common exam trap: confusing `.terraform/` with `~/.terraform.d/` — the former is per-project, the latter is user-wide config
