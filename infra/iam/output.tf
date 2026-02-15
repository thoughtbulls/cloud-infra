output "databricks_role_arn" {
  value = aws_iam_role.databricks_role.arn
}

output "storage_role_arn" {
  value = aws_iam_role.databricks_storage_role.arn
}
