# Explanation

The correct answer is **B**.

> `default = { "environment" = "production", "owner" = "dev-team" }`

---

## Why B Is Correct

This uses the correct `map(string)` literal syntax in HCL:

```hcl
{
  "environment" = "production",
  "owner"       = "dev-team"
}
```

### Structure breakdown

| Element | Syntax | In answer B |
|---------|--------|-------------|
| Map delimiter | `{ }` | ✅ Curly braces |
| Key-value separator | `=` | ✅ Equals sign |
| Key | String (quoted or unquoted) | ✅ Quoted `"environment"` |
| Value | String | ✅ `"production"` |
| Entry separator | `,` | ✅ Comma |
| Value type matches declaration | `map(string)` → all strings | ✅ Both values are strings |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Square brackets `[]` | Square brackets are for **lists/tuples**, not maps. Maps use curly braces `{}`. |
| C — Colons `:` | Colons are used in **JSON** and some other languages, but HCL uses **equals signs** `=` for map key-value pairs. |
| D — Single string `"key1=value1,key2=value2"` | This is a single **string**, not a map. Terraform would not parse it as key-value pairs. |
| E — List of strings `["value1", "value2"]` | This is a **list(string)**, not a map. Lists are ordered collections without named keys. |

## Map Syntax Comparison

| Language | Syntax |
|----------|--------|
| **HCL (Terraform)** | `{ "key" = "value" }` |
| JSON | `{ "key": "value" }` |
| YAML | `key: value` |
| Python dict | `{ "key": "value" }` |
| JavaScript object | `{ "key": "value" }` |

## Map Declaration Variants

All of these are valid `map(string)` defaults:

```hcl
# Quoted keys
default = { "environment" = "prod" }

# Unquoted keys (valid identifiers only)
default = { environment = "prod" }

# Multi-line with trailing comma (common style)
default = {
  environment = "prod"
  owner       = "dev-team"
}

# Single line
default = { environment = "prod", owner = "dev-team" }
```
