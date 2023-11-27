# S3
Below is an examples of calling this module.

Note: By default, Serverside encryption using "AES256" is enabled in this module

## Create S3 bucket
```
module "s3" {
  source = "./s3"
  name   = "my-bucket-unique-name"
}
```

## Bucket with versioning
```
module "s3" {
  source     = "./s3"
  name       = "my-bucket-unique-name"
  versioning = "Enabled"
}
```

## Bucket as a Cloudfront origin with Origin access identity
```
module "s3" {
  source                   = "./s3"
  name                     = "my-bucket-unique-name"
  origin_access_identity   = true
}
```

## Bucket as a Cloudfront origin with Origin access control
```
module "s3" {
  source                   = "./s3"
  name                     = "my-bucket-unique-name"
  origin_access_control    = true
}
```

## Bucket for static website
```
module "s3" {
  source                   = "./s3"
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
```

## Bucket to enable website endpoint and redirect all requests to another host
```
module "s3" {
  source                   = "./s3"
  name                     = "my-bucket-unique-name"
  website = {
    redirect_all_requests_to = {
      host_name = "example.co"
      protocol  = "https"
    }
  }
}
```