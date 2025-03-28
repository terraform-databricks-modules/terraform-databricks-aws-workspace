terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.91.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.70.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.0"
    }
  }
}
