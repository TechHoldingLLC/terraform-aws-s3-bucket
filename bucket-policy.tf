## s3 cloudfront policy for origin access control
resource "aws_s3_bucket_policy" "bucket_policy" {
  count = (var.origin_access_control || var.block_http_request || var.attach_bucket_policy) ? 1 : 0

  bucket = aws_s3_bucket.s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      var.origin_access_control ? jsondecode(data.aws_iam_policy_document.s3_cloudfront_oac[0].json).Statement : [],
      var.block_http_request ? jsondecode(data.aws_iam_policy_document.block_http_request[0].json).Statement : [],
      (var.attach_bucket_policy && var.bucket_policy != null) ? jsondecode(var.bucket_policy).Statement : []
    )
  })
}

## s3 cloudfront policy document for origin access control
data "aws_iam_policy_document" "s3_cloudfront_oac" {
  count = var.origin_access_control ? 1 : 0
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
}

#Deny all HTTP Request
data "aws_iam_policy_document" "block_http_request" {
  count = var.block_http_request ? 1 : 0

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
