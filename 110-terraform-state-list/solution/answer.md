# Explanation

The correct answer is **A**.

> `terraform state list`

---

## Why A Is Correct

`terraform state list` prints every resource address in the state file, one per line, with **no attributes**:

```bash
$ terraform state list
random_pet.vpc
random_pet.subnet
random_pet.instance
```

This is the fastest way to get a high-level inventory of all tracked resources. The output is minimal — just the resource type and name (and module path if applicable).

```
module.vpc.aws_vpc.main
module.vpc.aws_subnet.private
module.vpc.aws_subnet.public
aws_instance.web
aws_db_instance.main
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — `terraform state show <address>` | This shows **detailed attributes** of a **single** resource. It requires you to already know the resource address and only shows one at a time. Not suitable for getting a complete list. |
| C — `terraform show` | This displays the **entire state file** with all attributes of every resource. It provides far more detail than needed and can be overwhelming for large states. |
| D — `terraform plan` | This **compares config vs state** and shows planned changes. It doesn't simply list state contents — it shows diffs, which may include no output if nothing has changed. |
| E — `terraform output` | This only shows **output values** defined in `outputs.tf`, not the full list of tracked resources. Many resources may have no corresponding output. |

## State Command Comparison

| Command | Output | Use case |
|---------|--------|----------|
| `terraform state list` | Resource addresses only | "What resources do we manage?" |
| `terraform state show <addr>` | Full attributes of one resource | "What are the details of this specific resource?" |
| `terraform show` | Full state or plan dump | "Show me everything" (debugging, audit) |
| `terraform state list \| wc -l` | Count of resources | "How many resources are under management?" |
| `terraform state list \| grep aws_instance` | Filtered list | "Which EC2 instances are tracked?" |

## Practical Examples

### Count resources in state
```bash
$ terraform state list | wc -l
42
```

### Find resources of a specific type
```bash
$ terraform state list | grep aws_s3_bucket
aws_s3_bucket.logs
aws_s3_bucket.data
aws_s3_bucket.backup
```

### List resources in a module
```bash
$ terraform state list | grep module.vpc
module.vpc.aws_vpc.main
module.vpc.aws_subnet.public
module.vpc.aws_subnet.private
module.vpc.aws_internet_gateway.main
```

### Check if a specific resource is tracked
```bash
$ terraform state list | grep aws_instance.web
aws_instance.web    # ← present in state
```
