resource "azurerm_postgresql_server" "server" {
  name                = local.postgre-sql-server-name
  location            = var.location
  resource_group_name = local.resource_group_name

  sku_name = try(var.postgresql_server.sku_name, "GP_Gen5_2")

  storage_mb                   = try(var.postgresql_server.storage_mb,5120)
  backup_retention_days        = try(var.postgresql_server.backup_retention_days ,7)
  geo_redundant_backup_enabled = try(var.postgresql_server.geo_redundant_backup_enabled, false)
  auto_grow_enabled            = try(var.postgresql_server.auto_grow_enabled, true)
  create_mode  = try(var.postgresql_server.create_mode, "Default")
  creation_source_server_id = try(var.postgresql_server.creation_source_server_id, null)
  infrastructure_encryption_enabled = try(var.postgresql_server.infrastructure_encryption_enabled, false)
  public_network_access_enabled = try(var.postgresql_server.public_network_access_enabled, false)
  restore_point_in_time = try(var.postgresql_server.restore_point_in_time, null)
  ssl_enforcement_enabled = try(var.postgresql_server.ssl_enforcement_enabled, true)
  ssl_minimal_tls_version_enforced = try(var.postgresql_server.ssl_minimal_tls_version_enforced, "TLS1_2")
  identity {
    type = try(var.postgresql_server.identity.type, "SystemAssigned")
  }
  threat_detection_policy {
    enabled                  =    try(var.postgresql_server.threat_detection_policy.enabled, false)
    disabled_alerts = try(var.postgresql_server.threat_detection_policy.disabled_alerts, null)  
    email_account_admins =  try(var.postgresql_server.threat_detection_policy.email_account_admins, false)
    email_addresses =   try(var.postgresql_server.threat_detection_policy.email_addresses, null)
    retention_days = try(var.postgresql_server.threat_detection_policy.retention_days, 30)
    storage_account_access_key = try(var.postgresql_server.threat_detection_policy.storage_account_access_key, null) 
    storage_endpoint =    try(var.postgresql_server.threat_detection_policy.storage_endpoint, null)
  }

  administrator_login          = try(var.postgresql_server.administrator_login, "psqladmin")
  administrator_login_password = azurerm_key_vault_secret.password.value
  version                      =  try(var.postgresql_server.version, 9.5)
  lifecycle{
    ignore_changes = [ threat_detection_policy ]
  }
}

resource "azurerm_postgresql_database" "db" {
  for_each = var.postgresql_server.postgresql_databases
  name                = each.key
  resource_group_name = local.resource_group_name
  server_name         = azurerm_postgresql_server.server.name
  charset             = try(each.value.charset, "UTF8")
  collation           = try(each.value.collation, "English_United States.1252")

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_postgresql_configuration" "config" {
  for_each = try(var.postgresql_server.postgre_sql_configuration, {})
  name                = each.key
  resource_group_name = local.resource_group_name
  server_name         = azurerm_postgresql_server.server.name
  value               = each.value
}

resource "azurerm_postgresql_active_directory_administrator" "admin" {
  count = try(var.postgresql_server.ad_administrator, false) == false ? 0 : 1
  server_name         = azurerm_postgresql_server.server.name
  resource_group_name = local.resource_group_name
  login               = var.postgresql_server.ad_administrator.adadmin_login
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = var.postgresql_server.ad_administrator.adadmin_object_id
}

resource "azurerm_postgresql_firewall_rule" "firewall" {
  for_each = try(var.postgresql_server.firewalls, {})
  name                = "${local.postgre-sql-server-name}-${each.key}-fw"
  resource_group_name = local.resource_group_name
  server_name         = azurerm_postgresql_server.server.name
  start_ip_address    = var.postgresql_server.firewall.start_ip_address
  end_ip_address      = var.postgresql_server.firewall.end_ip_address
}

resource "azurerm_role_assignment" "key_vault_role_assignment" {
  scope                = var.key_vault.id
  role_definition_name = "Key Vault Crypto Officer"  # Use the role you need
  principal_id         = azurerm_postgresql_server.server.identity.0.principal_id
}

resource "azurerm_key_vault_key" "key" {
  for_each = try(var.postgresql_server.managed_keys, {})
  name         = "${local.postgre-sql-server-name}-${each.key}-key"
  key_vault_id = var.key_vault.id
  key_type     = each.value.key_type
  key_size     = each.value.key_size
  key_opts     = each.value.key_opts
  depends_on = [
    azurerm_role_assignment.key_vault_role_assignment
  ]

}

resource "azurerm_postgresql_server_key" "server_key" {
  for_each = try(var.postgresql_server.managed_keys, {})
  server_id        = azurerm_postgresql_server.server.id
  key_vault_key_id = azurerm_key_vault_key.key[each.key].id
}

resource "azurerm_postgresql_virtual_network_rule" "network_rule" {
  count = try(var.postgresql_server.private_endpoint.enabled, false) == false ? 0 : 1
  name                                 = "${local.postgre-sql-server-name}-rule"
  resource_group_name                  = local.resource_group_name
  server_name                          = azurerm_postgresql_server.server.name
  subnet_id                            = var.subnets[var.postgresql_server.vnet_rule.subnet].id
  ignore_missing_vnet_service_endpoint = var.postgresql_server.vnet_rule.ignore_missing_vnet_service_endpoint
}

# Calls this module if we need a private endpoint attached to the storage account
module "private_endpoint" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-private_endpoint.git?ref=v1.0.2"
  for_each =  try(var.postgresql_server.private_endpoint, {}) 

  name = "${local.postgre-sql-server-name}-${each.key}"
  location = var.location
  resource_groups = var.resource_groups
  subnets = var.subnets
  private_connection_resource_id = azurerm_postgresql_server.server.id
  private_endpoint = each.value
  private_dns_zone_ids = var.private_dns_zone_ids
  tags = var.tags
}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault.name
  resource_group_name = local.kv_resource_group_name
}



resource "random_password" "generated_password" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "password" {
  name         = "psql-admin-password"
  value        = random_password.generated_password.result
  key_vault_id = var.key_vault.id
}



data "azurerm_client_config" "current" {}