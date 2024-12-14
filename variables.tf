variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "workspace_name" {
  description = "Name of the Databricks workspace"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "databricks_account_id" {
  description = "Account ID for Databricks"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "databricks_host" {
  description = "Databricks host"
  type        = string
  default     = "https://accounts.cloud.databricks.com"
}

variable "denied_targets" {
  description = "List of HTTP host targets to deny in network firewall"
  type        = list(string)
}

variable "allowed_targets" {
  description = "List of HTTP host targets to allow in network firewall"
  type        = list(string)
}
