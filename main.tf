# Generic data lookups

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

# Local variables

locals {
  workspace_name_prefix = replace(trimspace(substr(lower(var.workspace_name), 0, 10)), " ", "_")
  prefix                = "${data.aws_caller_identity.current.account_id}-${local.workspace_name_prefix}"
}

# VPC

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"

  name = "${local.prefix}-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = [for k, v in data.aws_availability_zones.available.names : cidrsubnet(var.vpc_cidr, 8, k)]
  public_subnets  = [for k, v in data.aws_availability_zones.available.names : cidrsubnet(var.vpc_cidr, 8, k + 4)]

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  create_igw           = true

  tags = var.tags
}

# VPC Endpoints

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.17.0"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.vpc.default_security_group_id]

  endpoints = {
    s3 = {
      service      = "s3"
      service_type = "Gateway"
      route_table_ids = flatten([
        module.vpc.private_route_table_ids,
      module.vpc.public_route_table_ids])
      tags = {
        Name = "${local.prefix}-s3-vpc-endpoint"
      }
    },
    sts = {
      service             = "sts"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags = {
        Name = "${local.prefix}-sts-vpc-endpoint"
      }
    },
    kinesis-streams = {
      service             = "kinesis-streams"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags = {
        Name = "${local.prefix}-kinesis-vpc-endpoint"
      }
    },
  }

  tags = var.tags
}

resource "databricks_mws_networks" "this" {
  account_id         = var.databricks_account_id
  network_name       = "${local.prefix}-network"
  security_group_ids = [module.vpc.default_security_group_id]
  subnet_ids         = module.vpc.private_subnets
  vpc_id             = module.vpc.vpc_id
  depends_on         = [module.vpc]
}

# S3 Bucket

module "root_storage_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.2.2"

  bucket = "${local.prefix}-root-storage"

  attach_deny_insecure_transport_policy    = true
  attach_require_latest_tls_policy         = true
  attach_deny_incorrect_encryption_headers = false # Databricks does not support this setting

  force_destroy = true
  attach_policy = true
  policy        = data.databricks_aws_bucket_policy.this.json

  versioning = {
    enabled = true
  }
}


data "databricks_aws_bucket_policy" "this" {
  bucket = "${local.prefix}-root-storage"
}

resource "databricks_mws_storage_configurations" "this" {
  account_id                 = var.databricks_account_id
  bucket_name                = "${local.prefix}-root-storage"
  storage_configuration_name = "${local.prefix}-storage"
  depends_on                 = [module.root_storage_bucket]
}

# IAM Role

data "databricks_aws_crossaccount_policy" "this" {
  policy_type = "customer"
}

module "crossaccount_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.48.0"

  name        = "${local.prefix}-cross-account-policy"
  description = "Databricks Cross Account Policy for ${var.workspace_name}"

  policy = data.databricks_aws_crossaccount_policy.this.json
}

module "cross_account_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.48.0"

  create_role = true

  role_name         = "${local.prefix}-cross-account-role"
  role_requires_mfa = false

  trusted_role_arns = [
    "arn:aws:iam::414351767826:root" # Databricks account
  ]

  role_sts_externalid    = var.databricks_account_id
  allow_self_assume_role = true

  custom_role_policy_arns = [
    module.crossaccount_policy.arn
  ]

  number_of_custom_role_policy_arns = 1
}

# This is a horrible hack to ensure that the role is created before the credentials
resource "time_sleep" "wait_30_seconds_for_role" {
  depends_on = [module.cross_account_role]

  create_duration = "30s"
}

resource "databricks_mws_credentials" "this" {
  role_arn         = module.cross_account_role.iam_role_arn
  credentials_name = "${local.prefix}-creds"
  depends_on       = [time_sleep.wait_30_seconds_for_role]
}


# Databricks Workspace

resource "databricks_mws_workspaces" "this" {
  account_id     = var.databricks_account_id
  aws_region     = var.aws_region
  workspace_name = local.prefix

  credentials_id           = databricks_mws_credentials.this.credentials_id
  storage_configuration_id = databricks_mws_storage_configurations.this.storage_configuration_id
  network_id               = databricks_mws_networks.this.network_id
}
