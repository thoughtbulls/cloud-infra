output "workspace_url" {
  value = databricks_mws_workspaces.workspace.workspace_url
}

output "workspace_id" {
  value = databricks_mws_workspaces.workspace.workspace_id
}

output "workspace_region" {
  value = var.region
}
