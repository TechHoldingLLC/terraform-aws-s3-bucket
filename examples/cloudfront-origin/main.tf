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

# Bucket with Origin access identity
module "s3" {
  source                 = "../../"
  name                   = "my-bucket-unique-name"
  origin_access_identity = true
}

# Bucket with Origin access control
module "s3_oac" {
  source                = "../../"
  name                  = "my-bucket-unique-name-oac"
  origin_access_control = true
}