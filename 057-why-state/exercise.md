# Why Terraform Requires State Exercise

**Exam Question:** Your team is discussing why Terraform maintains a state file. Which of the following are valid reasons why Terraform requires state? (Select three.)

## Background

Terraform state (`terraform.tfstate`) is a JSON file that maps your configuration to real-world infrastructure. It serves three primary purposes that are essential for Terraform to function correctly.

## Steps

### Part 1 — Examine a state file

1. **Apply the config to generate a state file:**

   ```bash
   cd /home/terraform-004/057-why-state
   terraform init
   terraform apply -auto-approve
   ```

2. **Examine the state:**

   ```bash
   cat terraform.tfstate | head -40
   ```

   The state file contains:
   - **Resource identity** — the `aws_instance.web` mapped to its real AWS resource ID (`i-abc123`)
   - **Resource attributes** — cached values like `ami`, `instance_type`, `public_ip`
   - **Metadata** — dependencies between resources, version, serial number

### Part 2 — Purpose 1: Map config to real resources

3. **Understand the mapping:**

   ```hcl
   resource "aws_instance" "web" {
     ami           = "ami-abc"
     instance_type = "t2.micro"
   }
   ```

   State records the real resource ID so Terraform knows this config block corresponds to that specific EC2 instance. Without state, Terraform would try to create a new instance every time.

### Part 3 — Purpose 2: Improve performance via caching

4. **Compare plan speed with and without state:**

   With state, Terraform reads cached resource attributes instead of making API calls for every resource on every plan. This dramatically reduces plan time for large infrastructures.

### Part 4 — Purpose 3: Track metadata and dependencies

5. **State records dependencies for ordering:**

   ```json
   {
     "resources": [{
       "type": "aws_subnet",
       "name": "public",
       "instances": [{
         "dependencies": ["aws_vpc.main"]
       }]
     }]
   }
   ```

   This metadata determines create order, destroy order, and parallel execution.

### Part 5 — What state does NOT do

6. **Common misconceptions:**

   - State does **not** encrypt data — it's plaintext JSON
   - State does **not** fix syntax errors — `terraform validate` does that
   - State does **not** validate credentials — provider config does that

### Put It Together

Your team is discussing why Terraform maintains a state file. Which of the following are valid reasons why Terraform requires state? (Select three.)

- A. Map real-world resources to your Terraform configuration
- B. Automatically fix HCL configuration syntax errors
- C. Improve performance by caching resource attributes
- D. Encrypt sensitive data in your configuration files
- E. Validate provider credentials before applying changes
- F. Track metadata such as resource dependencies

## Files

- `main.tf` — config to generate state for inspection
- `outputs.tf` — output values
- `solution/answer.md` — explanation and exam tips
