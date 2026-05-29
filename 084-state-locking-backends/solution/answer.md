# Explanation

The correct answer is **B — False**.

> Not all remote backends support state locking by default. You must verify the locking capabilities of your specific backend and configure locking settings accordingly.

---

## Why the Answer Is False

The statement makes two claims, both of which are incorrect:

| Claim | Reality |
|-------|---------|
| "All remote backends support locking" | ❌ Some backends (HTTP, local, Kubernetes, OSS) do **not** support locking at all |
| "By default, so you never need to worry" | ❌ Even backends that support locking may require **explicit configuration** (e.g., S3 needs a DynamoDB table) |

### Backend locking support

```
                    Locking Support
                    ┌─────────────────────┐
                    │  Yes                │  No
                    │  ┌──────────────┐   │  ┌──────────────┐
                    │  │ AzureRM      │   │  │ HTTP         │
                    │  │ GCS          │   │  │ Local        │
                    │  │ Consul       │   │  │ Kubernetes   │
                    │  │ Postgres     │   │  │ OSS (Alibaba)│
                    │  │ COS (IBM)    │   │  │              │
                    │  └──────────────┘   │  └──────────────┘
                    │  ┌──────────────┐   │
                    │  │ S3           │   │
                    │  │ (requires    │   │
                    │  │  DynamoDB)   │   │
                    │  └──────────────┘   │
                    └─────────────────────┘
```

### S3 locking example

```hcl
backend "s3" {
  bucket = "my-state-bucket"
  key    = "prod/terraform.tfstate"
  region = "us-east-1"

  # Without this line → NO LOCKING
  dynamodb_table = "terraform-locks"   # ← Required for locking
}
```

If you omit `dynamodb_table`, the S3 backend **still works** but without locking protection.

## Why "True" Is Incorrect

Choosing "True" would mean believing:

1. Every backend has built-in locking (they don't)
2. No configuration is needed (it is — e.g., DynamoDB for S3)
3. You never need to check (you must — always verify your backend's docs)

## What to Do About Locking

| Action | Why |
|--------|-----|
| **Verify backend docs** | Each backend page on terraform.io specifies locking support |
| **Configure locking** | For S3, create and configure a DynamoDB table |
| **Use backends with native locking** | AzureRM, GCS, and Postgres have built-in locking |
| **Force-unlock cautiously** | Only when you're certain no operation is active |
| **Never disable locking** | Without it, concurrent operations can corrupt state |

## Backends Without Locking

If you must use a backend without locking (e.g., HTTP), you need external coordination:

- Ensure only one person runs Terraform at a time
- Use CI/CD pipelines with serialized execution
- Accept the risk of concurrent modification
