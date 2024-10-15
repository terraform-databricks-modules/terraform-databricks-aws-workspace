output "databricks_host" {
  description = "The URL of the Databricks workspace"
  value       = databricks_mws_workspaces.this.workspace_url
}
