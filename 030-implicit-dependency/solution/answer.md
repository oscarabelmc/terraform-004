# Answer

The correct answer is **B**.

> `aws_instance.web_server`

---

## Why B Is Correct

The **implicit dependency** is `aws_instance.web_server` because `aws_eip.public_ip` references an attribute of that resource:

```hcl
resource "aws_eip" "public_ip" {
  vpc      = true
  instance = aws_instance.web_server.id   # ← implicit dependency
}
```

Any reference to `resource_type.name.attribute` creates an implicit dependency. Terraform automatically detects that `aws_eip.public_ip` depends on `aws_instance.web_server` and ensures the instance is created before the Elastic IP.

## Implicit vs Explicit in This Code

```
aws_s3_bucket.company_data
         ↓  (explicit: depends_on)
aws_instance.web_server
         ↓  (implicit: attribute reference)
aws_eip.public_ip
```

| Dependency | Type | How It's Declared |
|------------|------|-------------------|
| `web_server` → `company_data` | **Explicit** | `depends_on = [aws_s3_bucket.company_data]` |
| `public_ip` → `web_server` | **Implicit** | `instance = aws_instance.web_server.id` |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — `aws_s3_bucket.company_data` | This is an **explicit** dependency (declared via `depends_on`), not an implicit one. The question specifically asks for the implicit dependency. |
| C — `aws_eip.public_ip` | The Elastic IP is the resource that has the dependency, not the dependency itself. Its creation depends on `web_server`, not the other way around. |
| D — There is no implicit dependency | There is one: `aws_eip → aws_instance`. The attribute reference `aws_instance.web_server.id` creates it automatically. |

## How Terraform Detects Dependencies

Terraform scans all attribute references in resource blocks:

```hcl
# These all create implicit dependencies:
instance = aws_instance.web_server.id          # → depends on aws_instance.web_server
sg_ids   = aws_security_group.web_sg.id         # → depends on aws_security_group.web_sg
subnet   = module.vpc.public_subnet_id          # → depends on module.vpc
bucket   = aws_s3_bucket.data.arn               # → depends on aws_s3_bucket.data
```

Any string in the config that contains `resource_type.name.attribute` (or `module.name.output`) is automatically tracked as a dependency.

## When to Use `depends_on`

Use explicit `depends_on` when:

1. **No implicit reference exists** — you need to order resources that don't directly reference each other
2. **Module-level ordering** — a module depends on another module's side effects, not its outputs
3. **Provisioner ordering** — `destroy` provisioners need to run before child resources are destroyed

```hcl
# Explicit dependency when there's no attribute reference
resource "aws_instance" "web_server" {
  depends_on = [aws_s3_bucket.company_data]
  # No attribute reference to the bucket, but needs it to exist first
}
```

## Exam Tips

- **Implicit** = Terraform infers it from attribute references (automatic)
- **Explicit** = you declare it with `depends_on` (manual override)
- `depends_on` takes a **list of resource/module addresses**: `[resource_type.name, module.name]`
- Terraform's dependency graph ensures: creation goes **dependency first**, destruction goes in **reverse**
- If you see `resource.other_resource.attribute`, that's an implicit dependency
- If you see `depends_on = [...]`, that's an explicit dependency
- The question asks for "implicit dependency" — look for attribute references, not `depends_on`
