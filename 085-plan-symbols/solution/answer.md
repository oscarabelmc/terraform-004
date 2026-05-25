# Answer

The correct answer is **B**.

> The resource will be updated in place.

---

## Why B Is Correct

The tilde `~` in `terraform plan` output indicates an **update in-place** — the resource's attributes will be modified without destroying and recreating the resource:

```
  # aws_instance.web will be updated in-place
~ resource "aws_instance" "web" {
    ~ instance_type = "t2.micro" -> "t3.medium"   # ← ~ means modified
  }
```

### What update in-place means

| Aspect | Detail |
|--------|--------|
| **Resource identity** | Resource ID remains the same |
| **No downtime** | Usually no interruption (depends on the change) |
| **Attribute diff** | Shows old → new value for each changed attribute |
| **State update** | Terraform updates state with new attribute values |

### All plan symbols

```
+  = Create       (new resource added)
~  = Update       (in-place modification)    ← This question
-  = Destroy      (resource removed)
-/+ = Replace     (destroyed then recreated)
<= = Read        (data source query)
```

## Why the Others Are Wrong

| Option | Symbol | Why it's incorrect for `~` |
|--------|--------|---------------------------|
| A — Destroy | `-` | The minus sign indicates destruction, not tilde. |
| C — Create | `+` | The plus sign indicates creation, not tilde. |
| D — Replace | `-/+` | The combined `-/+` indicates replace. Tilde alone means update only. |
| E — Data source read | `<=` | The `<=` symbol indicates a data source read. |

## Recognizing Update Triggers

Changes that typically cause `~` (update in-place):

- `instance_type` (EC2 — requires stop/start but not replacement)
- `tags` (most resources)
- `size` (EBS volumes)
- `description` (security groups)
- `engine_version` (RDS — may cause downtime)

Changes that typically cause `-/+` (replace):

- `ami` (EC2 — can't change AMI without recreating)
- `cidr_block` (VPC — can't change CIDR without recreating)
- `name` (some resources that are immutable)
- `encrypted` (EBS — can't toggle encryption on existing volume)

## Exam Tips

- `~` = **update in-place** — safe, no replacement
- `+` = **create**
- `-` = **destroy**
- `-/+` = **replace** (destroy + create)
- `<=` = **read** (data source)
- Update in-place means the resource **keeps its identity** (same ID)
- Replace means the resource gets a **new identity** (new ID)
- Common exam trap: confusing `~` with `-/+` (update vs replace)
- Another trap: thinking tilde means any change (it specifically means in-place modification)
