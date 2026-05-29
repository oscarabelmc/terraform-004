# Explanation

The correct answer is **B**.

> `merge(var.common_tags, local.resource_tags)`

---

## Why B Is Correct

The `merge()` function combines two or more maps into one:

```hcl
tags = merge(var.common_tags, local.resource_tags)
```

### How it works

```
merge(
  { Environment = "production", ManagedBy = "Terraform", Owner = "platform" },
  { Name = "billing-api", Service = "api-gateway" }
)

Result:
{
  Environment = "production"   ← from var.common_tags
  ManagedBy   = "Terraform"    ← from var.common_tags
  Owner       = "platform"     ← from var.common_tags
  Name        = "billing-api"  ← from local.resource_tags
  Service     = "api-gateway"  ← from local.resource_tags
}
```

### Key behaviors

| Behavior | Detail |
|----------|--------|
| **Combines all keys** | Every key from every input map appears in the result |
| **Last value wins** | If same key exists in multiple maps, the rightmost map's value is used |
| **Arity** | Works with 2+ maps: `merge(map1, map2, map3, ...)` |
| **Type** | All inputs must be maps |

### The common tags pattern

```
┌─────────────────────┐     ┌─────────────────────┐
│  var.common_tags    │     │  local.resource_tags │
│                     │     │                     │
│  Environment = prod │     │  Name = billing-api  │
│  ManagedBy   = TF   │     │  Service = api-gw    │
│  Owner       = plat │     │  Backup  = daily     │
│  Project     = bill │     └──────────┬──────────┘
└──────────┬──────────┘               │
           │                          │
           └──────────┬───────────────┘
                      ▼
           ┌─────────────────────┐
           │  merge() result     │
           │                     │
           │  Environment = prod │
           │  ManagedBy   = TF   │
           │  Owner       = plat │
           │  Project     = bill │
           │  Name = billing-api │
           │  Service = api-gw   │
           │  Backup  = daily    │
           └─────────────────────┘
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — `concat()` | `concat()` works on **lists**, not maps. Using it on maps would cause a type error. |
| C — `zipmap()` | `zipmap(list1, list2)` creates a map from two lists (keys and values). It doesn't merge existing maps. |
| D — `+` operator | Terraform does **not** support the `+` operator for maps. Using `+` would cause a syntax error. |
| E — `element()` | `element(list, index)` returns a single element from a list by index. It's not for combining maps. |

## Common Tag Patterns

### Pattern 1: Base common tags + resource overrides

```hcl
variable "common_tags" {
  type = map(string)
  default = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

resource "aws_instance" "web" {
  tags = merge(var.common_tags, {
    Name = "web-server"       # Resource-specific
  })
}
```

### Pattern 2: Override a common tag for a specific resource

```hcl
merge(
  { Environment = "production" },   # common default
  { Environment = "staging" }       # override for this resource
)
# Result: { Environment = "staging" }
```

### Pattern 3: Nested merge with locals

```hcl
locals {
  common_tags = {
    ManagedBy = "Terraform"
    Owner     = "platform"
  }
}

resource "aws_instance" "web" {
  tags = merge(local.common_tags, {
    Name = "web"
    Env  = var.environment
  })
}
```
