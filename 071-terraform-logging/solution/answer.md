# Answer

The correct answer is **B**.

> Logging will show you the detailed interactions between Terraform and the provider API and help you identify where the unexpected behavior occurs.

---

## Why B Is Correct

Terraform logging (`TF_LOG`) exposes the full communication between Terraform Core and provider plugins:

```
TF_LOG=TRACE terraform plan

[TRACE] provider.terraform-provider-aws: Configuring provider...
[TRACE] provider.terraform-provider-aws: Building request...
[DEBUG] POST https://ec2.us-east-1.amazonaws.com/
[DEBUG] Request body: Action=DescribeInstances&...
[DEBUG] Response body: <DescribeInstancesResponse>...
[TRACE] provider.terraform-provider-aws: Reading instance attributes...
[TRACE]   instance_type: "t2.micro" (config)
[TRACE]   instance_type: "t3.nano"  (state — drift detected)
```

### What you can diagnose with logs

| Scenario | What logs reveal |
|----------|-----------------|
| Unexpected attribute change | Shows the before/after values Terraform calculated |
| Provider API error | Shows the exact API request and error response |
| Attribute defaulting | Shows where the provider applies defaults not in your config |
| State mismatch | Shows the difference between state and real resource |
| Slow operations | Shows timing of each API call |

### The troubleshooting workflow

```
1. Suspect provider misinterprets config
         │
         ▼
2. Enable logging: export TF_LOG=DEBUG
         │
         ▼
3. Run plan or apply
         │
         ▼
4. Inspect logs for:
   - API request construction
   - Response parsing
   - Attribute value calculations
   - Unexpected defaults
         │
         ▼
5. Identify root cause and fix config
```

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| A — Automatically corrects errors | Logging is **read-only observation** — it does not modify Terraform's behavior or fix errors. It only helps you find the root cause. |
| C — Speeds up apply by caching | Logging actually **adds overhead** (especially TRACE level). It slows down operations and is only meant for debugging. |
| D — Prevents unexpected changes | Logging does not prevent anything. It only shows what Terraform is doing. To prevent changes, fix the config after diagnosing with logs. |
| E — Hides sensitive data | Logging can **expose sensitive data** (passwords, keys, secrets in API responses). This is a known caveat — not a benefit. |

## Terraform Logging Reference

| Variable | Purpose | Example |
|----------|---------|---------|
| `TF_LOG` | Set log level | `export TF_LOG=DEBUG` |
| `TF_LOG_PATH` | Write logs to file | `export TF_LOG_PATH=./debug.log` |
| `TF_LOG_PROVIDER` | Log specific provider | `export TF_LOG_PROVIDER_AWS=TRACE` |

### Log level detail

| Level | Content | When to use |
|-------|---------|-------------|
| `ERROR` | Fatal errors only | Production monitoring |
| `WARN` | Warnings + errors | General awareness |
| `INFO` | Operational messages | Normal operations |
| `DEBUG` | Detailed operations | Troubleshooting |
| `TRACE` | Full API payloads | Deep provider debugging |
| `JSON` | Structured JSON logs | Machine parsing |

## Security Note

⚠️ **Logs may contain sensitive data** — API responses often include passwords, private keys, and other secrets. Never share logs publicly and clean them before attaching to bug reports.

## Objective Reference

**Objective 2b** — Differentiate between Terraform commands and subcommands.

Understanding logging (`TF_LOG`) as a diagnostic tool for troubleshooting Terraform operations and provider interactions.

## Exam Tips

- `TF_LOG` enables Terraform logging — levels: TRACE, DEBUG, INFO, WARN, ERROR, JSON
- Logs show **API requests/responses** between Terraform and providers
- Logs are **read-only** — they diagnose but don't fix or prevent
- `TF_LOG_PATH` redirects logs to a file instead of stderr
- Logging **slows down** operations — don't leave it on in production
- Common exam trap: thinking logging fixes or prevents changes (it only observes)
- Another trap: not knowing that logging can expose sensitive data
