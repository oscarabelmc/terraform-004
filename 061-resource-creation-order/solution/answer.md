# Answer

The correct answer is **C**.

> First — `google_compute_instance.web`, Second — `google_compute_attached_disk.data`

---

## Why C Is Correct

The `google_compute_attached_disk.data` resource references `google_compute_instance.web.name`, creating an **implicit dependency**:

```hcl
resource "google_compute_attached_disk" "data" {
  instance = google_compute_instance.web.name   # ← implicit dependency
  disk     = var.existing_disk
}
```

Terraform builds a **DAG (directed acyclic graph)** from these dependencies:

```
┌─────────────────────────────────────┐
│            Dependency Graph          │
│                                      │
│   google_compute_instance.web        │
│         ▲                            │
│         │ (no dependencies)          │
│         │                            │
│   ──────┴──────                      │
│                                      │
│   google_compute_attached_disk.data  │
│         ▲                            │
│         │ (depends on instance.web)  │
│         │                            │
└─────────────────────────────────────┘
```

Terraform traverses the graph from **roots** (no dependencies) to **leaves** (dependent resources):

| Step | Resource | Why |
|------|----------|-----|
| 1st | `google_compute_instance.web` | Root node — no incoming dependencies |
| 2nd | `google_compute_attached_disk.data` | Depends on instance — must wait |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Both created in parallel | Impossible because attached_disk references the instance — it must exist first. Parallelism only applies to resources with no dependency path between them. |
| B — Disk before instance | The disk references `google_compute_instance.web.name`. The instance must exist for that attribute to have a value. Terraform would error if it tried this order. |
| D — Random order | Terraform's DAG is deterministic — order is always based on dependency analysis, not randomness. |
| E — Alphabetical order | Terraform does not sort resources by name. The order is purely graph-based. |

## How Terraform Determines Order

```
Configuration:
  google_compute_instance.web        (no refs to other resources)
  google_compute_attached_disk.data  (refs instance.web.name)

Graph construction:
  google_compute_instance.web        ──→  google_compute_attached_disk.data

Execution order (topological sort):
  1. google_compute_instance.web      (root — no deps)
  2. google_compute_attached_disk.data (leaf — depends on root)

Destroy order (reverse of create):
  1. google_compute_attached_disk.data
  2. google_compute_instance.web
```

## Implicit vs Explicit Dependencies

| Type | How it's created | Example |
|------|-----------------|---------|
| **Implicit** | Attribute reference | `instance = google_compute_instance.web.name` |
| **Explicit** | `depends_on` meta-argument | `depends_on = [google_compute_instance.web]` |

Both create edges in the dependency graph and affect creation order the same way.

## Exam Tips

- **Attribute references** create implicit dependencies — Terraform detects them automatically
- The dependency graph determines: **creation order**, **destruction order** (reverse), and **parallelism**
- Roots (no dependencies) are created first and destroyed last
- Leaves (depend on others) are created last and destroyed first
- Resources with no dependency path between them are created **in parallel**
- `terraform graph` visualizes the DAG — useful for understanding complex dependencies
- Common exam trap: thinking resources are created in the order they appear in the file (they're created in dependency order, not file order)
