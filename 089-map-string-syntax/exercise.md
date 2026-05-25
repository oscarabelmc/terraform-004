# Map(string) Variable Syntax Exercise

**Exam Question:** Which of the following options correctly demonstrates the HCL syntax for assigning a value to a variable declared with the type `map(string)`?

## Background

A `map(string)` in HCL is a collection of key-value pairs where both keys and values are strings. The syntax uses curly braces `{}` with key-value pairs separated by equals signs `=` and commas between entries.

## Steps

### Part 1 — Examine correct map syntax

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   Two map(string) variables are defined:

   ```hcl
   variable "team_config" {
     type = map(string)
     default = {
       "environment" = "production"
       "owner"       = "dev-team"
       "cost-center" = "cc-1234"
     }
   }

   variable "region_map" {
     type = map(string)
     default = {
       us-east-1       = "North Virginia"
       eu-west-2       = "London"
       ap-southeast-1  = "Singapore"
     }
   }
   ```

### Part 2 — Map syntax rules

2. **Structure of a map literal:**

   ```
   {
     <key> = <value>,
     <key> = <value>,
     ...
   }
   ```

   | Rule | Example |
   |------|---------|
   | Enclosed in curly braces | `{ ... }` |
   | Key-value separated by `=` | `"key" = "value"` |
   | Entries separated by commas | `"a" = "1", "b" = "2"` |
   | Keys can be quoted or unquoted | `"environment"` or `environment` |
   | All values must be the declared type | All strings for `map(string)` |
   | Trailing comma allowed | Last entry can end with `,` |

3. **Valid map keys:**

   ```hcl
   # Quoted keys (recommended for special characters):
   { "build-tag" = "v1.0", "env" = "prod" }

   # Unquoted identifiers (valid identifiers only):
   { environment = "prod", owner = "dev-team" }

   # Mixed:
   { "cost-center" = "cc-123", environment = "prod" }
   ```

### Part 3 — Common syntax errors

4. **Invalid map syntax examples:**

   ```hcl
   # ❌ Square brackets — these are for lists
   default = ["key" = "value"]

   # ❌ Colons — these are not HCL map syntax
   default = { "key": "value" }

   # ❌ Mixed types — map(string) requires all values to be strings
   default = { "key" = 42 }  # number, not string

   # ❌ No equals sign
   default = { "key" "value" }
   ```

### Part 4 — Maps in resource blocks

5. **Using maps for tags (common pattern):**

   ```hcl
   resource "aws_vpc" "main" {
     cidr_block = "10.0.0.0/16"
     tags = {
       Environment = "production"
       Owner       = "dev-team"
     }
   }
   ```

   The `tags` argument in many AWS resources accepts `map(string)` — the same syntax.

### Put It Together

Which of the following options correctly demonstrates the HCL syntax for assigning a value to a variable declared with the type `map(string)`?

- A. `default = ["key1" = "value1", "key2" = "value2"]`
- B. `default = { "environment" = "production", "owner" = "dev-team" }`
- C. `default = { "key1": "value1", "key2": "value2" }`
- D. `default = "key1=value1,key2=value2"`
- E. `default = ["value1", "value2", "value3"]`

## Files

- `main.tf` — config with map(string) variables
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
