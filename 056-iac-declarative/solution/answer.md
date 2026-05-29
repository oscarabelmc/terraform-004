# Explanation

The correct answer is **A**.

> Terraform uses declarative configuration to describe the desired end state and generates a plan of action before applying changes.

---

## Why A Is Correct

Terraform's **declarative** approach is the defining characteristic of IaC:

```
Declarative (Terraform):
"I want a VPC with CIDR 10.0.0.0/16,
 a subnet with CIDR 10.0.1.0/24,
 and an EC2 instance in that subnet."

Terraform figures out:
1. Create VPC first (no dependencies)
2. Create subnet (depends on VPC)
3. Create instance (depends on subnet)
→ All automatically ordered and parallelized
```

vs.

```
Imperative (CLI):
"1. aws ec2 create-vpc --cidr 10.0.0.0/16
 2. aws ec2 create-subnet --vpc-id <previous-output>
 3. aws ec2 run-instances --subnet-id <previous-output>"

The user handles ordering, error recovery, and state tracking.
```

### The Declarative Workflow

```
Write config  ──→  terraform plan  ──→  terraform apply
(desired state)    (preview changes)    (execute plan)
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — IaC requires commands in specific order | IaC is **declarative** — Terraform determines order automatically via the dependency graph. |
| C — IaC can only be used with a single cloud provider | Terraform supports **multiple providers** in the same config. Multi-cloud is a key IaC advantage. |
| D — Terraform makes raw API calls directly | Terraform **abstracts** raw API calls through provider plugins. Users write HCL, not API calls. |
| E — IaC eliminates need for config files | IaC **requires** configuration files — that's the "Code" in Infrastructure as Code. |

## Declarative vs Imperative

| Aspect | Declarative (Terraform) | Imperative (CLI/Scripts) |
|--------|------------------------|-------------------------|
| **What you write** | Desired state | Step-by-step commands |
| **Ordering** | Automatic (dependency graph) | Manual (must be correct) |
| **Idempotency** | ✅ Same result every time | ❌ Must handle "already exists" |
| **Plan preview** | ✅ `terraform plan` | ❌ Must manually simulate |
| **Drift detection** | ✅ Automatic diff | ❌ No built-in check |
| **Rollback** | ✅ State versioning | ❌ Manual reversal |
| **Error recovery** | Automatic (re-plan) | Manual debugging |
| **Parallelism** | Automatic | Manual |
