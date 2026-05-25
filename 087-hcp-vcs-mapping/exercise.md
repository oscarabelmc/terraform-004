# HCP Terraform — VCS Workspace Mapping Exercise

**Exam Question:** In HCP Terraform, how many VCS repositories can a workspace be mapped to?

## Background

In HCP Terraform, a **workspace** is an environment where Terraform runs are executed. When connected to a VCS provider (GitHub, GitLab, Bitbucket, etc.), the workspace can be linked to a **single repository** to enable VCS-driven workflows.

## Steps

### Part 1 — Understand workspace-VCS relationship

1. **Each workspace maps to one VCS repo:**

   ```
   HCP Terraform Organization
   │
   ├── Workspace: production
   │     └── VCS Repo: github.com/my-org/infra-prod
   │
   ├── Workspace: staging
   │     └── VCS Repo: github.com/my-org/infra-staging
   │
   └── Workspace: dev
         └── VCS Repo: github.com/my-org/infra-dev
   ```

   One workspace = one repo. You cannot attach multiple repos to the same workspace.

### Part 2 — How the VCS-driven workflow works

2. **The mapping enables:**

   ```
   1. Developer pushes code to the VCS repo
   2. HCP Terraform detects the push
   3. Automatically queues a run in the linked workspace
   4. Plan runs → results shown in the PR
   5. On merge → apply is triggered
   ```

3. **What you can do within one workspace:**

   - ✅ One VCS repository
   - ✅ Multiple directories (via `terraform plan -chdir` or workspace triggers)
   - ✅ Multiple working directories (advanced, with workspace configurations)

### Part 3 — How to handle multiple repos

4. **If you need to manage infrastructure from multiple repos:**

   ```
   ❌ One workspace with multiple VCS repos — NOT POSSIBLE
   
   ✅ Instead:
      - Create one workspace per VCS repo
      - Or use a monorepo with one workspace per directory pattern
      - Or use run triggers to chain workspaces
   ```

   | Scenario | Solution |
   |----------|----------|
   | Two repos (networking + app) | Two workspaces, each linked to its repo |
   | One monorepo with multiple projects | One workspace per project directory, repo settings with paths |
   | CI/CD from non-VCS source | Use CLI-driven or API-driven runs |

### Put It Together

In HCP Terraform, how many VCS repositories can a workspace be mapped to?

- A. 0
- B. 1
- C. 5
- D. Unlimited

## Files

- `main.tf` — config with cloud block
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
