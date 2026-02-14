resource "random_id" "bucket" {
  byte_length = 4
}

resource "aws_s3_bucket" "databricks_root" {
  bucket = "dp-${var.environment}-databricks-root-${random_id.bucket.hex}"

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


resource "aws_s3_bucket_policy" "databricks_root_policy" {
  bucket = aws_s3_bucket.databricks_root.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowDatabricksAccess"
        Effect = "Allow"

        Principal = {
          AWS = "arn:aws:iam::763432567385:role/dp-dev-databricks-role"
        }

        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]

        Resource = [
          aws_s3_bucket.databricks_root.arn,
          "${aws_s3_bucket.databricks_root.arn}/*"
        ]
      }
    ]
  })
}

