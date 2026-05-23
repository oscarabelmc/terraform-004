# Answer

The correct answer is **C — `length(var.subnet_cidrs)`**.

## Why

`length()` is the built-in Terraform function that returns the number of elements in:

| Input type | Returns | Example | Result |
|------------|---------|---------|--------|
| **List** | Number of elements | `length(["a","b","c"])` | `3` |
| **Map** | Number of key-value pairs | `length({a=1, b=2})` | `2` |
| **String** | Number of characters | `length("hello")` | `5` |

In the exam scenario:

```hcl
variable "subnet_cidrs" {
  default = ["10.0.5.0/24", "10.0.0.0/24", "10.0.2.0/24"]
}

# returns 3
length(var.subnet_cidrs)
```

## Common Use Cases for `length()`

| Pattern | Example |
|---------|---------|
| Dynamic `count` | `count = length(var.subnet_cidrs)` |
| Conditional logic | `length(var.subnet_cidrs) > 2 ? "large" : "small"` |
| Validation | `condition = length(var.name) > 1` |
| String length check | `length(var.password) >= 8` |
| Iteration boundaries | Used inside `for` expressions to determine range |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — `count()` | **No such function.** `count` is a **meta-argument** (used in resource blocks), not a function. Use `length()` to get the element count for setting `count`. |
| B — `len()` | **No such function.** `len()` is Python/JavaScript convention, not Terraform. The correct Terraform function is `length()`. |
| C — `length()` | **Correct.** |
| D — `size()` | **No such function.** |
| E — `element()` | This is a real function, but it returns the **element at a specific index** (e.g., `element(["a","b"], 1)` → `"b"`), not the count of elements. |

## Exam Tips

- `length()` works on **lists**, **maps**, and **strings** — the exam tests all three
- `count` is a **meta-argument**, not a function — don't confuse them
- `element()` returns a value from a list by index, not the count
- Common pattern: `count = length(var.x)` to create one resource per element
- For strings, `length("terraform")` returns `9` (characters)
