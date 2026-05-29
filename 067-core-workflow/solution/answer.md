# Explanation

The correct answers are **A**, **E**, and **F**.

> **A.** Write — Author infrastructure as code.
>
> **E.** Plan — Preview changes before applying.
>
> **F.** Apply — Provision reproducible infrastructure.

---

## Why A, E, and F Are Correct

The Terraform core workflow is a three-step loop:

```
┌───────────────────────────────────────────────────────────┐
│                 Terraform Core Workflow                    │
│                                                           │
│   1. WRITE          2. PLAN           3. APPLY            │
│   ┌────────┐       ┌────────┐        ┌────────┐          │
│   │ Author │       │Preview │        │Provision│          │
│   │  HCL   │ ───→  │changes │ ───→   │  infra  │          │
│   │ config │       │(no-op) │        │(execute)│          │
│   └────────┘       └────────┘        └────────┘          │
│       ↑                                      │            │
│       └──────────────────────────────────────┘            │
│                (iterate: modify, re-plan, re-apply)       │
└───────────────────────────────────────────────────────────┘
```

### Step 1: Write

Author declarative HCL configuration that describes the desired state:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-abc"
  instance_type = "t2.micro"
}
```

### Step 2: Plan

Preview the changes Terraform will make to reach the desired state:

```bash
terraform plan
# Shows: + create, ~ update, - destroy
# No actual changes are made during plan
```

### Step 3: Apply

Execute the plan to provision or modify infrastructure:

```bash
terraform apply
# Terraform prompts for confirmation, then executes
```

## Why the Others Are Wrong

| Option | Why it's not a core step |
|--------|-------------------------|
| B — Destroy | Destruction is an **apply with an empty config** (or `terraform destroy`), not a separate core step. It's a specific use case within the same Write→Plan→Apply loop. |
| C — Validate | Validation is a **sub-operation** that occurs during writing or planning. `terraform validate` checks syntax but is not a core workflow phase. |
| D — Import | Import is an **optional feature** for adopting existing resources. It uses the plan/apply mechanism but is not part of the fundamental workflow. |

## Core vs Secondary Operations

```
CORE WORKFLOW:
  Write → Plan → Apply

PREREQUISITES (not core steps):
  terraform init         — Initialize providers, backends, modules
  terraform validate     — Check syntax (optional, done during write)

SUPPLEMENTARY (not core steps):
  terraform destroy      — Apply with zero resources
  terraform import       — Adopt existing resources (uses plan/apply)
  terraform fmt          — Format code
  terraform state        — State manipulation
  terraform output       — View outputs
  terraform graph        — Visualize dependencies
  terraform console      — Interactive evaluation
```

## The Workflow in Practice

```
Iteration 1: Write initial config → Plan (all creates) → Apply (create)
     ↓
Iteration 2: Modify config → Plan (shows updates) → Apply (update)
     ↓
Iteration 3: Remove resources → Plan (shows destroys) → Apply (destroy)
     ↓
Iteration 4: Add new feature → Plan (create + update) → Apply ...
```

## Objective Reference

**Objective 3a** — Describe the Terraform workflow.

Key points:
- Three core steps: Write, Plan, Apply
- Write = author IaC in HCL
- Plan = preview changes before applying
- Apply = provision reproducible infrastructure
- Destroy is a specific apply, not a separate step
- Validate and import are secondary operations
