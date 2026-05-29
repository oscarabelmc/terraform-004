# Explanation

The correct answer is **A**.

> Use the `import` block to import the existing resources under Terraform management.

---

## Why A Is Correct

The `import` block (Terraform 1.5+) is the modern, declarative way to bring existing resources into Terraform management without disruption. The workflow is:

```
┌─────────────────────────────────────────────────────────┐
│              Import Workflow (no disruption)              │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  1. Write resource blocks ──→ main.tf has matching config │
│  2. Add import blocks     ──→ maps addresses to real IDs │
│  3. terraform apply       ──→ adopts into state          │
│                                                          │
│  Result: Resources are under Terraform management with   │
│          zero changes to the actual infrastructure.      │
└─────────────────────────────────────────────────────────┘
```

### What the Import Block Looks Like

```hcl
import {
  to = random_pet.server
  id = "existing-abc123"
}

import {
  to = azurerm_resource_group.main
  id = "/subscriptions/.../resourceGroups/my-rg"
}
```

| Element | Purpose |
|---------|---------|
| `to` | The Terraform resource address (must match a `resource` block) |
| `id` | The real-world identifier assigned by the cloud provider |

After `terraform apply`, the resources are in state. You can then **remove the import blocks** — they're no longer needed.

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — Delete and recreate | This would cause **disruption** (downtime, data loss). The question explicitly says "without disrupting them." |
| C — Use data sources | Data sources are **read-only**. They can fetch information about existing resources but cannot bring them under Terraform management. |
| D — `terraform apply` automatically detects resources | Terraform does **not** auto-detect existing resources. It only manages resources defined in configuration. You must explicitly import them. |
| E — Copy resources to a different region | Moving regions doesn't help — the original resources in the original region remain unmanaged. And copying would create duplicates. |

## Import Block vs `terraform import` CLI

| Aspect | `import` Block (modern) | `terraform import` CLI (legacy) |
|--------|----------------------|-------------------------------|
| Introduced | Terraform 1.5+ | Terraform 0.7+ |
| Declarative? | ✅ Yes (in config) | ❌ No (imperative command) |
| Can plan first? | ✅ Yes (`terraform plan` shows the import) | ❌ No (imports immediately) |
| Repeatable | ✅ Yes (in version control) | ❌ No (must re-run command) |
| Syntax | HCL block in `.tf` files | CLI: `terraform import <addr> <id>` |

The `import` block is preferred because it allows you to:
- Preview the import with `terraform plan`
- Keep the import as code (version-controlled)
- Apply the import as part of normal workflow

## Import Workflow in Detail

### Step 1: Write matching configuration

```hcl
resource "azurerm_resource_group" "main" {
  name     = "production-rg"
  location = "eastus"
}
```

The config must **match** the existing resource's settings. If it doesn't, Terraform will try to modify the resource on apply.

### Step 2: Add import blocks

```hcl
import {
  to = azurerm_resource_group.main
  id = "/subscriptions/.../resourceGroups/production-rg"
}
```

### Step 3: Run terraform plan (optional but recommended)

```bash
terraform plan
```

The plan shows "Importing resource" — no changes to the resource itself (assuming config matches).

### Step 4: Run terraform apply

```bash
terraform apply
```

### Step 5: Remove import blocks

After successful import, delete the `import` blocks. The resources are now managed normally.
