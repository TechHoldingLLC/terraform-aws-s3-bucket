## s3 cloudfront policy for origin access control
resource "aws_s3_bucket_policy" "bucket_policy" {
  count  = var.origin_access_control || var.https_enabled || var.bucket_policy != null ? 1 : 0
  bucket = aws_s3_bucket.s3.id
  policy =data.aws_iam_policy_document.combined[0].json
}

data "aws_iam_policy_document" "combined" {
  count = var.origin_access_control || var.https_enabled || var.bucket_policy != null ? 1 : 0 

  source_policy_documents = compact([
    var.origin_access_control ? data.aws_iam_policy_document.s3_cloudfront_oac[0].json : "",
    var.https_enabled ? data.aws_iam_policy_document.https_only[0].json : "",
    var.bucket_policy != null ? var.bucket_policy : ""
  ])
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
data "aws_iam_policy_document" "https_only" {
    count = var.https_enabled ? 1 : 0

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
