# ❌ EXAMPLE OF WHAT NOT TO DO ❌
# This file demonstrates anti-patterns for secret management.

# Anti-pattern 1: Hardcoded credentials in provider block
provider "aws" {
  access_key = "AKIAIOSFODNN7EXAMPLE"
  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
}

# Anti-pattern 2: Secrets in variable defaults
variable "db_password" {
  type    = string
  default = "hardcoded-password-123"  # ❌ Visible in source code
}

# Anti-pattern 3: Secrets in resource arguments
resource "aws_db_instance" "main" {
  password = "another-hardcoded-password"  # ❌ Visible in plaintext
}
