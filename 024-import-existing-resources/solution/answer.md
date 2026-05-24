# Answer

The three correct answers are: **B, C, and D**.

---

## B — Add import blocks mapping each address to its real-world ID

An `import` block tells Terraform: "There is already a real-world resource with this ID. Associate it with this resource address in my configuration."

```hcl
import {
  to = random_pet.server
  id = "existing-abc123"
}
```

The `id` is the resource's unique identifier in the real system (the provider's ID, not a Terraform ID). For cloud resources this is typically an ARN, resource name, or URI.

## C — Run `terraform apply` to import them in state with no changes

After adding import blocks, `terraform apply`:

1. Reads each `import` block
2. Calls the provider to fetch the real resource
3. Writes it into state at the specified address
4. Compares state to config — since they match, **no changes are made to the resource**

This is the step that actually moves the resource into Terraform management without modifying it.

## D — Write Terraform resource blocks that match the existing settings

Terraform needs a `resource` block for every resource it manages. The block must match the current real-world configuration:

```hcl
resource "random_pet" "server" {
  prefix = "existing"
  length = 2
}
```

If the config doesn't match, Terraform will try to modify (or replace) the resource on `apply`. The goal is to write config that mirrors the existing state so the import applies with zero changes.

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — `terraform apply` to recreate | This would **destroy and recreate** the resources. The question says "without impacting the resources themselves." |
| E — Define data sources | Data sources are **read-only**. They can fetch information but cannot adopt a resource into Terraform management. |
| F — `terraform apply -refresh-state` | `-refresh-state` is **not a valid flag** on `terraform apply`. The correct mechanism for adopting resources is `import` blocks (or `terraform import` CLI). |

## The Complete Import Workflow

```
1. Write resource blocks    ──>  main.tf has matching config
2. Add import blocks        ──>  maps addresses to real IDs
3. terraform apply          ──>  adopts into state, no changes
                              │
                              ├─ terraform state list → shows resources
                              └─ terraform plan       → no changes
```

After this, you can:
- Remove the `import` blocks (they've served their purpose)
- Manage the resources normally via `terraform plan` and `terraform apply`
- Make future changes through Terraform — drift detection, updates, etc.

## Exam Tips

- Three steps: **write config → add import → run apply**
- `import` blocks are the **modern approach** (Terraform 1.5+). The older method is `terraform import <address> <id>` CLI command.
- The key constraint: **"without impacting"** means no destruction, no recreation, no modification
- After import, you can remove the import blocks — they aren't needed for ongoing management
- Common exam trap: confusing `terraform import` (adopts) with `terraform apply` (creates/modifies/destroys)
