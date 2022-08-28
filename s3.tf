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
