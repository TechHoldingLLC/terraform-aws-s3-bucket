## CLoudfront origin access identity
resource "aws_cloudfront_origin_access_identity" "cloudfront" {
  count   = var.origin_access_identity ? 1 : 0
  comment = "Origin Access Identity for S3 bucket"
}

## CLoudfront origin access control
resource "aws_cloudfront_origin_access_control" "cloudfront" {
  count                             = var.origin_access_control ? 1 : 0
  name                              = var.name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

## s3 cloudfront policy for origin access identity
resource "aws_s3_bucket_policy" "s3_cloudfront_oai" {
  count  = var.origin_access_identity ? 1 : 0
  bucket = aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.s3_cloudfront_oai[0].json
}

## s3 cloudfront policy document for origin access identity
data "aws_iam_policy_document" "s3_cloudfront_oai" {
  count = var.origin_access_identity ? 1 : 0
  statement {
    sid    = "AllowCloudfrontToListBucket"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.cloudfront[0].iam_arn
      ]
    }

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.s3.arn
    ]
  }
  statement {
    sid    = "AllowCloudfrontToGetObjects"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.cloudfront[0].iam_arn
      ]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.s3.arn}/*"
    ]
  }
}

## s3 cloudfront policy for origin access control
resource "aws_s3_bucket_policy" "s3_cloudfront_oac" {
  count  = var.origin_access_control ? 1 : 0
  bucket = aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.s3_cloudfront_oac[0].json
}

## s3 cloudfront policy document for origin access control
data "aws_iam_policy_document" "s3_cloudfront_oac" {
  count = var.origin_access_control ? 1 : 0

  ## ClourFront OAC
  statement {
    sid    = "AllowCloudfrontToListBucket"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "cloudfront.amazonaws.com"
      ]
    }

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.s3.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        var.cloudfront_arn
      ]
    }
  }

  statement {
    sid    = "AllowCloudfrontToGetObjects"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "cloudfront.amazonaws.com"
      ]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.s3.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        var.cloudfront_arn
      ]
    }
  }

  ## Deny all HTTP requests
  statement {
    sid    = "BlockHTTPRequests"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.s3.arn,
      "${aws_s3_bucket.s3.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
