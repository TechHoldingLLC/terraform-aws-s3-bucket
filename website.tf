## webiste
resource "aws_s3_bucket_website_configuration" "website" {
  count  = length(keys(var.website)) > 0 ? 1 : 0
  bucket = aws_s3_bucket.s3.bucket

  dynamic "index_document" {
    for_each = try([var.website["index_document"]], [])

    content {
      suffix = index_document.value
    }
  }

  dynamic "error_document" {
    for_each = try([var.website["error_document"]], [])

    content {
      key = error_document.value
    }
  }

  dynamic "redirect_all_requests_to" {
    for_each = try([var.website["redirect_all_requests_to"]], [])

    content {
      host_name = redirect_all_requests_to.value.host_name
      protocol  = try(redirect_all_requests_to.value.protocol, null)
    }
  }
}

## Allow public read access to objects
resource "aws_s3_bucket_policy" "allow_public_read_access_to_objects" {
  count  = var.bucket_public_read_access ? 1 : 0
  bucket = aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.allow_public_read_access_to_objects[0].json
}

data "aws_iam_policy_document" "allow_public_read_access_to_objects" {
  count = var.bucket_public_read_access ? 1 : 0
  statement {
    sid    = "AllowCloudfrontToGetObjects"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.s3.arn}/*"
    ]

    dynamic "condition" {
      for_each = try([var.bucket_public_read_access_condition], [])
      content {
        test     = condition.value.operator
        variable = condition.value.condition_key
        values   = condition.value.values
      }
    }
  }
}