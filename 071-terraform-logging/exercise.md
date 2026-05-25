# Terraform Logging Exercise

**Exam Question:** You are troubleshooting an issue where Terraform is modifying certain resource attributes during apply operations that you didn't expect. You suspect the provider is interpreting your configuration differently than expected. What is the primary benefit of enabling Terraform logging in this situation?

## Background

Terraform logging provides visibility into the internal operations of Terraform and its provider plugins. When unexpected behavior occurs, logs reveal the exact API calls, responses, and decision-making that happen during plan and apply.

## Steps

### Part 1 — Understanding TF_LOG

1. **Terraform uses the `TF_LOG` environment variable:**

   ```bash
   export TF_LOG=DEBUG
   ```

   | Log Level | Verbosity | Use Case |
   |-----------|-----------|----------|
   | `TRACE` | Most verbose | Deep provider API debugging |
   | `DEBUG` | High | General troubleshooting |
   | `INFO` | Medium | Operational messages |
   | `WARN` | Low | Warnings only |
   | `ERROR` | Lowest | Errors only |
   | `JSON` | Structured | Machine-readable logging |

### Part 2 — Run a plan with logging enabled

2. **Enable logging and run plan:**

   ```bash
   export TF_LOG=DEBUG
   terraform plan 2>&1 | head -100
   ```

   The log output includes:
   - Provider initialization details
   - API request construction
   - API response parsing
   - Attribute value calculations
   - State comparisons

3. **Save logs to a file:**

   ```bash
   export TF_LOG_PATH=./terraform-debug.log
   export TF_LOG=TRACE
   terraform apply -auto-approve
   ```

   All log output is written to `terraform-debug.log` for detailed analysis.

### Part 3 — What logs reveal

4. **Logs show the provider API interaction chain:**

   ```
   [DEBUG] provider.terraform-provider-aws_v5.x.x: Preparing API request
   [DEBUG] provider.terraform-provider-aws_v5.x.x: Sending API request
   [DEBUG] provider.terraform-provider-aws_v5.x.x: Received API response
   [DEBUG] provider.terraform-provider-aws_v5.x.x: Response body: {...}
   ```

   This allows you to:
   - ✅ See exactly what Terraform sends to the provider API
   - ✅ See what the provider returns
   - ✅ Identify attribute value transformations
   - ✅ Detect unexpected default values
   - ✅ Trace configuration interpretation

5. **Example: finding unexpected attribute changes:**

   If an instance type is being changed unexpectedly, logs show:

   ```
   [DEBUG] aws_instance.web: Applying changes
   [DEBUG]   instance_type: "t2.micro" => "t3.nano"  (attribute drift detected)
   ```

### Part 4 — What logging does NOT do

6. **Logging limitations:**

   - ❌ Does not fix configuration errors — only reveals them
   - ❌ Does not modify behavior — only observes it
   - ❌ Can reveal sensitive data (passwords, keys) in plain text — be careful with log files

### Put It Together

You are troubleshooting an issue where Terraform is modifying certain resource attributes during apply operations that you didn't expect. You suspect the provider is interpreting your configuration differently than expected. What is the primary benefit of enabling Terraform logging in this situation?

- A. Logging will automatically correct the configuration errors
- B. Logging will show you the detailed interactions between Terraform and the provider API and help you identify where the unexpected behavior occurs
- C. Logging will speed up the apply process by caching provider responses
- D. Logging will prevent the unexpected changes from being applied
- E. Logging will hide all sensitive data from the output

## Files

- `main.tf` — example config for testing with logging
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
