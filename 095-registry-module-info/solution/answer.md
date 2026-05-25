# Answer

The correct answers are **A**, **C**, and **D**.

> **A.** Dependencies to use the module.
>
> **C.** A list of outputs.
>
> **D.** Required input variables.

---

## Why A, C, and D Are Correct

The Terraform Registry module pages provide structured information to help you use a module:

```
┌──────────────────────────────────────────────────────────┐
│              Terraform Registry Module Page               │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  ✅ Required input variables  ─── What you must set      │
│                                                          │
│  ✅ Outputs                  ─── What you can read       │
│                                                          │
│  ✅ Dependencies             ─── Providers + TF version  │
│                                                          │
│  ✅ README                   ─── Usage examples          │
│                                                          │
│  ✅ Resources                ─── What gets created       │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

### A — Dependencies

The registry lists:
- Required providers and their version constraints
- Minimum Terraform Core version
- Related/provisioner dependencies

```hcl
# From the dependencies section:
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}
```

### C — Outputs

The outputs section tells you what values the module exposes:

```
Outputs:
  vpc_id                    → The ID of the VPC
  public_subnets            → List of public subnet IDs
  private_subnets           → List of private subnet IDs
  default_security_group_id → The default security group ID
  ...
```

You reference these as `module.vpc.<output_name>`.

### D — Required input variables

The inputs section shows what arguments you must or can pass:

```
Inputs:
  name          (string)     Required — VPC name
  cidr          (string)     Required — VPC CIDR block
  azs           (list)       Required — Availability zones
  enable_nat_gateway (bool)  Optional (default: true)
  ...
```

## Why the Incorrect Option Is Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — Download button | Registry modules are **referenced via source in code**, not downloaded as ZIP files. `terraform init` handles fetching. A download button exists but is not how you use modules in Terraform. |

## How to Use a Registry Module

```
1. Find module on registry.terraform.io
2. Read: Inputs (required variables)
3. Read: Outputs (what you'll get back)
4. Read: Dependencies (required providers)
5. Add module block to config:
     module "vpc" {
       source  = "terraform-aws-modules/vpc/aws"
       version = "~> 5.0"
       ...inputs...
     }
6. Run terraform init to download
```

## Exam Tips

- Registry shows: **inputs, outputs, dependencies**, README, resources
- You do **not** download modules — you reference them via `source`
- `terraform init` handles module downloads automatically
- The **version** field pins the module version for reproducibility
- Common exam trap: thinking you need to manually download registry modules
- Another trap: overlooking the dependencies section (providers, TF version requirements)
