# Explanation

The correct answer is **B — Provider**.

---

## Why B Is Correct

A **provider** is a Terraform **plugin** — a standalone executable binary that Terraform Core launches as a subprocess and communicates with over RPC.

```
Terraform Core (main binary)
      │
      ├── Launches provider plugin as subprocess
      ├── Communicates via RPC protocol
      └── Plugin handles all API interactions

Provider Plugin (separate binary)
      │
      ├── Implements resource CRUD operations
      ├── Authenticates with infrastructure API
      └── Returns data to Core
```

### How to identify a provider plugin

| Trait | Evidence |
|-------|----------|
| Separate binary | Stored at `.terraform/providers/registry.terraform.io/hashicorp/random/3.6.3/linux_amd64/terraform-provider-random_v3.6.3_x5` |
| Downloaded by `init` | `terraform init` downloads provider binaries from the registry |
| Configured separately | `provider "aws" { region = "us-east-1" }` block |
| Versioned independently | Each provider has its own version, independent of Terraform Core |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — `required_providers` block | This is a **configuration block** that declares which provider plugins to download. It is not a plugin itself — it's part of the Terraform configuration language. |
| C — `terraform plan` | This is a **command** built into Terraform Core, not a plugin. It orchestrates the planning process by calling provider plugins. |
| D — State file (`terraform.tfstate`) | The state file is **data** (JSON) that Terraform Core reads and writes. It is not executable code and not a plugin. |
| E — Module from the Registry | A module is a **collection of `.tf` files** that define infrastructure. Modules use providers but are not plugins themselves. |

## Plugin Architecture Benefits

| Benefit | Why it matters |
|---------|---------------|
| **Decoupling** | Providers are developed and released independently from Terraform Core |
| **Extensibility** | Anyone can write a provider plugin using the Terraform Plugin SDK |
| **Isolation** | A crashing provider plugin doesn't crash Terraform Core |
| **Language independence** | Providers are Go binaries, but the Plugin Framework allows providers in any language |
| **Parallelism** | Multiple provider plugins run concurrently for independent resources |
