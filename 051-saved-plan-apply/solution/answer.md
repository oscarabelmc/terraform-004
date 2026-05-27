# Answer

The correct answer is **A**.

> `terraform apply saved-plan.tfplan`

---

## Why A Is Correct

`saved plan files` (`tfplan`) capture the **exact execution plan** at a specific point in time:

```
Step 1:  terraform plan -out=saved-plan.tfplan
         ↓
         Creates binary plan file with:
         - Exact resources to create/modify/destroy
         - Computed values resolved at plan time
         - Resource action ordering
         ↓
Step 2:  Review and approve (based on plan output)
         ↓
Step 3:  terraform apply saved-plan.tfplan
         ↓
         Executes the exact same plan — no re-evaluation
```

When you run `terraform apply <planfile>`, Terraform:

1. Reads the saved plan file
2. Verifies it's still valid (hasn't been tampered with or expired)
3. Executes the exact changes recorded in the plan
4. Does **not** re-evaluate the configuration or state

This guarantees that what was reviewed and approved is exactly what gets executed — even if the configuration or state has changed in the intervening two hours.

## Saved Plan vs Fresh Plan on Apply

| Aspect | `terraform apply <file>` | `terraform apply` (no file) |
|--------|------------------------|---------------------------|
| Plan source | Uses the saved plan file | Generates a **new** plan |
| Matches reviewed output? | ✅ Guaranteed | ❌ May differ (drift, config changes) |
| Requires approval? | ✅ (plan was reviewed) | ❌ (applies immediately after fresh plan) |
| Can be tampered? | ❌ (plan is signed) | N/A |
| Use case | Change management, compliance | Ad-hoc changes |

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — `terraform apply` | This generates a **fresh plan** at apply time, which may differ from the reviewed plan due to drift or config changes over the 2-hour gap. |
| C — Re-run plan, then apply | Re-planning defeats the purpose — the new plan could differ from what was reviewed and approved. |
| D — `terraform apply -auto-approve` with plan file | The `-auto-approve` flag is **not valid** when applying a saved plan file. It's unnecessary because the plan was already approved during review. Also, `-auto-approve` is typically unsafe in change management workflows. |
| E — `terraform init && terraform apply` | Re-initializing before apply is unnecessary and `terraform apply` without a plan file creates a fresh (unreviewed) plan. |

## Saved Plan File Details

| Aspect | Detail |
|--------|--------|
| **File format** | Binary (not human-readable) |
| **Extension** | Convention: `.tfplan` |
| **Contains** | Action graph, planned state, provider metadata |
| **Integrity** | Signed to prevent tampering |
| **Validity** | Valid until the next `terraform init` changes providers; otherwise persists |
| **Inspect** | `terraform show <file>.tfplan` |
| **Convert to JSON** | `terraform show -json <file>.tfplan` |

## Change Management Workflow with Saved Plans

```bash
# 1. Generate plan for review
terraform plan -out=change-2024-01-15.tfplan

# 2. Output for review (via PR comment, email, etc.)
terraform show change-2024-01-15.tfplan

# 3. ... team reviews and approves ...

# 4. Apply the exact approved changes
terraform apply change-2024-01-15.tfplan
```

This is the standard workflow for **change management** and **compliance** requirements.

## Exam Tips

- `terraform plan -out=<file>` saves the plan to a binary file
- `terraform apply <file>` applies the saved plan (exactly as reviewed)
- Saved plans ensure **consistency between review and execution**
- Without `-out`, `terraform apply` generates a fresh plan — which may differ from what was reviewed
- `-auto-approve` is **not** used with saved plan files
- Saved plans contain a signature to prevent tampering
- Common exam scenario: "Plan was reviewed 2 hours ago, what command applies the exact same changes?" — `terraform apply <planfile>`
- Common exam trap: thinking `terraform apply` without a plan file executes the same plan — it doesn't, it re-plans
