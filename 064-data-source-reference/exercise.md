# Data Source Reference Exercise

**Exam Question:** Your company has a centralized network team that manages all Azure Virtual Networks. Your application team needs to deploy virtual machines into the prod-network VNet, which the network team created. What is the correct approach in your Terraform configuration?

## Background

When infrastructure is managed by a different team or created outside your Terraform configuration, you should **read** it using a **data source** rather than **re-declaring** it with a `resource` block. Data sources are read-only constructs that query provider APIs and return resource attributes.

| Approach | Effect | Correct? |
|----------|--------|----------|
| **Data source** (`data` block) | Reads existing VNet, no changes | ✅ Correct |
| **Resource block** | Would attempt to manage/create a new VNet | ❌ Wrong — would conflict or duplicate |
| **Hardcoded values** | Works but brittle — breaks if VNet changes | ❌ Wrong — not DRY, not dynamic |

## Steps

### Part 1 — Examine the data source approach

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   Note the structure:

   - **Data source** — reads the existing VNet:
     ```hcl
     data "azurerm_virtual_network" "prod" {
       name                = "prod-network"
       resource_group_name = "networking-rg"
     }
     ```

   - **Resources** — use attributes from the data source:
     ```hcl
     resource "azurerm_subnet" "app" {
       virtual_network_name = data.azurerm_virtual_network.prod.name
       ...
     }

     resource "azurerm_network_interface" "app" {
       location = data.azurerm_virtual_network.prod.location
       ...
     }
     ```

### Part 2 — Understand what a data source does

2. **Data sources are read-only:**

   When `terraform plan` or `apply` runs, the data source:
   - Queries the Azure API for the specified VNet
   - Returns all attributes: `id`, `name`, `location`, `address_space`, `subnets`, etc.
   - Does **not** create, modify, or destroy anything
   - Does **not** add the VNet to state as a managed resource

3. **What happens if you used a resource instead?**

   ```hcl
   # ❌ WRONG — would try to manage/create the VNet
   resource "azurerm_virtual_network" "prod" {
     name                = "prod-network"
     resource_group_name = "networking-rg"
     address_space       = ["10.0.0.0/16"]
   }
   ```

   If the network team already created this VNet:
   - Running `apply` would try to **create it again** → error (already exists)
   - Or if imported, your team would now be responsible for managing it
   - Changes from either team could conflict

### Part 3 — Why data sources are the right approach

4. **Separation of concerns:**

   ```
   Network Team                        Application Team
   ┌──────────────────────┐           ┌──────────────────────┐
   │  Manages VNets       │           │  Deploys VMs         │
   │                      │           │                      │
   │  azurerm_virtual_    │           │  data.azurerm_       │
   │  network.prod        │  ──────→  │  virtual_network     │
   │  (resource block)    │   read    │  .prod               │
   │                      │   only    │  (data block)        │
   └──────────────────────┘           └──────────────────────┘
   ```

   - Network team **owns** the VNet (resource block in their config)
   - Application team **reads** the VNet (data block in their config)
   - No conflict, no duplication, no ownership ambiguity

5. **Attributes flow from data source to resources:**

   ```
   data.azurerm_virtual_network.prod
     ├── .name          → used in subnet's virtual_network_name
     ├── .location      → used in NIC and VM
     └── .resource_group_name → used in subnet
   ```

### Part 4 — Verify with plan

6. **Plan to see that no VNet changes are proposed:**

   ```bash
   terraform init
   terraform plan
   ```

   The plan shows:
   ```
   Terraform will perform the following actions:

     # azurerm_subnet.app will be created
     # azurerm_network_interface.app will be created
     # azurerm_linux_virtual_machine.app will be created
   ```

   Notice: **no VNet actions** — the data source reads it without proposing changes.

### Put It Together

Your company has a centralized network team that manages all Azure Virtual Networks. Your application team needs to deploy virtual machines into the prod-network VNet, which the network team created. What is the correct approach in your Terraform configuration?

- A. Create a new VNet with a different name alongside the existing one
- B. Use a data block to reference the existing VNet, then create your VM resources that use attributes from the data source
- C. Copy the VNet's attributes as hardcoded values into your configuration
- D. Use `terraform import` to take over management of the VNet from the network team
- E. Ask the network team to recreate the VNet using your Terraform configuration

## Files

- `main.tf` — data source reading existing VNet, resources using its attributes
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
