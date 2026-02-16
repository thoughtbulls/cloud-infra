resource "random_id" "bucket" {
  byte_length = 4
}

resource "aws_s3_bucket" "databricks_root" {
  bucket = "dp-${var.environment}-databricks-root-${random_id.bucket.hex}"
  force_destroy = true

  tags = {
    Purpose = "databricks-root"
    Env     = var.environment
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.databricks_root.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.databricks_root.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
