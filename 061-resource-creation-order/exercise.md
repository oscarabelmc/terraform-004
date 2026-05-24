# Resource Creation Order Exercise

**Exam Question:** In the example code below, what order will Terraform create these resources?

```hcl
variable "existing_disk" { type = string }

resource "google_compute_instance" "web" {
  name         = "btk-web-1"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk { initialize_params { image = "debian-cloud/debian-11" } }
  network_interface { network = "default" access_config {} }
}

resource "google_compute_attached_disk" "data" {
  instance = google_compute_instance.web.name
  disk     = var.existing_disk
}
```

## Background

Terraform builds a **directed acyclic graph (DAG)** to determine resource creation order. Resources with no dependencies are created first, then resources that depend on them. The graph ensures:

- Resources are created in the correct order
- Resources with no shared dependencies can be created in parallel
- Resources are destroyed in reverse order

## Steps

### Part 1 — Identify the dependencies

1. **Open `main.tf`:**

   ```bash
   cat main.tf
   ```

   Two resources are declared:

   | Resource | Dependencies | Reason |
   |----------|-------------|--------|
   | `google_compute_instance.web` | None | No references to other resources |
   | `google_compute_attached_disk.data` | `google_compute_instance.web` | References `google_compute_instance.web.name` |

2. **Implicit vs explicit dependencies:**

   - **Implicit** (shown above): Terraform detects the dependency because `google_compute_attached_disk.data` reads `google_compute_instance.web.name`
   - **Explicit**: Using `depends_on` to force a dependency Terraform cannot infer

### Part 2 — Visualize the dependency graph

3. **Generate the graph:**

   ```bash
   terraform init
   terraform graph | dot -Tpng > graph.png
   ```

   This produces a visual representation of the dependency graph. The graph shows:

   ```
   root ──→ google_compute_instance.web ──→ google_compute_attached_disk.data
   ```

   The arrow direction indicates that the instance must exist before the disk can be attached.

4. **Read the graph as text:**

   ```bash
   terraform graph
   ```

   Output shows edges between resources. The `google_compute_attached_disk.data` node has an edge from `google_compute_instance.web`.

### Part 3 — Why order matters

5. **What happens if order is wrong?**

   If Terraform tried to create the attached disk first:

   ```
   Error: Error creating attached disk: instance "btk-web-1" not found
   ```

   The instance must exist before a disk can be attached to it. Terraform's dependency graph prevents this error.

6. **Parallelism with independent resources:**

   If there were two instances with no dependencies on each other:

   ```hcl
   resource "google_compute_instance" "web1" { ... }
   resource "google_compute_instance" "web2" { ... }
   ```

   Terraform creates them **in parallel** because the graph shows no path between them.

### Part 4 — Verify the creation order plan

7. **Run terraform plan to see the order:**

   ```bash
   terraform plan
   ```

   The plan output shows actions in the order Terraform will execute them, grouped by dependency level:

   ```
   Terraform will perform the following actions:

     # google_compute_instance.web will be created
     ...

     # google_compute_attached_disk.data will be created
     ...
   ```

   Resources with no dependencies appear first.

### Put It Together

In the example code below, what order will Terraform create these resources?

```hcl
variable "existing_disk" { type = string }

resource "google_compute_instance" "web" {
  name         = "btk-web-1"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk { initialize_params { image = "debian-cloud/debian-11" } }
  network_interface { network = "default" access_config {} }
}

resource "google_compute_attached_disk" "data" {
  instance = google_compute_instance.web.name
  disk     = var.existing_disk
}
```

- A. Both resources are created simultaneously in parallel
- B. First — `google_compute_attached_disk.data`, Second — `google_compute_instance.web`
- C. First — `google_compute_instance.web`, Second — `google_compute_attached_disk.data`
- D. The order is random and non-deterministic
- E. The resources are created in alphabetical order by resource name

## Files

- `main.tf` — GCP config with instance and attached disk
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
