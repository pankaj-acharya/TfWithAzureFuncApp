locals {
    project                     = "sspr"
    environment                 = "dev"
    location                    = "uksouth"
    vnet_address_space          = "10.13.0.0/24"
    functionapp_address_prefixes = "10.13.0.0/28"
    tenant_id                   = "1cc2f5af-92fa-4b2a-ac02-b97a9c8a75d3"

    resource_group_name = "SSPR_Azure_App"#format("%s-%s-rg", local.project, local.environment)
    vnet_name           = format("vnet-%s-%s", local.project, local.environment)

    tags = {
        Project     = local.project
        Environment = local.environment
    }

    resource_groups = [
        {
        resource_group_name = local.resource_group_name
        location            = local.location
        tags                = local.tags
        }
    ]

    vnet = {
        service_endpoints = [
        "Microsoft.Web", "Microsoft.Storage"
        ]
        address_space                    = [local.vnet_address_space]
        functionapp_subnet_name          = format("%s-%s-subnet", local.project, local.environment)
        functionapp_address_prefixes     = [local.functionapp_address_prefixes]
    }

    log_analytics = {
        name = format("loganyl-%s-%s", local.project, local.environment)
        sku  = "PerGB2018"
    }

    applicationinsights = {
        name                                  = format("appins-%s-%s", local.project, local.environment)
        application_type                      = "web"
        retention_in_days                     = 90
        daily_data_cap_in_gb                  = null
        daily_data_cap_notifications_disabled = null
        sampling_percentage                   = null
        disable_ip_masking                    = true
        workspace_id                          = azurerm_log_analytics_workspace.log_analytics.id
        local_authentication_disabled         = false
        internet_ingestion_enabled            = null
        internet_query_enabled                = true
    }

    key_vault = {
        name = format("kv-%s-%s", local.project, local.environment)
        sku_name                    = "standard"
        tenant_id                   = local.tenant_id
        enabled_for_disk_encryption = true
        purge_protection_enabled    = false
        soft_delete_retention_days  = 7
    }



  storage_accounts = {
    "001" = {
        storage_account_name              = lower(format("st%s%sfnc", local.project, local.environment))
        location                          = local.location
        tags                              = local.tags
        account_tier                      = "Standard"
        account_kind                      = "StorageV2"
        infrastructure_encryption_enabled = true
    }
  }

  app_service_plan = {
    name = format("asp-%s-%s", local.project, local.environment)
    kind = "Linux"
    maximum_elastic_worker_count = 1
    reserved                   = true
    sku = {
        tier     = "Basic"
        size     = "B1"
        capacity = null
    }
    zone_redundant = false
    location            = local.location
    tags                = local.tags
  }
  
  function_app = {
    name = format("func-%s-%s", local.project, local.environment)
    os_type = "linux"
    function_app_version = "~4"
    https_only = true
    identity = {
        type         = "SystemAssigned"
        identity_ids = null
    }
    site_configs = {
      always_on                        = "true"
      app_scale_limit                  = null
      dotnet_framework_version         = "v6.0"
      elastic_instance_minimum         = null
      ftps_state                       = "Disabled"
      health_check_path                = null
      http2_enabled                    = null
      java_version                     = null
      linux_fx_version                 = "DOTNET|6.0"
      min_tls_version                  = null
      pre_warmed_instance_count        = null
      runtime_scale_monitoring_enabled = null
      scm_type                         = null
      scm_use_main_ip_restriction      = null
      use_32_bit_worker_process        = null
      cors = {
          allowed_origins     = []
          support_credentials = false
      }
    }
  }
}