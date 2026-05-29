# Terraform Validate Exercise

**Domain:** IaC Workflow
**Topic:** `terraform validate` — syntax without remote calls

## Description

Bryan is drafting new Terraform code and wants to verify that the configuration is syntactically valid and internally consistent without contacting any remote services. Which command should he run

## Learning Objectives

- Run validate on a correct config
- What validate checks
- Intentionally break the config
- Validate vs Plan

## Background

Terraform provides multiple validation mechanisms at different stages:

| Command | Checks | Contacts remote services? |
|---------|--------|--------------------------|
| `terraform validate` | Syntax, attribute names, types, references | ❌ No |
| `terraform plan` | Everything validate does + state comparison | ✅ Yes (reads state) |
| `terraform fmt` | Code formatting only | ❌ No |

`terraform validate` is the fastest feedback loop — it runs entirely offline and checks the configuration's internal consistency.

## Steps

### Part 1 — Run validate on a correct config

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   The config has a VPC, subnet, and EC2 instance with valid references.

2. **Run validate:**

   ```bash
   terraform init    # required first — validate needs provider schemas
   terraform validate
   ```

   Output:

   ```
   Success! The configuration is valid.
   ```

### Part 2 — What validate checks

3. **Validate checks (without contacting any APIs):**

   | Check | Example |
   |-------|---------|
   | **Syntax** | Missing closing brace, invalid HCL |
   | **Attribute names** | `amie` instead of `ami` |
   | **Resource types** | `aws_instance` is valid, `aws_instanse` is not |
   | **Reference consistency** | `aws_vpc.main.id` — does `aws_vpc.main` exist? |
   | **Variable types** | `string` vs `number` mismatch |
   | **Required arguments** | Missing required field like `cidr_block` |
   | **Circular dependencies** | Two resources referencing each other |
   | **Module source existence** | Module source format is valid |

4. **What validate does NOT check:**

   - ❌ Provider credentials (needs `plan` or `apply`)
   - ❌ API availability (needs `plan` or `apply`)
   - ❌ Resource existence in the real world (needs `plan`)
   - ❌ State file consistency (needs `plan`)

### Part 3 — Intentionally break the config

5. **Introduce a syntax error:**

   ```bash
   # Remove a closing brace:
   sed -i 's/}$//' main.tf
   terraform validate
   ```

   Output shows the exact line and error:

   ```
   Error: Unclosed configuration block
   ```

6. **Introduce a reference error:**

   Edit `main.tf` and change `aws_vpc.main.id` to `aws_vpc.wrong.id`:

   ```bash
   terraform validate
   ```

   Output:

   ```
   Error: Reference to undeclared resource
     on main.tf line 28:
    28:   vpc_id = aws_vpc.wrong.id
   ```

7. **Restore the correct config:**

   ```bash
   git checkout -- main.tf
   ```

### Part 4 — Validate vs Plan

8. **Comparison:**

   ```bash
   terraform validate   # 0.5 seconds — offline, no credentials needed
   terraform plan        # 15+ seconds — contacts state backend, needs creds
   ```

   Use `validate` during development (every file save), `plan` before committing or applying.

## Files

- `main.tf` — example config for validation
- `outputs.tf` — output values
- `solution/` — reference implementation

