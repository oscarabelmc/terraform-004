# Dependency Graph Exercise

**Question:** What is the purpose of Terraform's dependency graph?

**Goal:** See the dependency graph in action — how Terraform determines resource ordering and parallelism.

## Steps

1. **Review `main.tf`** — Note the dependencies between resources:
   - `a` — no dependencies
   - `b` — explicitly depends on `a` (`depends_on`)
   - `c` — no dependencies
   - `d` — implicitly depends on `b` and `c` (references their attributes)
   - `e` — no dependencies (completely independent)

2. **Run `terraform init && terraform plan`** — Watch the order Terraform plans them.

3. **Visualize the graph:**

```bash
terraform graph | tee graph.dot
```

This outputs the dependency graph in DOT format. If you have Graphviz installed, render it:

```bash
terraform graph | dot -Tsvg > graph.svg && open graph.svg
```

4. **Observe:**
   - Which resources can be created in **parallel**?
   - Which must be created **sequentially**?
   - What happens to the order during `terraform destroy`?

5. **Check your understanding** in `solution/answer.md`.

## Files
- `main.tf` — resources with various dependency patterns
- `outputs.tf` — outputs for verification  
- `variables.tf` — empty placeholder
- `solution/answer.md` — explanation
