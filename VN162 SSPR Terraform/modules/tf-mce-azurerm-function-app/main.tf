/**
  * ## Descriptions
  *  
  * Terraform module for the creation of a Function App.
  *
  */

resource "azurerm_function_app" "function_app" {
  name                       = var.function_app_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = var.app_service_plan_id
  app_settings               = var.app_settings
  client_affinity_enabled    = var.client_affinity_enabled
  client_cert_mode           = var.client_cert_mode
  daily_memory_time_quota    = var.daily_memory_time_quota
  enabled                    = var.enabled
  enable_builtin_logging     = var.enable_builtin_logging
  https_only                 = var.https_only
  os_type                    = var.os_type
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  version                    = var.function_app_version
  tags                       = var.tags

  dynamic "auth_settings" {
    for_each = var.auth_settings != null ? [var.auth_settings] : []
    iterator = i

    content {
      enabled                        = i.value.enabled
      additional_login_params        = i.value.additional_login_params
      allowed_external_redirect_urls = i.value.allowed_external_redirect_urls
      default_provider               = i.value.default_provider
      issuer                         = i.value.issuer
      runtime_version                = i.value.runtime_version
      token_refresh_extension_hours  = i.value.token_refresh_extension_hours
      token_store_enabled            = i.value.token_store_enabled
      unauthenticated_client_action  = i.value.unauthenticated_client_action

      dynamic "active_directory" {
        for_each = var.auth_settings_active_directory != null ? [var.auth_settings_active_directory] : []
        iterator = j

        content {
          client_id         = j.value.client_id
          client_secret     = j.value.client_secret
          allowed_audiences = j.value.allowed_audiences
        }
      }

      dynamic "facebook" {
        for_each = var.auth_settings_facebook != null ? [var.auth_settings_facebook] : []
        iterator = k

        content {
          app_id       = k.value.app_id
          app_secret   = k.value.app_secret
          oauth_scopes = k.value.oauth_scopes
        }
      }

      dynamic "google" {
        for_each = var.auth_settings_google != null ? [var.auth_settings_google] : []
        iterator = l

        content {
          client_id     = l.value.client_id
          client_secret = l.value.client_secret
          oauth_scopes  = l.value.oauth_scopes
        }
      }

      dynamic "microsoft" {
        for_each = var.auth_settings_microsoft != null ? [var.auth_settings_microsoft] : []
        iterator = m

        content {
          client_id     = m.value.client_id
          client_secret = m.value.client_secret
          oauth_scopes  = m.value.oauth_scopes
        }
      }
    }
  }

  dynamic "connection_string" {
    for_each = var.connection_strings

    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    iterator = i

    content {
      type         = i.value.type
      identity_ids = i.value.identity_ids
    }
  }

  dynamic "site_config" {
    for_each = var.site_configs != null ? [var.site_configs] : []
    iterator = i

    content {
      always_on                        = i.value.always_on
      app_scale_limit                  = i.value.app_scale_limit
      dotnet_framework_version         = i.value.dotnet_framework_version
      elastic_instance_minimum         = i.value.elastic_instance_minimum
      ftps_state                       = i.value.ftps_state
      health_check_path                = i.value.health_check_path
      http2_enabled                    = i.value.http2_enabled
      java_version                     = i.value.java_version
      linux_fx_version                 = i.value.linux_fx_version
      min_tls_version                  = i.value.min_tls_version
      pre_warmed_instance_count        = i.value.pre_warmed_instance_count
      runtime_scale_monitoring_enabled = i.value.runtime_scale_monitoring_enabled
      scm_type                         = i.value.scm_type
      scm_use_main_ip_restriction      = i.value.scm_use_main_ip_restriction
      use_32_bit_worker_process        = i.value.use_32_bit_worker_process

      dynamic "cors" {
        for_each = i.value.cors != null ? [i.value.cors] : []
        iterator = j

        content {
          allowed_origins     = j.value.allowed_origins
          support_credentials = j.value.support_credentials
        }
      }

      dynamic "ip_restriction" {
        for_each = var.site_configs_ip_restriction != null ? var.site_configs_ip_restriction : []
        iterator = k

        content {
          name                      = k.value.name
          ip_address                = k.value.ip_address
          service_tag               = k.value.service_tag
          virtual_network_subnet_id = k.value.virtual_network_subnet_id
          action                    = k.value.action
          priority                  = k.value.priority

          dynamic "headers" {
            for_each = k.value.headers != null ? [k.value.headers] : []
            iterator = l

            content {
              x_azure_fdid      = l.value.x_azure_fdid
              x_fd_health_probe = l.value.x_fd_health_probe
              x_forwarded_for   = l.value.x_forwarded_for
              x_forwarded_host  = l.value.x_forwarded_host
            }
          }
        }
      }

      dynamic "scm_ip_restriction" {
        for_each = var.site_configs_scm_ip_restriction != null ? var.site_configs_scm_ip_restriction : []
        iterator = m

        content {
          name                      = m.value.name
          ip_address                = m.value.ip_address
          service_tag               = m.value.service_tag
          virtual_network_subnet_id = m.value.virtual_network_subnet_id
          action                    = m.value.action
          priority                  = m.value.priority

          dynamic "headers" {
            for_each = m.value.headers != null ? [m.value.headers] : []
            iterator = n

            content {
              x_azure_fdid      = n.value.x_azure_fdid
              x_fd_health_probe = n.value.x_fd_health_probe
              x_forwarded_for   = n.value.x_forwarded_for
              x_forwarded_host  = n.value.x_forwarded_host
            }
          }
        }
      }
    }
  }

  dynamic "source_control" {
    for_each = var.source_control != null ? [var.source_control] : []
    iterator = i

    content {
      repo_url           = i.value.repo_url
      branch             = i.value.branch
      manual_integration = i.value.manual_integration
      rollback_enabled   = i.value.rollback_enabled
      use_mercurial      = i.value.use_mercurial
    }
  }

  lifecycle {
    ignore_changes = [
      app_settings,
      site_config["ip_restriction"]
    ]
  }
}