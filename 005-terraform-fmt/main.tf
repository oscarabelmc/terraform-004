   terraform   {
  required_version = ">= 1.5"
required_providers {
   random = {
   source = "hashicorp/random"
   version = "~> 3.6"
  }
 }
}

  resource    "random_pet"   "a"  {
  prefix = "badly"
	   length  = 2
}

resource "random_pet" "b" {
 prefix = "formatted"
 length = 3

}
