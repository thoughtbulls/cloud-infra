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
