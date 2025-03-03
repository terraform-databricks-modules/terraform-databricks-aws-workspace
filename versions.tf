terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.83.1"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.68.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.12.1"
    }
  }
}
