# Terraform Logging Exercise

**Domain:** Troubleshooting
**Topic:** `TF_LOG` — detailed Terraform logging

## Description

What environment variable can be set to enable detailed logging for Terraform

## Learning Objectives

- Run without logging (baseline)
- Enable logging with TF_LOG
- Write logs to a file
- Unset logging

## Background

When troubleshooting Terraform issues, the standard output may not provide enough detail. Terraform supports **detailed logging** via the `TF_LOG` environment variable, which controls the verbosity of internal logging output.

Log levels (from least to most verbose):

| Level | When to Use |
|-------|-------------|
| `TRACE` | Most verbose — full internal execution details |
| `DEBUG` | Detailed diagnostic information |
| `INFO` | General operational information (default for most operations) |
| `WARN` | Warning conditions |
| `ERROR` | Error events |
| `JSON` | Structured JSON output |

## Steps

### Part 1 — Run without logging (baseline)

1. **Apply the config without any logging:**

   ```bash
   cd /home/terraform-004/032-terraform-logging
   terraform init
   terraform apply -auto-approve
   ```

   This shows the standard output — resource creation summary and no internal details.

### Part 2 — Enable logging with TF_LOG

2. **Set `TF_LOG` and re-apply to trigger a change:**

   ```bash
   export TF_LOG=DEBUG
   terraform apply -auto-approve
   ```

   The output now includes internal execution details:
   - Provider initialization steps
   - Resource attribute calculations
   - State read/write operations
   - Plugin RPC calls

3. **Try the most verbose level:**

   ```bash
   export TF_LOG=TRACE
   terraform plan
   ```

   `TRACE` shows every function call, HTTP request, and state transformation. This is the most detailed logging level.

### Part 3 — Write logs to a file

4. **Redirect logs to a file with `TF_LOG_PATH`:**

   ```bash
   export TF_LOG=DEBUG
   export TF_LOG_PATH=./terraform-debug.log
   terraform apply -auto-approve
   ```

   Instead of cluttering stdout, logs are written to the specified file:

   ```bash
   cat terraform-debug.log | head -30
   ```

   This is the recommended approach for troubleshooting — use `TF_LOG_PATH` to capture logs without interleaving them with normal command output.

### Part 4 — Unset logging

5. **Disable logging:**

   ```bash
   unset TF_LOG
   # or
   export TF_LOG=
   ```

   Without `TF_LOG` set, Terraform returns to its default output behavior.

## Files

- `main.tf` — simple random_pet config for testing logging
- `solution/` — reference implementation

