postgre_sql_servers = {
    server1 = {
        resource_group                = "Project"
        key_vault_group = "Keyvault"
        sku_name = "GP_Gen5_2"
        administrator_login          = "psqladmin"
        storage_mb                   = 5120 #Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) 
        backup_retention_days        = 7
        geo_redundant_backup_enabled = false
        auto_grow_enabled            = true
        create_mode  = "Default"
        creation_source_server_id = null #(Optional) For creation modes other than Default, the source server ID to use.
        infrastructure_encryption_enabled = false
        public_network_access_enabled =  false
        restore_point_in_time = null #When create_mode is PointInTimeRestore the point in time to restore from creation_source_server_id. It should be provided in RFC3339 format, e.g. 2013-11-08T22:00:40Z
        ssl_enforcement_enabled = true
        ssl_minimal_tls_version_enforced = "TLS1_2"  #ssl_minimal_tls_version_enforced must be set to TLSEnforcementDisabled when ssl_enforcement_enabled is set to false.
        ad_administrator={
            enabled = false
            adadmin_login                 = "psqladmin1"  #to set a user or group as the AD administrator for an PostgreSQL server in Azure
            adadmin_object_id             = "8f9f455a-2c2c-421a-a409-c65413727c9b"
        }
        identity ={
            type = "SystemAssigned"
        }
        threat_detection_policy = {
            enabled                  =    false
            disabled_alerts = [] #Specifies a list of alerts which should be disabled. Possible values are Sql_Injection, Sql_Injection_Vulnerability, Access_Anomaly, Data_Exfiltration and Unsafe_Action.
            email_account_admins =  false
            email_addresses =   []
            retention_days = 30
            storage_account_access_key = null #Specifies the identifier key of the Threat Detection audit storage account.
            storage_endpoint =    null # Specifies the blob storage endpoint (e.g. https://example.blob.core.windows.net)
        }
        postgre_sql_configuration ={ #Specifies the value of the PostgreSQL Configuration. See the PostgreSQL documentation for valid values. Changing this forces a new resource to be created.
            connection_throttling = "on"
            backslash_quote = "on"
        } 
        version                      = "9.5"
        postgresql_databases = {
            test = {
                charset             = "UTF8"
                collation           = "English_United States.1252"
            }
                
        }

        private_endpoint = {
            postgresqlServer = {                                                  # Key defines the userDefinedstring
                resource_group    = "Project"                           # Required: Resource group name, i.e Project, Management, DNS, etc, or the resource group ID
                subnet            = "OZ"                                # Required: Subnet name, i.e OZ,MAZ, etc, or the subnet ID
                subresource_names = ["postgresqlServer"]                            # Required: Subresource name determines to what service the private endpoint will connect to. see: https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource for list of subresrouce
                # local_dns_zone    = "privatelink.postgresqlServer.core.windows.net" # Optional: Name of the local DNS zone for the private endpoint
            }
        }

        firewall_rules = {
            rule1 ={
                start_ip_address = "0.0.0.0"
                end_ip_address = "255.255.255.255"
            }
        }
        managed_keys = { #Manages a Customer Managed Key for a PostgreSQL Server
            key1={
                key_type     = "RSA"
                key_size     = 2048
                key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
            }
        }
        vnet_rule = {
            enabled = true
            subnet            = "OZ"
            ignore_missing_vnet_service_endpoint = true
        }
    }
}