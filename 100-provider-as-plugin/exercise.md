# Provider as a Plugin Exercise

**Exam Question:** Which of the following is considered a Terraform plugin?

## Background

Terraform has a **plugin-based architecture**. The core binary handles state management, configuration parsing, and the dependency graph, but it delegates all infrastructure operations to **plugins**. The most important type of plugin is the **provider**.

```
┌──────────────────────────────────────────────┐
│              Terraform Core                   │
│  (parsing, graph, state, plan/apply engine)   │
└──────┬──────────────────────┬────────────────┘
       │                      │
       ▼                      ▼
┌──────────────┐    ┌──────────────────┐
│  Provider    │    │    Provider      │
│  Plugin: AWS │    │  Plugin: Azure   │
│  (executable)│    │  (executable)    │
└──────┬───────┘    └───────┬──────────┘
       │                    │
       ▼                    ▼
   AWS APIs              Azure APIs
```

## Steps

### Part 1 — Understand plugins in Terraform

1. **What is a plugin?**

   A plugin is a **separate executable binary** that Terraform Core launches and communicates with via RPC. Plugins extend Terraform's capabilities beyond its built-in features.

2. **Types of Terraform plugins:**

   | Plugin Type | Purpose | Example |
   |-------------|---------|---------|
   | **Provider** | Interfaces with infrastructure APIs to manage resources | `hashicorp/aws`, `hashicorp/azurerm`, `hashicorp/google` |
   | **Provisioner** | (Legacy) Runs scripts on local/remote machines after resource creation | `file`, `remote-exec`, `local-exec` |

   **Providers are by far the most important plugin type.** Every resource and data source belongs to a provider.

### Part 2 — How provider plugins work

3. **Examine the config:**

   ```bash
   cat main.tf
   ```

   The `required_providers` block tells Terraform which provider plugins to download:

   ```hcl
   terraform {
     required_providers {
       random = {
         source  = "hashicorp/random"
         version = "~> 3.6"
       }
     }
   }
   ```

4. **Initialize and observe plugin download:**

   ```bash
   terraform init
   ```

   Output:
   ```
   Initializing provider plugins...
   - Finding hashicorp/random versions matching "~> 3.6"...
   - Installing hashicorp/random v3.6.3...
   - Installed hashicorp/random v3.6.3 (signed by HashiCorp)
   ```

   The provider plugin binary is downloaded to `.terraform/providers/`.

5. **Find the plugin binary:**

   ```bash
   ls -R .terraform/providers/
   ```

   ```
   .terraform/providers/registry.terraform.io/hashicorp/random/3.6.3/linux_amd64/
   └── terraform-provider-random_v3.6.3_x5
   ```

   This is a compiled Go binary — a **plugin executable**.

### Part 3 — Providers vs Terraform Core

6. **The separation of concerns:**

   ```
   ┌────────────────────────────────────────────────────────────┐
   │                    terraform plan                          │
   │                                                            │
   │  1. Core reads .tf files and builds resource graph         │
   │  2. Core asks provider plugin: "What is the schema for     │
   │     random_pet?"                                           │
   │  3. Provider plugin responds with attribute schema          │
   │  4. Core validates config against schema                   │
   │  5. Core asks provider: "Does this resource exist?"         │
   │  6. Provider plugin calls Random API (or any API)           │
   │  7. Core compares state vs config, generates plan            │
   └────────────────────────────────────────────────────────────┘
   ```

   The provider plugin is a **separate process** that Terraform Core launches. They communicate over a local RPC protocol.

### Part 4 — Provider plugin lifecycle

7. **Plugin lifecycle:**

   ```
   terraform init
       │
       ├── Core reads required_providers
       ├── Core downloads provider plugin binary
       └── Stores in .terraform/providers/
   
   terraform plan / apply
       │
       ├── Core launches provider plugin as subprocess
       ├── Provider authenticates with target API
       ├── Core sends RPC calls (read, create, update, delete)
       ├── Provider translates to API calls
       └── Core terminates provider process when done
   ```

### Put It Together

Which of the following is considered a Terraform plugin?

- A. `required_providers` block
- B. Provider
- C. `terraform plan` command
- D. State file (`terraform.tfstate`)
- E. Module from the Terraform Registry

## Files

- `main.tf` — config that declares a provider and uses it
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
