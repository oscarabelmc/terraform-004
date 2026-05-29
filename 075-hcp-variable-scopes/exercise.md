# HCP Terraform Variable Scopes Exercise

**Domain:** HCP Terraform
**Topic:** HCP Terraform variable scopes

## Description

In HCP Terraform, what scope levels are available for providing variables to workspaces? (Select three.)

## Learning Objectives

- Examine the variable declaration
- The three variable scopes
- Variable precedence
- What is NOT a valid scope

## Background

HCP Terraform provides flexible variable scoping to control which workspaces can access which variables. Variables can be defined at three levels, ranging from narrow (single workspace) to broad (entire project).

## Steps

### Part 1 — Examine the variable declaration

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   This config declares variables that could be set at different scopes:

   ```hcl
   variable "aws_region" { ... }     # Could be in a variable set
   variable "environment" { ... }    # Set per workspace
   variable "common_tags" { ... }    # Could be in a global variable set
   ```

### Part 2 — The three variable scopes

2. **Scope 1: Single workspace (workspace-level variables)**

   Variables defined directly in a specific workspace:

   ```
   HCP Terraform UI → Workspace → Variables → Add variable
   ```

   - Apply only to **that specific workspace**
   - Set via HCP Terraform UI, API, or `TF_VAR_` environment variables
   - Most specific scope — overrides variable sets

   | Setting | Value |
   |---------|-------|
   | Scope | `workspace: variable-scope-demo` |
   | Variable | `environment = "production"` |
   | Effect | Only this workspace sees `environment = "production"` |

3. **Scope 2: Multiple workspaces (variable sets)**

   Variable sets group variables and can be applied to multiple selected workspaces:

   ```
   HCP Terraform UI → Settings → Variable Sets → Create → Apply to workspaces
   ```

   - Variables are shared across the selected workspaces
   - Update once, affects all assigned workspaces
   - Useful for: region, credentials, common tags

   ```
   ┌─────────────────────────────────────────────┐
   │           Variable Set: AWS Region          │
   │           aws_region = "us-east-1"          │
   ├─────────────┬──────────────┬────────────────┤
   │  Workspace  │  Workspace   │  Workspace     │
   │  dev        │  staging     │  production    │
   └─────────────┴──────────────┴────────────────┘
   ```

4. **Scope 3: All workspaces in a project (global variable set)**

   Variable sets can be applied to **all current and future workspaces** within a project:

   ```
   HCP Terraform UI → Settings → Variable Sets → Create → Apply globally
   ```

   - Automatically applies to every workspace in the project
   - New workspaces inherit the variables automatically
   - Useful for: organization-wide defaults, provider configurations

   ```
   ┌─────────────────────────────────────────────┐
   │         Global Variable Set: Common Tags    │
   │         common_tags = { ManagedBy = "TF" }  │
   ├─────────────┬──────────────┬────────────────┤
   │  Workspace  │  Workspace   │  Workspace     │
   │  dev        │  staging     │  production    │
   ├─────────────┼──────────────┼────────────────┤
   │  Workspace  │  Workspace   │  Workspace     │
   │  app-us     │  app-eu      │  (future)      │
   └─────────────┴──────────────┴────────────────┘
   ```

### Part 3 — Variable precedence

5. **When scopes overlap, more specific wins:**

   ```
   Workspace variable (most specific)  ← highest priority
   Variable set (multiple workspaces)
   Global variable set (all workspaces) ← lowest priority
   ```

   If the same variable is defined at multiple scopes:
   - The **workspace-level** value takes precedence
   - Then the **variable set** value
   - Then the **global variable set** value

### Part 4 — What is NOT a valid scope

6. **Variables cannot span organizations:**

   ```
   ❌ "All workspaces across multiple HCP Terraform organizations"
   ```

   Variable sets are scoped to a **single organization**. They cannot be applied across different organizations. Each organization manages its own variables independently.

## Files

- `main.tf` — config with variables suitable for different scopes
- `outputs.tf` — output values
- `solution/` — reference implementation

