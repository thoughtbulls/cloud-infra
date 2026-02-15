resource "aws_iam_role" "databricks_role" {
  name = "dp-${var.environment}-databricks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::414351767826:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_access" {
  role       = aws_iam_role.databricks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role" "databricks_storage_role" {
  name = "dp-dev-databricks-storage-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::414351767826:root"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.databricks_account_id
          }
        }
      }
    ]
  })
}

data "terraform_remote_state" "storage" {
  backend = "s3"

  config = {
    bucket = "dp-tf-state-763432567385"
    key    = "${var.environment}/storage/terraform.tfstate"
    region = var.region
  }
}


resource "aws_iam_policy" "databricks_storage_policy" {
  name = "dp-dev-databricks-storage-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:ListBucket"]
        Resource = "arn:aws:s3:::${data.terraform_remote_state.storage.outputs.databricks_root_bucket}"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:PutObjectAcl"
        ]
        Resource = "arn:aws:s3:::${data.terraform_remote_state.storage.outputs.databricks_root_bucket}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.databricks_storage_role.name
  policy_arn = aws_iam_policy.databricks_storage_policy.arn
}


