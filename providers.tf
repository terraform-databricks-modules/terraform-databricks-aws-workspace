provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.tags
  }
}

provider "databricks" {
  auth_type  = "oauth-m2m"
  account_id = var.databricks_account_id
  host       = var.databricks_host
}

provider "time" {}
