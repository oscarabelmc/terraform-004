# Explanation

The correct answers are **A**, **C**, and **F**.

> A. Map real-world resources to your Terraform configuration.
>
> C. Improve performance by caching resource attributes.
>
> F. Track metadata such as resource dependencies.

---

## Why A, C, and F Are Correct

### A — Map Config to Real Resources

This is the **fundamental purpose** of state. Without state, Terraform has no way to know that a specific `resource "aws_instance" "web"` block corresponds to a specific EC2 instance (`i-0a1b2c3d`):

| Concept | What It Means |
|---------|---------------|
| **Configuration** | Desired state: "I want an EC2 instance" |
| **State** | Current reality: "Instance i-abc123 exists with these attributes" |
| **Mapping** | "resource aws_instance.web = i-abc123" |

Terraform reads state during `plan` to determine what already exists and what needs to change.

### C — Improve Performance by Caching

State caches resource attributes so Terraform doesn't need API calls for every resource attribute on every plan. For large infrastructures (hundreds of resources), this reduces plan time from minutes to seconds.

### F — Track Resource Dependencies

State records dependencies used for:
- **Create order** — dependencies created first
- **Destroy order** — reverse of create
- **Parallelism** — no shared dependency = parallel

## Why the Others Are Wrong

| Option | Why It's Not a State Purpose |
|--------|------------------------------|
| B — Fix syntax errors | `terraform validate` catches syntax errors — no state needed |
| D — Encrypt config data | State is **plaintext JSON** — encryption by backend (S3 SSE, etc.) |
| E — Validate credentials | Provider configuration validates credentials — state doesn't handle auth |

## The Three Purposes of State

```
┌──────────────────────────────────────────────────────────────┐
│                      Terraform State                         │
├──────────────────────────────────────────────────────────────┤
│ 1. Mapping    ─── Links each resource block to a real         │
│                   infrastructure object                       │
│ 2. Caching    ─── Stores resource attributes locally           │
│ 3. Metadata   ─── Tracks dependencies, version, serial         │
└──────────────────────────────────────────────────────────────┘
```
