# This module does NOT define its own provider blocks.
# It inherits the default provider from the calling module,
# or receives one explicitly via the `providers` argument.

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "inherited-provider-vpc"
  }
}
