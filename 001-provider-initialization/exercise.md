# Provider Initialization Exercise

**Domain:** Infrastructure as Code (IaC) Workflow
**Topic:** Provider initialization — `terraform init`

## Description

You added resources from a new provider to an existing configuration and `terraform plan` results in an error about a missing provider.

## Learning Objectives

- Start with the starter config
- Edit `main.tf`
- Run `terraform plan`
- Fix it
- Run `terraform plan` again

## Steps

1. **Start with the starter config** — `terraform init && terraform plan` to confirm it works.

2. **Edit `main.tf`** — Add a `data` block using the `hashicorp/http` provider:

```hcl
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}
```

Also add `hashicorp/http` to the `required_providers` block.

3. **Run `terraform plan`** — Observe the error.

4. **Fix it** — What single command do you need to run?

5. **Run `terraform plan` again** — Should succeed and show the HTTP response body as a new output.

## Files
- `main.tf` — your working config
- `variables.tf` — (empty, ready for use)
- `outputs.tf` — start with just `pet_name` output
- `solution/` — reference implementation

