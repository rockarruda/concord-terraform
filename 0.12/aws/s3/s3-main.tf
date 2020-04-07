resource "aws_s3_bucket" "main" {
  bucket = var.s3_bucket_name
  versioning {
    enabled = var.s3_bucket_versioning_enabled
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = var.tags
}
