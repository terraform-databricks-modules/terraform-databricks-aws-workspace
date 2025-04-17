terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.1"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.72.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.0"
    }
  }
}
