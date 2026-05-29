# Explanation

The correct answer is **A**.

> `TF_LOG`

---

## Why A Is Correct

`TF_LOG` is the environment variable that controls Terraform's logging verbosity. Setting it enables detailed diagnostic output:

```bash
export TF_LOG=DEBUG
terraform plan
```

| Value | Output | Use Case |
|-------|--------|----------|
| `TRACE` | Most verbose | Debugging deep provider/internal issues |
| `DEBUG` | Detailed | General troubleshooting |
| `INFO` | Normal | Standard operational info |
| `WARN` | Warnings only | Minimal noise |
| `ERROR` | Errors only | Production monitoring |
| `JSON` | Structured | Machine-parseable logs |

## Companion Variable: `TF_LOG_PATH`

```bash
export TF_LOG=DEBUG
export TF_LOG_PATH=./terraform.log
terraform apply
```

`TF_LOG_PATH` redirects log output to a file instead of stdout. This is best practice — it prevents log noise from interfering with normal Terraform output while still capturing full diagnostics.

## What Logs Contain

With `TF_LOG=TRACE` or `DEBUG`, you can see:

- **Provider RPC calls** — every interaction between Terraform and the provider plugin
- **State operations** — reads, writes, serialization/deserialization
- **Graph operations** — vertex creation, edge walking, walk completion
- **Module expansion** — how `count` and `for_each` resolve
- **HTTP requests** — API calls to cloud providers and backends (redacted credentials)

## Why the Others Are Wrong

| Option | Why it's incorrect |
|--------|-------------------|
| B — `TF_DEBUG` | Not a valid Terraform environment variable. Would have no effect. |
| C — `TERRAFORM_LOG` | Not a recognized environment variable. Terraform env vars use the `TF_` prefix. |
| D — `TF_VERBOSE` | Not a valid variable. Common in other tools (e.g., `VERBOSE` in Make) but not Terraform. |
| E — `TF_LOG_LEVEL` | Not a valid variable. The log level is set as the **value** of `TF_LOG`, not a separate variable. |

## Other Important `TF_` Environment Variables

| Variable | Purpose |
|----------|---------|
| `TF_LOG` | Log level (TRACE, DEBUG, INFO, WARN, ERROR, JSON) |
| `TF_LOG_PATH` | File path to write logs to |
| `TF_INPUT` | Disable interactive prompts (`false`) |
| `TF_IN_AUTOMATION` | Signals CI/CD context (adjusts output formatting) |
| `TF_VAR_name` | Set variable values (`TF_VAR_region=us-east-1`) |
| `TF_DATA_DIR` | Override `.terraform` directory path |
| `TF_WORKSPACE` | Select workspace for commands |
| `TF_CLI_ARGS` | Inject additional CLI flags |
| `TF_SKIP_PROVIDER_VERIFY` | Skip provider plugin verification (not recommended) |
