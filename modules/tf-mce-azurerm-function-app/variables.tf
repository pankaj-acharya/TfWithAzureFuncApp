variable "function_app_name" {
  type        = string
  description = "The name of the Function App."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Function App."
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists."
}

variable "app_service_plan_id" {
  type        = string
  description = "The ID of the Function App Plan within which to create this Function App."
}

variable "app_settings" {
  type        = map(string)
  description = "A key-value pair of App Settings."
  default     = {}
  sensitive   = true
}


variable "auth_settings" {

  type = object({
    enabled                        = bool
    additional_login_params        = map(string)
    allowed_external_redirect_urls = list(string)
    default_provider               = string
    issuer                         = string
    runtime_version                = string
    token_refresh_extension_hours  = number
    token_store_enabled            = bool
    unauthenticated_client_action  = string
  })

  description = <<-EOT
  The schema for auth_settings should look like this:
  ```
  {
    enabled                           = bool          - (Required) Is Authentication enabled?
    additional_login_params           = map(string)   - (Optional) Login parameters to send to the OpenID Connect authorization endpoint when a user logs in. Each parameter must be in the form "key=value".
    allowed_external_redirect_urls    = list(string)  - (Optional) External URLs that can be redirected to as part of logging in or logging out of the app.
    default_provider                  = string        - (Optional) The default provider to use when multiple providers have been set up. Possible values are `AzureActiveDirectory`, `Facebook`, `Google`, `MicrosoftAccount` and `Twitter`.
    **NOTE**: When using multiple providers, the default provider must be set for settings like unauthenticated_client_action to work.  
    issuer                            = string        - (Optional) Issuer URI. When using Azure Active Directory, this value is the URI of the directory tenant, e.g. https://sts.windows.net/{tenant-guid}/.
    runtime_version                   = string        - (Optional) The runtime version of the Authentication/Authorization module.
    token_refresh_extension_hours     = number        - (Optional) The number of hours after session token expiration that a session token can be used to call the token refresh API. Defaults to 72.
    token_store_enabled               = bool          - (Optional) If enabled the module will durably store platform-specific security tokens that are obtained during login flows. Defaults to false.
    unauthenticated_client_action     = string        - (Optional) The action to take when an unauthenticated client attempts to access the app. Possible values are `AllowAnonymous` and `RedirectToLoginPage`.
  }
  ```
  **NOTE**: If a property above is not needed then it needs to be explicitly set to `null` or `[]` (empty list).
  EOT

  default = null
}

variable "auth_settings_active_directory" {

  type = object({
    client_id         = string
    client_secret     = string
    allowed_audiences = list(string)
  })

  description = <<-EOT
    The schema for active_directory auth_settings should look like this:
    ```
    {
      client_id                       = sting         - (Required) The Client ID of this relying party application. Enables OpenIDConnection authentication with Azure Active Directory.
      client_secret                   = string        - (Optional) The Client Secret of this relying party application. If no secret is provided, implicit flow will be used.
      allowed_audiences               = list(string)  - (Optional) Allowed audience values to consider when validating JWTs issued by Azure Active Directory.
    }
    ```
  EOT

  default = null
}

variable "auth_settings_facebook" {

  type = object({
    app_id       = string
    app_secret   = string
    oauth_scopes = list(string)
  })

  description = <<-EOT
    The schema for facebook auth_settings should look like this:
    ```
    {
      app_id                          = string        - (Required) The App ID of the Facebook app used for login
      app_secret                      = string        - (Required) The App Secret of the Facebook app used for Facebook Login.
      oauth_scopes                    = list(string)  - (Optional) The OAuth 2.0 scopes that will be requested as part of Facebook Login authentication.
    }
    ```
  EOT

  default = null
}

variable "auth_settings_google" {

  type = object({
    app_id       = string
    app_secret   = string
    oauth_scopes = list(string)
  })

  description = <<-EOT
    The schema for google auth_settings should look like this:
    ```
    {
      client_id                       = string        - (Required) The OpenID Connect Client ID for the Google web application.
      client_secret                   = string        - (Required) The client secret associated with the Google web application.
      oauth_scopes                    = list(string)  - (Optional) The OAuth 2.0 scopes that will be requested as part of Google Sign-In authentication.
    }
    ```
  EOT

  default = null
}

variable "auth_settings_microsoft" {

  type = object({
    app_id       = string
    app_secret   = string
    oauth_scopes = list(string)
  })

  description = <<-EOT
    The schema for microsoft auth_settings should look like this:
    ```
    {
      client_id                       = string        - (Required) The OAuth 2.0 client ID that was created for the app used for authentication.
      client_secret                   = string        - (Required) The OAuth 2.0 client secret that was created for the app used for authentication.
      oauth_scopes                    = list(string)  - (Optional) The OAuth 2.0 scopes that will be requested as part of Microsoft Account authentication. https://msdn.microsoft.com/en-us/library/dn631845.aspx
    }
    ```
  EOT

  default = null
}

variable "connection_strings" {
  type = list(object({
    name  = string
    type  = string
    value = string
  }))

  description = <<EOF
    One or more blocks of connection string configuration. supprots following.
    name  = string  - (Required) The name of the Connection String.
    type  = string  - (Required) The type of the Connection String. Possible values are `APIHub`, `Custom`, `DocDb`, `EventHub`, `MySQL`, `NotificationHub`, `PostgreSQL`, `RedisCache`, `ServiceBus`, `SQLAzure` and `SQLServer`.
    value = string  - (Required) The value for the Connection String.
  EOF

  default = null
}

variable "client_affinity_enabled" {
  type        = bool
  description = "Should the Function App send session affinity cookies, which route client requests in the same session to the same instance?"
  default     = false
}

variable "client_cert_mode" {
  type        = string
  description = "The mode of the Function App's client certificates requirement for incoming requests. Possible values are `Required` and `Optional`."
  default     = null
}

variable "daily_memory_time_quota" {
  type        = number
  description = "The amount of memory in gigabyte-seconds that your application is allowed to consume per day."
  default     = 0
}

variable "enabled" {
  type        = bool
  description = "Is the Function App Enabled?"
  default     = true
}

variable "enable_builtin_logging" {
  type        = bool
  description = "Should the built-in logging of this Function App be enabled?"
  default     = true
}

variable "https_only" {
  type        = bool
  description = "Can the Function App only be accessed via HTTPS? Defaults to false."
  default     = false
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = list(string)
  })

  description = <<-EOT
  The Principal ID for the Service Principal associated with the Managed Service Identity of this Function App.
  The schema for identity should look like this:
  ```
  {
    type            = string        - Specifies the identity type of the Function App. Possible values are `SystemAssigned` (where Azure will generate a Service Principal for you), `UserAssigned` where you can specify the Service Principal IDs in the identity_ids field, and SystemAssigned, UserAssigned which assigns both a system managed identity as well as the specified user assigned identities.
    identity_ids    = list(string)  - (Optional) Specifies a list of user managed identity ids to be assigned. Required if type is UserAssigned.    
  }
  ```

  **NOTE**: If a property above is not needed then it needs to be explicitly set to `null` or `[]` (empty list).
  EOT

  default = null

  validation {
    condition     = (var.identity.type == "UserAssigned" && var.identity.identity_ids == null) ? false : true
    error_message = "Identity_ids is Required when type is UserAssigned."
  }
}

variable "os_type" {
  type        = string
  description = "A string indicating the Operating System type for this function app. This value will be linux for Linux derivatives, or an empty string for Windows (default). When set to linux you must also set azurerm_app_service_plan arguments as kind = \"Linux\" and reserved = true"
  default     = ""
}

variable "site_configs" {

  type = object({
    always_on                        = bool
    app_scale_limit                  = number
    dotnet_framework_version         = string
    elastic_instance_minimum         = number
    ftps_state                       = string
    health_check_path                = string
    http2_enabled                    = bool
    java_version                     = string
    linux_fx_version                 = string
    min_tls_version                  = string
    pre_warmed_instance_count        = number
    runtime_scale_monitoring_enabled = bool
    scm_type                         = string
    scm_use_main_ip_restriction      = bool
    use_32_bit_worker_process        = bool

    cors = object({
      allowed_origins     = list(string)
      support_credentials = bool
    })
  })

  description = <<-EOT
  The schema for site_configs should look like this:
  ```
  {
    always_on                             = bool          - (Optional) Should the app be loaded at all times? Defaults to false.
    app_scale_limit                       = number        - (Optional) The number of workers this function app can scale out to. Only applicable to apps on the Consumption and Premium plan.
    dotnet_framework_version              = string        - (Optional) The version of the .net framework's CLR used in this Function App. Possible values are `v2.0` (which will use the latest version of the .net framework for the .net CLR v2 - currently .net 3.5), `v4.0` (which corresponds to the latest version of the .net CLR v4 - which at the time of writing is .net 4.7.1), `v5.0` and v6.0.
    elastic_instance_minimum              = number        - (Optional) The number of minimum instances for this function app. Only affects apps on the Premium plan.
    ftps_state                            = string        - (Optional) State of FTP / FTPS service for this Function App. Possible values include: `AllAllowed`, `FtpsOnly`, `Disabled`.
    health_check_path                     = string        - (Optional) The health check path to be pinged by Function App.
    http2_enabled                         = bool          - (Optional) Is HTTP2 Enabled on this Function App? Defaults to false.
    java_version                          = string        - (Optional) The version of Java to use. If specified java_container and java_container_version must also be specified. Possible values are `1.7`, `1.8`, `11` and their specific versions - except for Java 11
    linux_fx_version                      = string        - (Optional) Linux App Framework and version for the Function App. Possible options are a `Docker container` , `a base-64 encoded Docker Compose file`.
    min_tls_version                       = string        - (Optional) The minimum supported TLS version for the Function App. Possible values are `1.0`, `1.1`, and `1.2`. Defaults to `1.2` for new Function Apps.
    pre_warmed_instance_count             = number        - (Optional) The number of pre-warmed instances for this function app. Only affects apps on the Premium plan.
    runtime_scale_monitoring_enabled      = bool          - (Optional) Should Runtime Scale Monitoring be enabled?. Only applicable to apps on the Premium plan. Defaults to false.        
    scm_type                              = string        - (Optional) The type of Source Control enabled for this Function App. Defaults to None. Possible values are: `BitbucketGit`, `BitbucketHg`, `CodePlexGit`, `CodePlexHg`, `Dropbox`, `ExternalGit`, `ExternalHg`, `GitHub`, `LocalGit`, `None`, `OneDrive`, `Tfs`, `VSO` and `VSTSRM`
    scm_use_main_ip_restriction           = bool          - (Optional) IP security restrictions for scm to use main. Defaults to false.
    **NOTE**: Any scm_ip_restriction blocks configured are ignored by the service when scm_use_main_ip_restriction is set to true. Any scm restrictions will become active if this is subsequently set to false or removed.
    use_32_bit_worker_process             = bool          - (Optional) Should the Function App run in 32 bit mode, rather than 64 bit mode? Defaults to true.

    cors = {
      allowed_origins                     = list(string)  - (Optional) A list of origins which should be able to make cross-origin calls. * can be used to allow all calls.
      support_credentials                 = bool          - (Optional) Are credentials supported? 
    }
  }
  ```
  EOT

  default = null
}

variable "site_configs_ip_restriction" {

  type = list(object({
    name                      = string
    ip_address                = string
    service_tag               = string
    virtual_network_subnet_id = string
    action                    = string
    priority                  = number

    headers = object({
      x_azure_fdid      = list(string)
      x_fd_health_probe = list(string)
      x_forwarded_for   = list(string)
      x_forwarded_host  = list(string)
    })
  }))

  description = <<-EOT
    A List of objects representing `ip restrictions` as defined below.
    ```  
      [{
        name                      = string        - (Optional) The name for this IP Restriction.
        ip_address                = string        - (Optional) The IP Address used for this IP Restriction in CIDR notation.
        service_tag               = string        - (Optional) The Service Tag used for this IP Restriction.
        virtual_network_subnet_id = string        - (Optional) The Virtual Network Subnet ID used for this IP Restriction.
        **NOTE**:One of either ip_address, service_tag or virtual_network_subnet_id must be specified
        action                    = string        - (Optional) Allow or Deny access for this IP range. Defaults to Allow.
        priority                  = number        - (Optional) The priority for this IP Restriction. Restrictions are enforced in priority order. By default, priority is set to 65000 if not specified.     
        
        headers = {
          x_azure_fdid            = list(string)  - (Optional) A list of allowed Azure FrontDoor IDs in UUID notation with a maximum of 8.
          x_fd_health_probe       = list(string)  - (Optional) A list to allow the Azure FrontDoor health probe header. Only allowed value is "1".
          x_forwarded_for         = list(string)  - (Optional) A list of allowed 'X-Forwarded-For' IPs in CIDR notation with a maximum of 8
          x_forwarded_host        = list(string)  - (Optional) A list of allowed 'X-Forwarded-Host' domains with a maximum of 8.
        }      
      }]
    **NOTE**: Explicitly set site_configs_ip_restriction to empty list ([]) to remove it.  
    ```
  EOT

  default = []
}

variable "site_configs_scm_ip_restriction" {

  type = list(object({
    name                      = string
    ip_address                = string
    service_tag               = string
    virtual_network_subnet_id = string
    action                    = string
    priority                  = number

    headers = object({
      x_azure_fdid      = list(string)
      x_fd_health_probe = list(string)
      x_forwarded_for   = list(string)
      x_forwarded_host  = list(string)
    })
  }))

  description = <<-EOT
    A List of objects representing `scm ip restrictions` as defined below.
    ```  
      [{
        name                      = string        - (Optional) The name for this IP Restriction.
        ip_address                = string        - (Optional) The IP Address used for this IP Restriction in CIDR notation.
        service_tag               = string        - (Optional) The Service Tag used for this IP Restriction.
        virtual_network_subnet_id = string        - (Optional) The Virtual Network Subnet ID used for this IP Restriction.
        **NOTE**:One of either ip_address, service_tag or virtual_network_subnet_id must be specified
        action                    = string        - (Optional) Allow or Deny access for this IP range. Defaults to Allow.
        priority                  = number        - (Optional) The priority for this IP Restriction. Restrictions are enforced in priority order. By default, priority is set to 65000 if not specified.     
        
        headers = {
          x_azure_fdid            = list(string)  - (Optional) A list of allowed Azure FrontDoor IDs in UUID notation with a maximum of 8.
          x_fd_health_probe       = list(string)  - (Optional) A list to allow the Azure FrontDoor health probe header. Only allowed value is "1".
          x_forwarded_for         = list(string)  - (Optional) A list of allowed 'X-Forwarded-For' IPs in CIDR notation with a maximum of 8
          x_forwarded_host        = list(string)  - (Optional) A list of allowed 'X-Forwarded-Host' domains with a maximum of 8.
        }      
      }]
    **NOTE**: Explicitly set site_configs_scm_ip_restriction to empty list ([]) to remove it.        
    ```
  EOT

  default = []
}

variable "source_control" {

  type = object({
    repo_url           = string
    branch             = string
    manual_integration = bool
    rollback_enabled   = bool
    use_mercurial      = bool
  })

  description = <<-EOT
    Source Control information. To use this settings, require to set site_config scm_type variable 
    Supports the following. 
    repo_url            = string  - (Required) The URL of the source code repository.
    branch              = string  - (Optional) The branch of the remote repository to use. Defaults to 'master'.
    manual_integration  = bool    - (Optional) Limits to manual integration. Defaults to false if not specified.
    rollback_enabled    = bool    - (Optional) Enable roll-back for the repository. Defaults to false if not specified.
    use_mercurial       = bool    - (Optional) Use Mercurial if true, otherwise uses Git.
  EOT

  default = null

  validation {
    condition     = var.source_control == null ? true : var.source_control.branch == null ? true : var.source_control.repo_url == null ? false : true
    error_message = "Attributes repo_url can't be null or empty if branch is not null."
  }
}

variable "storage_account_name" {
  type        = string
  description = "The backend storage account name which will be used by this Function App."
}

variable "storage_account_access_key" {
  type        = string
  description = "The access key which will be used to access the backend storage account for the Function App."
}

variable "function_app_version" {
  type        = string
  description = "The runtime version associated with the Function App."
  default     = "~1"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
}