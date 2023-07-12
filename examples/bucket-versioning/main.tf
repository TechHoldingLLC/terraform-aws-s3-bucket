provider "aws" {
  region = local.region
  profile = "my-profile" # Change profile name with your profile
  
  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

locals {
  region = "us-west-2"
}

module "s3" {
  source     = "../../"
  name       = "my-bucket-unique-name"
  versioning = "Enabled"
}