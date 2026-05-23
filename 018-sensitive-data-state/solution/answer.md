# Answer

The two correct statements are: **B and D**.

---

## B — The state file can contain sensitive values in plaintext by default.

The Terraform state file is a plain JSON document. Any value used in a resource — including variables and outputs marked `sensitive = true` — is stored in the state file in **plaintext**:

```json
{
  "outputs": {
    "db_password": {
      "value": "MyS3cret!",
      "sensitive": true
    }
  },
  "resources": [
    {
      "type": "local_file",
      "instances": [{
        "attributes": {
          "content": "password: MyS3cret!"
        }
      }]
    }
  ]
}
```

This is a security concern if the state file is stored insecurely (e.g., unencrypted S3 bucket, local disk with loose permissions).

## D — Marking a variable `sensitive = true` does not prevent it from being written to state.

`sensitive = true` only affects **display**:

| Context | With `sensitive = true` | Without `sensitive` |
|---------|------------------------|---------------------|
| `terraform plan` output | `(sensitive)` | Shows the actual value |
| `terraform apply` output | `(sensitive)` | Shows the actual value |
| `terraform output` | `(sensitive)` | Shows the actual value |
| **State file (JSON)** | **Plaintext value** | **Plaintext value** |
| **Resource data** | **Plaintext value** | **Plaintext value** |
| **Logs** | Redacted | Shows the actual value |

The `sensitive` attribute is a **display-level redaction**, not a **storage-level encryption**.

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Sensitive outputs never stored in state | **False.** Sensitive outputs ARE stored in state — the full value is in the state JSON. Only the CLI/UI display is redacted. |
| C — Local state auto-encrypts | **False.** Local state is plaintext JSON with zero encryption. You must manually encrypt it (e.g., encrypted filesystem, or use a remote backend with encryption). |

## Protecting Sensitive Data in State

| Method | How it works |
|--------|-------------|
| **Remote backend with encryption** | S3 + server-side encryption, GCS + CMEK, Azure Storage + encryption at rest |
| **State locking** | Prevents concurrent access (DynamoDB, Consul) |
| **Terraform Cloud/Enterprise** | State is encrypted at rest in HCP Terraform's backend |
| **Sensitive variables in HCP Terraform** | Marked as sensitive in workspace variables — written to state but encrypted in-transit and at-rest in HCP Terraform |
| **External secrets (Vault)** | Avoid storing secrets in state entirely by using `vault` provider to read secrets at plan/apply time |

## Exam Tips

- `sensitive = true` **does not** keep values out of state — it only hides them in CLI output
- State = **plaintext JSON** regardless of `sensitive` flags
- Best practice: use a **remote backend with encryption** (S3 + KMS, Terraform Cloud, etc.)
- If you see "sensitive values are never stored in state" — remember, **false**
- If you see "local state auto-encrypts" — **false**, no auto-encryption
