# Explanation

The correct answer is **A**.

> `variable "image" { type = map(string) }`

---

## Why A Is Correct

A `map(string)` stores **key-value pairs** where:

- **Key** = region name (e.g., `"us-east-1"`)
- **Value** = image ID (e.g., `"ami-0c55b159cbfafe1f0"`)

```hcl
variable "image" {
  type = map(string)
  default = {
    us-east-1 = "ami-0c55b159cbfafe1f0"
    us-west-2 = "ami-0c55b159cbfafe1f1"
    eu-west-1 = "ami-0c55b159cbfafe1f2"
  }
}
```

To look up an image by region:

```hcl
local.image_id = var.image["us-east-1"]
# or with a variable:
local.image_id = var.image[var.region]
```

This is exactly what the question describes — a **dynamic lookup based on region name**. The map type directly supports this.

## Why the Others Are Wrong

### B — `list(string)`

```hcl
variable "image" {
  type = list(string)
  default = ["ami-abc", "ami-def", "ami-ghi"]
}
```

| Problem | Detail |
|---------|--------|
| No key association | You can't tell which region each index maps to |
| Numeric indexing | `var.image[0]` — you need to remember that index 0 = us-east-1 |
| Brittle | Adding a region shifts all indices |
| Unreadable | Code doesn't express the intent of region→image lookup |

### C — `set(string)`

```hcl
variable "image" {
  type = set(string)
  default = ["ami-abc", "ami-def", "ami-ghi"]
}
```

| Problem | Detail |
|---------|--------|
| No keys | Same as list — no region → image mapping |
| No ordering | Elements aren't ordered, so even numeric indexing is unreliable |
| No duplicates | If two regions happen to share the same AMI, the set deduplicates it — losing data |

### D — `object({ region = string, image_id = string })`

```hcl
variable "image" {
  type = object({
    region   = string
    image_id = string
  })
}
```

| Problem | Detail |
|---------|--------|
| Single structure | An object defines **one** region→image pair, not a collection |
| No collection | You can't store multiple region→image pairs in a single object |
| Would need `list(object(...))` | A list of objects works, but is over-engineered compared to a simple map |
| Verbose | More syntax, less readable, more complex to iterate |

The object type is best for **fixed-structure data** where each field has meaning:

```hcl
# Good use of object: a single resource definition
variable "instance" {
  type = object({
    name   = string
    size   = string
    region = string
  })
}
```

For a **dynamic lookup table**, `map(string)` is idiomatic and concise.

## Type Comparison Summary

| Need | `map(string)` | `list(string)` | `set(string)` | `object({...})` |
|------|:---:|:---:|:---:|:---:|
| Key-based lookup | ✅ | ❌ | ❌ | ❌ |
| Multiple entries | ✅ | ✅ | ✅ | ❌ |
| Dynamic keys | ✅ | ❌ | ❌ | ❌ |
| Concise syntax | ✅ | ✅ | ✅ | ❌ |
| Meaningful access | `["key"]` | `[0]` | ❌ | `.field` |
