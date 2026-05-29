# Map Variable Reference Exercise

**Domain:** Input Variables
**Topic:** Map variable bracket notation `["build-tag"]`

## Description

In an expression, how do you correctly reference the `build-tag` value from the variable declaration below

## Learning Objectives

- Examine the map variable
- Reference map values
- Different reference syntaxes
- Test the references

## Background

Terraform provides **complex types** for structured data. A `map(string)` is a collection of key-value pairs where all keys are strings and all values are strings. To access a specific value, you use the **index notation** — square brackets with the key name.

## Steps

### Part 1 — Examine the map variable

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The variable `metadata` is declared as a `map(string)`:

   ```hcl
   variable "metadata" {
     type = map(string)
     default = {
       owner     = "platform"
       build-tag = "v5.0.2"
       service   = "billing"
     }
   }
   ```

   | Key | Value |
   |-----|-------|
   | `owner` | `"platform"` |
   | `build-tag` | `"v5.0.2"` |
   | `service` | `"billing"` |

### Part 2 — Reference map values

2. **Access map values with bracket notation:**

   ```hcl
   var.metadata["build-tag"]
   ```

   This returns the string `"v5.0.2"`.

3. **Common usage patterns:**

   ```hcl
   # Using in a local value
   locals {
     build_tag = var.metadata["build-tag"]
   }

   # Using directly in a resource attribute
   resource "aws_instance" "web" {
     tags = {
       BuildTag = var.metadata["build-tag"]
     }
   }

   # Using in string interpolation
   Name = "app-${var.metadata["build-tag"]}"
   ```

### Part 3 — Different reference syntaxes

4. **Map access syntax options:**

   | Syntax | Works for | Example |
   |--------|-----------|---------|
   | `var.metadata["build-tag"]` | All maps (any key) | ✅ Correct for `build-tag` |
   | `var.metadata.build-tag` | Maps with valid identifiers only | ❌ Invalid — hyphen breaks dot notation |
   | `var.metadata["owner"]` | All maps (any key) | ✅ Correct |
   | `var.metadata.owner` | Maps with valid identifiers (no hyphens) | ✅ Works for `owner` |

5. **Why dot notation fails for `build-tag`:**

   ```hcl
   var.metadata.build-tag
   ```

   Terraform interprets `build-tag` as `build` minus `tag` — a subtraction of two undefined variables, which produces an error:

   ```
   Error: Reference to undeclared variable
   ```

   Maps with hyphens in keys **must** use bracket notation.

### Part 4 — Test the references

6. **Initialize and output:**

   ```bash
   terraform init
   terraform plan
   ```

   The outputs show the referenced values:

   ```
   Outputs:

   build_tag = "v5.0.2"
   owner = "platform"
   vpc_name = "app-v5.0.2"
   ```

## Files

- `main.tf` — config using map variable references
- `outputs.tf` — outputs showing referenced values
- `solution/` — reference implementation

