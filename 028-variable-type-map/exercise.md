# Variable Type — Map Lookup Exercise

**Domain:** Input Variables
**Topic:** Variable type `map(string)` for region to image ID lookup

## Description

You are deploying virtual machines across multiple cloud regions. Since images are assigned a unique ID per region, you need to create a variable that looks up the correct ID based on the region name. Which code snippet uses the variable type that is most appropriate for this use case

## Learning Objectives

- Examine the map variable
- Look up images by region
- Compare other types (conceptual)

## Background

When deploying across regions, you need to map each region name → its corresponding image ID. Terraform offers several complex types:

| Type | Key-Value? | Lookup by Key? | Use Case |
|------|-----------|----------------|----------|
| `map(string)` | Yes | Yes | Dynamic key-based lookup |
| `list(string)` | No | No (numeric index) | Ordered collection |
| `set(string)` | No | No | Unique unordered values |
| `object({...})` | Fixed schema | Field access | Fixed-structure data |

This exercise demonstrates why `map(string)` is the correct choice.

## Steps

### Part 1 — Examine the map variable

1. **Open `variables.tf`:**

   ```bash
   cat variables.tf
   ```

   The `image` variable is declared as `map(string)` with region names as keys and AMI IDs as values:

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

### Part 2 — Look up images by region

2. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The config uses `var.image[var.region]` to look up the correct AMI for the chosen region:

   ```hcl
   locals {
     selected_region = var.region
     image_id        = var.image[var.region]
   }
   ```

3. **Test with different regions:**

   ```bash
   terraform init
   terraform plan -var="region=us-east-1"
   terraform plan -var="region=eu-west-1"
   ```

   Each plan resolves the correct image ID from the map.

### Part 3 — Compare other types (conceptual)

4. **Why `list(string)` doesn't work:**

   ```hcl
   variable "image" {
     type = list(string)
     default = ["ami-abc", "ami-def", "ami-ghi"]
   }
   ```

   Access would be `var.image[0]`, `var.image[1]`, `var.image[2]` — you'd need to remember which index maps to which region. No meaningful key-based lookup.

5. **Why `set(string)` doesn't work:**

   ```hcl
   variable "image" {
     type = set(string)
     default = ["ami-abc", "ami-def", "ami-ghi"]
   }
   ```

   A set is unordered and doesn't support keys. You can't look up "give me the image for us-east-1".

6. **Why `object({...})` is overly complex:**

   ```hcl
   variable "image" {
     type = object({
       region   = string
       image_id = string
     })
   }
   ```

   An object defines a **single** structure with fixed fields. You'd need a **list of objects** to store multiple region→image mappings:

   ```hcl
   type = list(object({
     region   = string
     image_id = string
   }))
   ```

   This works but is unnecessarily complex compared to a simple `map(string)`. The map is more concise, more readable, and directly supports key-based lookups without iteration.

## Files

- `main.tf` — configuration using `map(string)` lookup
- `variables.tf` — `image` variable as `map(string)` and `region` variable
- `outputs.tf` — outputs the resolved image ID
- `solution/` — reference implementation

