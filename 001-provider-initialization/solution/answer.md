# Answer

The fix is to run **`terraform init`**.

### Why?

`terraform init` is the command that downloads and installs provider plugins. When you add a resource from a new provider (like `hashicorp/http`), Terraform needs to:

1. Download the provider binary
2. Record it in the `.terraform.lock.hcl` lock file
3. Make it available for `plan` and `apply`

Without running `init`, `terraform plan` cannot find the provider plugin and returns an error like:

```
Error: Failed to query available provider packages
Could not retrieve the list of available versions for provider hashicorp/http
```

### Exam Tip

Always remember: **adding a new provider → `terraform init`** is the first thing to do. The options like `terraform providers` (lists providers), `terraform get` (downloads modules), or `terraform refresh` (syncs state) won't solve this.
