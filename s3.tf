resource "aws_s3_bucket" "main" {
  bucket_prefix = "cf-oac-with-tf-example-"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "hello_txt" {
  bucket  = aws_s3_bucket.main.id
  key     = "hello.txt"
  content = "hello world"
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.s3_main_policy.json
}

data "aws_iam_policy_document" "s3_main_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.main.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.main.arn]
    }
  }

  statement {
    sid = "legacy"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.legacy.iam_arn]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.main.arn}/*"]
  }
}

