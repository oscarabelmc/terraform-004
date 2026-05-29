# Explanation

The correct answer is **B**.

> Use Terraform state commands `terraform state show` to match the tracked VM's ID with the list of active VMs.

---

## Why B Is Correct

`terraform state show` reads the state file and displays all attributes of a tracked resource, including its **real-world resource ID**:

```bash
# List managed resources
terraform state list
# aws_instance.web[0]
# aws_instance.web[1]

# Show details of each managed VM
terraform state show aws_instance.web[0]
# id = "i-0a1b2c3d4e5f67890"
# tags.Name = "managed-vm-0"

terraform state show aws_instance.web[1]
# id = "i-0a1b2c3d4e5f67891"
# tags.Name = "managed-vm-1"
```

### The identification process

```
Cloud Console VM List:
  i-0a1b2c3d  managed-vm-0    ← Matches state: managed by Terraform
  i-0e5f6g7h  managed-vm-1    ← Matches state: managed by Terraform
  i-0i9j8k7l  rahul-vm-01     ← NOT in state: NOT managed by Terraform
  i-0m3n4o5p  rahul-vm-02     ← NOT in state: NOT managed by Terraform
```

### Why this approach is the best

| Aspect | Benefit |
|--------|---------|
| **No changes** | Read-only state commands — no infrastructure modifications |
| **Precise** | Matches on the exact resource ID stored in state |
| **Fast** | Reads local state — no API calls needed |
| **Safe** | Cannot accidentally modify or delete resources |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — `terraform apply` to see changes | `apply` **modifies infrastructure**. Running apply to see what changes is dangerous — it will prompt you to confirm changes. Always use `plan` or `state show` for read-only inspection. |
| C — Delete and recreate | Destructive and unnecessary. You can identify managed resources without destroying anything. |
| D — `terraform destroy` to see deletions | `destroy` **deletes infrastructure**. It's destructive and cannot be undone. Never use destroy for identification purposes. |
| E — `terraform import` all VMs | Import **adds resources to state**. It changes state rather than just inspecting it. Import also requires matching configurations. |

## State Inspection Commands

| Command | Purpose | Read-only? |
|---------|---------|------------|
| `terraform state list` | List all resource addresses in state | ✅ Yes |
| `terraform state show <ADDR>` | Show all attributes of a specific resource | ✅ Yes |
| `terraform state pull` | Output the entire state file | ✅ Yes |
| `terraform show` | Show state or plan file contents | ✅ Yes |
| `terraform plan` | Preview changes (may refresh state) | ✅ Yes (no apply) |

## Determining Management Ownership

```
Scenario: 50 VMs in account, 10 managed by Terraform

1. terraform state list | grep aws_instance
   → 10 resource addresses from state

2. For each: terraform state show <ADDR> | grep "id ="
   → Collect the 10 AWS instance IDs

3. Cross-reference with cloud console
   → These 10 IDs = Terraform-managed
   → Remaining 40 IDs = manually created
```

This approach is:
- **Zero risk** — no modifications to infrastructure
- **Zero cost** — no API calls consumed
- **Fast** — works even with large state files
