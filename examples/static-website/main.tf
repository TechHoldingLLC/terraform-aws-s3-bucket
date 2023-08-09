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
  source                   = "../../"
  name                     = "my-bucket-unique-name"
  bucket_public_read_access = true
  website = {
    index_document = "index.html"
    error_document = "error.html"
        
    # below argument can help to allow bucket objects to accessible publically with specific condition
    # https://docs.aws.amazon.com/AmazonS3/latest/userguide/amazon-s3-policy-keys.html
    # bucket_public_read_access_condition = {
    #   operator      = "StringLike"
    #   condition_key = "aws:Referer"
    #   values        = ["https://frommywebsite.com"]
    # }
  }
}