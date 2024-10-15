# terraform-databricks-aws-workspace

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.71.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | 1.53.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | 0.12.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.71.0 |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.53.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.12.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cross_account_role"></a> [cross\_account\_role](#module\_cross\_account\_role) | terraform-aws-modules/iam/aws//modules/iam-assumable-role | 5.46.0 |
| <a name="module_crossaccount_policy"></a> [crossaccount\_policy](#module\_crossaccount\_policy) | terraform-aws-modules/iam/aws//modules/iam-policy | 5.46.0 |
| <a name="module_root_storage_bucket"></a> [root\_storage\_bucket](#module\_root\_storage\_bucket) | terraform-aws-modules/s3-bucket/aws | 4.2.1 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.13.0 |
| <a name="module_vpc_endpoints"></a> [vpc\_endpoints](#module\_vpc\_endpoints) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | 5.13.0 |

## Resources

| Name | Type |
|------|------|
| [databricks_mws_credentials.this](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/resources/mws_credentials) | resource |
| [databricks_mws_networks.this](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/resources/mws_networks) | resource |
| [databricks_mws_storage_configurations.this](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/resources/mws_storage_configurations) | resource |
| [databricks_mws_workspaces.this](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/resources/mws_workspaces) | resource |
| [time_sleep.wait_30_seconds_for_role](https://registry.terraform.io/providers/hashicorp/time/0.12.1/docs/resources/sleep) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/5.71.0/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.71.0/docs/data-sources/caller_identity) | data source |
| [databricks_aws_bucket_policy.this](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/data-sources/aws_bucket_policy) | data source |
| [databricks_aws_crossaccount_policy.this](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/data-sources/aws_crossaccount_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | n/a | yes |
| <a name="input_databricks_account_id"></a> [databricks\_account\_id](#input\_databricks\_account\_id) | Account ID for Databricks | `string` | n/a | yes |
| <a name="input_databricks_host"></a> [databricks\_host](#input\_databricks\_host) | Databricks host | `string` | `"https://accounts.cloud.databricks.com"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the VPC | `string` | n/a | yes |
| <a name="input_workspace_name"></a> [workspace\_name](#input\_workspace\_name) | Name of the Databricks workspace | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_databricks_host"></a> [databricks\_host](#output\_databricks\_host) | The URL of the Databricks workspace |
<!-- END_TF_DOCS -->
