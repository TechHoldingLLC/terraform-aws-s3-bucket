## CLoudfront access identity
resource "aws_cloudfront_origin_access_identity" "cloudfront" {
  count   = var.cloudfront_access_policy ? 1 : 0
  comment = "Origin Access Identity for S3 bucket"
}

## s3 cloudfront policy
resource "aws_s3_bucket_policy" "s3_cloudfront" {
  count  = var.cloudfront_access_policy ? 1 : 0
  bucket = aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.s3_cloudfront[0].json
}

data "aws_iam_policy_document" "s3_cloudfront" {
  count = var.cloudfront_access_policy ? 1 : 0
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