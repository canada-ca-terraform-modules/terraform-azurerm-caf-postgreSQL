# terraform-azurerm-caf-windows_clusterV2
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_private_endpoint"></a> [private\_endpoint](#module\_private\_endpoint) | github.com/canada-ca-terraform-modules/terraform-azurerm-caf-private_endpoint.git | v1.0.2 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_key.key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_secret.password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_postgresql_active_directory_administrator.admin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_active_directory_administrator) | resource |
| [azurerm_postgresql_configuration.config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_configuration) | resource |
| [azurerm_postgresql_database.db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_database) | resource |
| [azurerm_postgresql_firewall_rule.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_firewall_rule) | resource |
| [azurerm_postgresql_server.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server) | resource |
| [azurerm_postgresql_server_key.server_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server_key) | resource |
| [azurerm_postgresql_virtual_network_rule.network_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_virtual_network_rule) | resource |
| [azurerm_role_assignment.key_vault_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [random_password.generated_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | (Required) 4 character string defining the environment name prefix for the VM | `string` | `"dev"` | no |
| <a name="input_group"></a> [group](#input\_group) | (Required) Character string defining the group for the target subscription | `string` | `"test"` | no |
| <a name="input_key_vault"></a> [key\_vault](#input\_key\_vault) | (Required) List of key vault objects for the postgre SQL server. | `any` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location for the VM | `string` | `"canadacentral"` | no |
| <a name="input_postgresql_server"></a> [postgresql\_server](#input\_postgresql\_server) | (Required) configuration for the postgre SQL server. | `any` | `null` | no |
| <a name="input_private_dns_zone_ids"></a> [private\_dns\_zone\_ids](#input\_private\_dns\_zone\_ids) | (Required) DNS configuration for the postgre SQL server. | `any` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | (Required) Character string defining the project for the target subscription | `string` | `"test"` | no |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Required) Resource group object for the postgre SQL server. | `any` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | (Required) List of subnet objects for the postgre SQL server. | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be applied to every associated VM resource | `map(string)` | `{}` | no |
| <a name="input_userDefinedString"></a> [userDefinedString](#input\_userDefinedString) | (Required) User defined portion value for the name of the VM. | `string` | `"test"` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | Base64 encoded file representing user data script for the VM | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_postgre_SQL_server"></a> [postgre\_SQL\_server](#output\_postgre\_SQL\_server) | The vm module object |
<!-- END_TF_DOCS -->