# Answer

## State Management Commands

### 1. `terraform state list`

Lists every resource tracked in the state file:

```
random_pet.server
local_file.server_info
```

Terraform state maps each resource address (e.g., `random_pet.server`) to the real-world resource it manages.

### 2. `terraform state show <resource>`

Displays all attributes of a specific resource as stored in state:

```json
# random_pet.server:
resource "random_pet" "server" {
    id       = "prod-..."
    keepers  = {}
    length   = 2
    prefix   = "prod"
    ...
}
```

This is useful for debugging — you can see the actual values that Terraform recorded after apply.

### 3. `terraform state mv <source> <destination>`

**Renames** the resource in state without destroying it. After `mv`:
- `terraform plan` will show that `random_pet.server_v2` exists but `random_pet.server` needs to be **created** (because the config still references `random_pet.server`)
- The real resource is untouched — only the state key changes

### 4. `terraform state rm <resource>`

**Removes** the resource from Terraform state without destroying the real resource. After `rm`:
- `terraform plan` will show `local_file.server_info` needs to be **created** (Terraform no longer knows it exists)
- The actual file still exists on disk

### 5. `terraform import <address> <id>`

Brings an existing real-world resource back under Terraform management by adding it to state.

## Key Exam Concepts

| Command | Purpose | Impact on Real Resource |
|---------|---------|------------------------|
| `terraform state list` | List all resources in state | None |
| `terraform state show` | Show attributes of a resource | None |
| `terraform state mv` | Rename resource in state | None |
| `terraform state rm` | Remove resource from state | **None** (resource persists) |
| `terraform import` | Add existing resource to state | None |
| `terraform apply` with removed resource | Creates a new resource | Creates a new resource |
| `terraform destroy` | Destroys all tracked resources | Destroys tracked resources |

## Exam Tips

- `terraform state rm` **does not** destroy infrastructure — it only removes Terraform's tracking. This is a common exam trick compared to `terraform destroy`.
- `terraform state mv` is useful for refactoring configs without rebuilding resources (e.g., renaming resources or nesting them into modules).
- After `terraform state rm`, `terraform plan` shows resources as **new** (to be created), not as changes.
- The `terraform import` command requires you to know the resource's external ID format (e.g., AWS instance ID `i-abc123`).
