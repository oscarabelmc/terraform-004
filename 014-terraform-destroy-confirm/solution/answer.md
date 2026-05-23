# Answer

**True.**

## Why

By default, `terraform destroy` requires manual confirmation. After displaying the destroy plan, Terraform pauses and prompts:

```
Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure...
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value:
```

The user must type `yes` (and press Enter) for the destroy to proceed. Any other input (including `no` or just Enter) cancels the operation.

## How to Skip the Prompt

| Command | Behavior |
|---------|----------|
| `terraform destroy` | Shows plan → **prompts for confirmation** → destroys on `yes` |
| `terraform destroy -auto-approve` | Shows plan → **destroys immediately** without prompting |
| `terraform apply -destroy -auto-approve` | Same as above (`destroy` is an alias) |
| `terraform plan -destroy` | Shows plan → **does nothing else** (preview only) |

## Why the Prompt Exists

`terraform destroy` is **irreversible** — it permanently deletes infrastructure. The confirmation prompt is a safety mechanism to prevent accidental destruction. This is consistent with `terraform apply`, which also prompts by default (unless `-auto-approve` is used).

## Exam Tips

- Default = **prompts** → answer: **True**
- `-auto-approve` = **no prompt** (must be explicitly passed)
- `terraform destroy` is equivalent to `terraform apply -destroy`
- `terraform plan -destroy` gives a **preview** without any prompt or changes
- The exam may ask both directions: "What flag skips the confirmation?" → `-auto-approve`
