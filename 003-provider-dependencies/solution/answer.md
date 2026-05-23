# Answer

The three correct answers are: **A, C, and E**.

---

## A — Using a resource or data block that belongs to that provider

This is the most common way. When you write:

```hcl
resource "random_pet" "server" {}
```

Terraform sees `random_pet` belongs to `hashicorp/random` and automatically establishes a dependency on that provider.

- Resource type prefix → maps to a provider source
- Data sources work the same way: `data "local_file" "x" {}` → depends on `hashicorp/local`

---

## C — Existing resource instances in state

When Terraform state contains resources from a provider, that provider remains a dependency — even if you remove all resources from the config.

You can observe this:

1. Apply a config with `local_file`
2. Remove `local_file` from `main.tf` entirely
3. Run `terraform plan` → Terraform still resolves the `local` provider because state still holds `local_file.server_info`

The state file's `resources` array lists each resource by type, and Terraform uses the type prefix to determine which provider to load.

---

## E — Declaring a provider block (including version constraints)

Simply declaring a provider via `required_providers` or an explicit `provider` block establishes a dependency, even with zero resources:

```hcl
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "local" {}
```

Run `terraform init` and the provider is downloaded — Terraform recognizes it as a dependency because it's been declared. This is useful for provider-only configurations (e.g., provider aliases for multi-region setups).

---

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| **B — Running `terraform init`** | `init` is the *mechanism* that downloads providers, but it doesn't *establish* the dependency. The dependency must exist first (via A, C, or E) for `init` to have anything to download. |
| **D — `depends_on` pointing to a provider** | `depends_on` works at the **resource level**, not the provider level. You cannot write `depends_on = [provider.random]` — Terraform does not allow provider references in `depends_on`. |

## Exam Tips

- Three ways to establish a provider dependency: **resource/data block** → A, **state** → C, **declaration** → E.
- `terraform init` does NOT establish a dependency — it fulfills one that already exists.
- `depends_on` cannot target a provider; it only targets resources and modules.
- The `required_providers` block alone (inside `terraform {}`) is part of answer E.
