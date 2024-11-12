locals {
  resource_group_name = strcontains(var.postgresql_server.resource_group, "/resourceGroups/") ? regex("[^\\/]+$", var.postgresql_server.resource_group) :  var.resource_groups[var.postgresql_server.resource_group].name
  kv_resource_group_name = strcontains(var.postgresql_server.key_vault_group, "/resourceGroups/") ? regex("[^\\/]+$", var.postgresql_server.key_vault_group) :  var.resource_groups[var.postgresql_server.key_vault_group].name
}