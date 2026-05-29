# Explanation

The correct answer is **B — False**.

---

## Why False Is Correct

Terraform does **not** require `depends_on` to manage dependencies. It has **two** mechanisms:

### 1. Implicit dependencies (automatic)

When one resource references an attribute of another, Terraform automatically creates a dependency:

```hcl
resource "random_pet" "server" {
  length = 2
}

resource "local_file" "config" {
  content  = "Server: ${random_pet.server.id}"   # ← implicit dependency
  filename = "config.txt"
}
```

Terraform sees the reference `${random_pet.server.id}` and ensures `random_pet.server` is created (or updated) before `local_file.config`.

### 2. Explicit dependencies (`depends_on`)

Used when there's no attribute reference but an ordering requirement exists:

```hcl
resource "aws_instance" "web" {
  depends_on = [aws_s3_bucket.logs]   # ← explicit
  # ...
}
```

### The key point

The statement says Terraform **can only** manage dependencies via `depends_on`. This is false because **implicit dependencies are the default and primary mechanism**. `depends_on` is only needed when the implicit mechanism cannot detect the dependency.

```
┌────────────────────────────────────────────────────────────┐
│              How Terraform detects dependencies             │
├────────────────────────────────────────────────────────────┤
│                                                             │
│  Terraform scans all resource blocks for attribute          │
│  references like:                                           │
│                                                             │
│    aws_instance.web.id       → depends on aws_instance.web  │
│    module.vpc.vpc_id         → depends on module.vpc        │
│    data.aws_subnet.main.id   → depends on data source       │
│                                                             │
│  Every cross-resource reference automatically creates       │
│  a dependency edge in the graph. No depends_on needed.      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Why A (True) Is Incorrect

Saying "True" would mean `depends_on` is **required** for any dependency management, which would make Terraform unusable for even the simplest configurations. Consider:

```hcl
resource "aws_eip" "ip" {
  instance = aws_instance.web.id   # must work without depends_on
}
```

If `depends_on` were the **only** way to manage dependencies, this common pattern would fail. Terraform would try to create the EIP before the instance, and the EIP attachment would fail.

## When `depends_on` Is Actually Needed

| Scenario | Implicit? | Why `depends_on` |
|----------|:---------:|------------------|
| Attribute reference exists | ✅ Yes | Dependency auto-detected |
| No attribute reference but ordering needed | ❌ No | Must use `depends_on` |
| Provisioner needs resource A before B | ❌ No | Must use `depends_on` |
| Destroy order override | ❌ No | Must use `depends_on` |
| Cross-module dependency without reference | ❌ No | Must use `depends_on` |

## The Dependency Graph

```
Attribute Reference             depends_on
     │                              │
     ▼                              ▼
┌────────────────────────────────────────┐
│         Terraform DAG                  │
│                                        │
│  Nodes: resources, data sources,       │
│         modules                        │
│  Edges: implicit + explicit deps      │
│                                        │
│  Terraform walks the DAG to determine: │
│    • Create order (dependencies first) │
│    • Parallelism (no edge = parallel)  │
│    • Destroy order (reverse of create) │
└────────────────────────────────────────┘
```
