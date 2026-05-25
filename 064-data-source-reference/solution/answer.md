# Answer

The correct answer is **B**.

> Use a data block to reference the existing VNet, then create your VM resources that use attributes from the data source.

---

## Why B Is Correct

A `data` block is Terraform's mechanism for **reading existing infrastructure** without managing it:

```hcl
# ✅ Reads the existing VNet — no management, no changes
data "azurerm_virtual_network" "prod" {
  name                = "prod-network"
  resource_group_name = "networking-rg"
}

# ✅ Uses the VNet's attributes without owning the VNet
resource "azurerm_subnet" "app" {
  virtual_network_name = data.azurerm_virtual_network.prod.name
  ...
}
```

### Key characteristics of data sources:

| Characteristic | What it means |
|---------------|---------------|
| **Read-only** | Queries the API, returns attributes, makes no changes |
| **No state ownership** | The VNet is not added to state as a managed resource |
| **Dynamic** | Reads current values each time (during plan/apply) |
| **Implicit dependency** | Resources using data source attributes depend on it being read first |

### The separation of concerns pattern

```
Network Team                     Application Team
(resource block)                 (data block)
                                ┌────────────────────┐
┌────────────────────┐          │ data "azurerm_     │
│ resource "azurerm_ │   read   │ virtual_network"   │
│ virtual_network"   │ ←────── │ "prod"             │
│ "prod" {...}       │  only    │                    │
└────────────────────┘          │ .name → subnet     │
                                │ .location → VM     │
                                └────────────────────┘
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Create a new VNet | The requirement is to deploy VMs into the **existing** prod-network VNet, not create a separate one. |
| C — Hardcode VNet attributes | Brittle and not DRY. If the VNet changes (e.g., location moves), the hardcoded values become stale. A data source always reads current values. |
| D — Import the VNet | Importing would transfer management responsibility to your team — you'd now own the VNet alongside the network team. This violates separation of concerns and could cause conflicts. |
| E — Ask network team to recreate | Unnecessary overhead. The VNet already exists — there's no need to recreate it. Just read it with a data source. |

## Data Source vs Resource Block

| Aspect | Data Source (`data`) | Resource (`resource`) |
|--------|---------------------|----------------------|
| **Purpose** | Read existing infra | Create/manage infra |
| **Side effects** | None (read-only) | Creates, updates, destroys |
| **State ownership** | No — not in state as managed | Yes — fully managed |
| **Plan output** | No changes proposed | Shows create/update/destroy |
| **Use case** | Reference infra owned by others | Deploy and manage infra you own |

## Common Data Source Use Cases

| Scenario | Data Source |
|----------|------------|
| Read existing VNet | `data.azurerm_virtual_network` |
| Get latest AMI | `data.aws_ami.ubuntu` |
| Read current AWS region | `data.aws_region.current` |
| Look up IP ranges | `data.aws_ip_ranges` |
| Read existing resource group | `data.azurerm_resource_group` |
| Fetch secrets from Vault | `data.vault_generic_secret` |

## Exam Tips

- **Data sources = read-only** — they never create or modify infrastructure
- Use data sources to reference infrastructure owned by **other teams** or **other Terraform configs**
- Data source attributes are accessed with `data.<type>.<name>.<attribute>` (e.g., `data.azurerm_virtual_network.prod.location`)
- Data sources create **implicit dependencies** — resources using them wait for the data to be fetched
- If the data source fails (e.g., VNet doesn't exist), the entire plan fails — this is a safety feature
- Common exam trap: using a `resource` block instead of a `data` block when you only need to read existing infrastructure
- Another trap: hardcoding values from existing resources instead of using a data source to read them dynamically
