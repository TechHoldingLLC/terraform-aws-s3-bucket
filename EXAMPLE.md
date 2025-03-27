# S3
Below is an examples of calling this module.

Note: By default, Serverside encryption using "AES256" and bucket policy of blocking HTTP Request is **enabled** in this module

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

## Bucket with custom bucket policy
```
data "aws_iam_policy_document" "sample_policy" {
  statement {
    sid    = "AllowCloudfrontToGetObject"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = ["arn:aws:s3:::example-bucket/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = ["arn:aws:cloudfront::123456789012:distribution/ABCDEFG12345"] 
    }
  }
}

module "s3" {
  source                   = "./s3"
  name                     = "my-bucket-unique-name"
  attach_bucket_policy     = true
  bucket_policy            = data.aws_iam_policy_document.sample_policy.json
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

## Bucket to enable lifecycle rules
```
module "s3" {
  source                = "./s3"
  name                  = "my-unique-bucket-name"
  versioning            = "Enabled"
  create_lifecycle_rule = true
  lifecycle_rule = [
    {
      id     = "remove-previous-versions"
      status = "Enabled"
      abort_incomplete_multipart_upload = {
        days_after_initiation = 1
      }
      expiration = {
        days                         = 10
        expired_object_delete_marker = true   # Conflicts with days (Remove "days" if you want to set it to true)
      }
      noncurrent_version_expiration ={
        noncurrent_days = 7
      }
    }
  ]

  providers = {
    aws = aws
  }
}
```