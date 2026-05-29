# Explanation

## Purpose of Terraform's Dependency Graph

Terraform builds a **directed acyclic graph (DAG)** from your configuration to determine:

1. **Creation order** — which resources must be created before others
2. **Destruction order** — the reverse of creation (dependencies destroyed last)
3. **Parallelism** — resources with no dependency path between them can be created simultaneously

## How Terraform Builds It

- **Implicit dependencies** — when a resource references an attribute of another resource (`resource_a.id` used in `resource_b`)
- **Explicit dependencies** — via `depends_on` meta-argument
- **Provider dependencies** — resources depending on their provider being initialized

## Graph from This Exercise

```
random_pet.a ──depends_on──> random_pet.b
random_pet.c ─────────────────┐
                              ├──> random_password.d (keeper references)
random_pet.b ─────────────────┘
random_pet.e (completely independent)
```

**Parallel groups:**
- Group 1 (can run in parallel): `a`, `c`, `e`
- Group 2 (must wait for group 1): `b` (depends on `a`)
- Group 3 (must wait for group 2): `d` (depends on `b` and `c`)

**Destroy order:** `d` → `b` → `a`, `c`, `e` (all parallel)

## Exam Tip

- `terraform graph` outputs **DOT format** — pipe to `dot -Tsvg` to visualize
- `depends_on` creates an **explicit** dependency; attribute references create **implicit** ones
- The graph determines parallelism: Terraform processes independent branches concurrently (default parallelism = 10)
