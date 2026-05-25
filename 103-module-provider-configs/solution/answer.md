# Answer

The three correct statements are: **A, C, and D**.

> **A** — The `providers` argument in a module block allows explicit passing of specific provider configurations.
>
> **C** — Modules containing provider blocks cannot be used with the `for_each` argument.
>
> **D** — Child modules automatically inherit the default provider configurations from their parent module.

---

## Why A, C, and D Are Correct

### A — Explicit passing with `providers` argument

The `providers` argument maps provider names in the child module to provider configurations in the parent:

```hcl
provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

module "vpc_east" {
  source    = "./modules/vpc"
  providers = {
    aws = aws.east
  }
}

module "vpc_west" {
  source    = "./modules/vpc"
  providers = {
    aws = aws.west
  }
}
```

This is essential for **multi-region** or **multi-account** deployments where the same module must use different provider configurations.

### C — Provider blocks block meta-arguments

A module that contains `provider` blocks **cannot** be used with `for_each`, `count`, or `depends_on`:

```hcl
module "broken" {
  source   = "./modules/has-provider-block"
  for_each = var.regions    # ❌ Error!
}
```

**Why?** Provider configurations must be resolved **before** Terraform can construct the dependency graph. When a module hardcodes its own provider, Terraform cannot configure a different provider per instance of that module. The provider is baked into the module definition.

The fix is to **remove provider blocks from child modules** and pass providers explicitly via the `providers` argument instead.

### D — Automatic inheritance

Child modules **automatically inherit** the default provider configuration from the calling module:

```
Root module                          Child module
┌────────────────┐                   ┌────────────────┐
│ provider "aws" {│   automatically   │ resource       │
│   region =     │ ────────────────►  │ "aws_vpc" {    │
│   "us-east-1"  │    inherited       │   # no provider│
│ }              │                   │   # block needed│
└────────────────┘                   └────────────────┘
```

The child does **not** need to define its own provider block. It uses the parent's default provider automatically.

## Why the Other Statements Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| **B** — Child modules must always define their own provider blocks | **False.** In fact, the best practice is the opposite: child modules should **NOT** define provider blocks. They should inherit or receive providers via the `providers` argument. |
| **E** — The `provider` attribute in a resource overrides module-level config | There is **no `provider` attribute** on individual resource blocks. Provider selection is done at the module level via the `providers` argument or by default inheritance. |
| **F** — Modules with provider blocks CAN use `depends_on` | **False.** Any module containing provider blocks is incompatible with `for_each`, `count`, **and** `depends_on`. The restriction applies to all three meta-arguments. |

## Summary Table

| Scenario | Works? | Why |
|----------|:------:|-----|
| Child without `provider` block, inherits default | ✅ | Automatic inheritance |
| Child without `provider` block, explicit `providers` | ✅ | Explicit mapping |
| Child WITH `provider` block, single instance | ✅ | No meta-arguments needed |
| Child WITH `provider` block + `for_each` | ❌ | Provider can't be resolved per instance |
| Child WITH `provider` block + `count` | ❌ | Same reason |
| Child WITH `provider` block + `depends_on` | ❌ | Same reason |

## Best Practice

```
✅ DO:  Define providers only in the root module
       Pass to children via inheritance or `providers` argument

❌ DON'T: Define provider blocks inside reusable child modules
         (Breaks for_each, count, depends_on)
```

## Exam Tips

- **Three correct statements:** A (providers argument), C (no for_each with provider blocks), D (automatic inheritance)
- Key restriction: modules with `provider` blocks are incompatible with `for_each`, `count`, and `depends_on`
- The `providers` argument is how you pass provider configurations **explicitly** to child modules
- Default provider inheritance happens **automatically** — no configuration needed
- Best practice: child modules should **never** define their own provider blocks
- Common exam trap: thinking child modules must define their own provider blocks for isolation (they inherit instead)
- Another trap: thinking `depends_on` works differently — it's blocked just like `for_each` and `count` when the module has `provider` blocks
- The `provider` attribute does **not** exist on individual resource blocks — provider is set at the module level
