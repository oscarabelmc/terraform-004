# HCP Terraform Variable Sets for Credentials Exercise

**Domain:** HCP Terraform
**Topic:** HCP Terraform variable sets for sharing credentials across workspaces

## Description

One of your application teams needs to share third-party credentials across multiple workspaces. What is the most appropriate way to configure HCP Terraform and easily meet these requirements? (Select three.)

## Learning Objectives

- Understand the three components
- Step 1: Group workspaces into a project
- Step 2: Create a variable set with credentials
- Step 3: Apply the variable set to the project
- Verify the configuration

## Background

HCP Terraform provides **variable sets** to share variables across multiple workspaces without duplicating them. Combined with **projects** (workspace grouping), variable sets make it easy to share credentials across all workspaces that need them.

```
Without variable sets:                   With variable sets:
┌──────────────────────┐                ┌──────────────────────┐
│ Workspace: app-dev   │                │   Variable Set       │
│   AWS_ACCESS_KEY     │                │   "third-party-creds"│
│   AWS_SECRET_KEY     │                │   ─────────────      │
├──────────────────────┤                │   API_TOKEN = xxx    │
│ Workspace: app-stg   │                │   API_SECRET = yyy   │
│   AWS_ACCESS_KEY     │                └──────────┬───────────┘
│   AWS_SECRET_KEY     │                           │
├──────────────────────┤          ┌────────────────┼────────────────┐
│ Workspace: app-prod  │          │                │                │
│   AWS_ACCESS_KEY     │          ▼                ▼                ▼
│   AWS_SECRET_KEY     │    ┌──────────┐   ┌──────────┐   ┌──────────┐
└──────────────────────┘    │ app-dev  │   │ app-stg  │   │ app-prod │
   (duplicated everywhere)  └──────────┘   └──────────┘   └──────────┘
                              (all inherit from variable set)
```

## Steps

### Part 1 — Understand the three components

1. **The three steps to share credentials:**

   ```
   Step 1: Group workspaces into a project
   Step 2: Create a variable set with the credentials
   Step 3: Apply the variable set to the project
   ```

   Each step is independent but all three are needed for the full solution.

### Part 2 — Step 1: Group workspaces into a project

2. **Why projects?**

   Projects are containers for workspaces. They allow you to:
   - Apply policy sets to all workspaces in the project
   - Apply variable sets to all workspaces in the project
   - Manage team access at the project level

   ```hcl
   # Using the tfe provider to create a project
   resource "tfe_project" "app_team" {
     name         = "app-team-project"
     organization = "my-org"
   }

   resource "tfe_workspace" "app_dev" {
     name       = "app-dev"
     project_id = tfe_project.app_team.id
     organization = "my-org"
   }

   resource "tfe_workspace" "app_stg" {
     name       = "app-stg"
     project_id = tfe_project.app_team.id
     organization = "my-org"
   }
   ```

   Both workspaces belong to the same project, making them eligible for project-scoped variable sets.

### Part 3 — Step 2: Create a variable set with credentials

3. **What is a variable set?**

   A variable set is a reusable collection of variables that can be applied to multiple workspaces or projects. Variables in a set can be marked **sensitive** to hide their values.

   ```hcl
   resource "tfe_variable_set" "third_party_creds" {
     name         = "third-party-credentials"
     description  = "Shared credentials for third-party API"
     organization = "my-org"
   }

   resource "tfe_variable" "api_token" {
     key          = "API_TOKEN"
     value        = var.third_party_api_token
     category     = "terraform"
     sensitive    = true
     variable_set_id = tfe_variable_set.third_party_creds.id
   }

   resource "tfe_variable" "api_secret" {
     key          = "API_SECRET"
     value        = var.third_party_api_secret
     category     = "terraform"
     sensitive    = true
     variable_set_id = tfe_variable_set.third_party_creds.id
   }
   ```

### Part 4 — Step 3: Apply the variable set to the project

4. **Scope options for variable sets:**

   | Scope | Applies to | Use case |
   |-------|-----------|----------|
   | **All workspaces** | Every workspace in the org | Global variables (e.g., org-wide notification webhook) |
   | **Projects** | All workspaces in selected projects | Team/application-level credentials |
   | **Specific workspaces** | Only selected workspaces | One-off configurations |

5. **Apply to the project:**

   ```hcl
   resource "tfe_project_variable_set" "app_team_creds" {
     variable_set_id = tfe_variable_set.third_party_creds.id
     project_id      = tfe_project.app_team.id
   }
   ```

   Now every workspace in the `app-team-project` automatically receives `API_TOKEN` and `API_SECRET`.

### Part 5 — Verify the configuration

6. **Check the HCP Terraform UI hierarchy:**

   ```
   Organization: my-org
   │
   ├── Project: app-team-project
   │   ├── Workspace: app-dev     ◄── inherits variable set
   │   ├── Workspace: app-stg     ◄── inherits variable set
   │   └── Workspace: app-prod    ◄── inherits variable set
   │
   └── Project: platform-team-project
       └── Workspace: networking  ◄── does NOT inherit (different project)
   ```

   The credentials are shared across all workspaces in the project while workspaces in other projects remain isolated.

## Files

- `main.tf` — example config using the `tfe` provider to manage projects, workspaces, and variable sets
- `outputs.tf` — output values
- `solution/` — reference implementation

