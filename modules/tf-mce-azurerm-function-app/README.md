## Descriptions

Terraform module for the creation of a Function App.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.0.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.73.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_function_app.function_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app) | resource |



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_service_plan_id"></a> [app\_service\_plan\_id](#input\_app\_service\_plan\_id) | The ID of the Function App Plan within which to create this Function App. | `string` | n/a | yes |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | A key-value pair of App Settings. | `map(string)` | `{}` | no |
| <a name="input_auth_settings"></a> [auth\_settings](#input\_auth\_settings) | The schema for auth\_settings should look like this:<pre>{<br>  enabled                           = bool          - (Required) Is Authentication enabled?<br>  additional_login_params           = map(string)   - (Optional) Login parameters to send to the OpenID Connect authorization endpoint when a user logs in. Each parameter must be in the form "key=value".<br>  allowed_external_redirect_urls    = list(string)  - (Optional) External URLs that can be redirected to as part of logging in or logging out of the app.<br>  default_provider                  = string        - (Optional) The default provider to use when multiple providers have been set up. Possible values are `AzureActiveDirectory`, `Facebook`, `Google`, `MicrosoftAccount` and `Twitter`.<br>  **NOTE**: When using multiple providers, the default provider must be set for settings like unauthenticated_client_action to work.  <br>  issuer                            = string        - (Optional) Issuer URI. When using Azure Active Directory, this value is the URI of the directory tenant, e.g. https://sts.windows.net/{tenant-guid}/.<br>  runtime_version                   = string        - (Optional) The runtime version of the Authentication/Authorization module.<br>  token_refresh_extension_hours     = number        - (Optional) The number of hours after session token expiration that a session token can be used to call the token refresh API. Defaults to 72.<br>  token_store_enabled               = bool          - (Optional) If enabled the module will durably store platform-specific security tokens that are obtained during login flows. Defaults to false.<br>  unauthenticated_client_action     = string        - (Optional) The action to take when an unauthenticated client attempts to access the app. Possible values are `AllowAnonymous` and `RedirectToLoginPage`.<br>}</pre>**NOTE**: If a property above is not needed then it needs to be explicitly set to `null` or `[]` (empty list). | <pre>object({<br>    enabled                        = bool<br>    additional_login_params        = map(string)<br>    allowed_external_redirect_urls = list(string)<br>    default_provider               = string<br>    issuer                         = string<br>    runtime_version                = string<br>    token_refresh_extension_hours  = number<br>    token_store_enabled            = bool<br>    unauthenticated_client_action  = string<br>  })</pre> | `null` | no |
| <a name="input_auth_settings_active_directory"></a> [auth\_settings\_active\_directory](#input\_auth\_settings\_active\_directory) | The schema for active\_directory auth\_settings should look like this:<pre>{<br>  client_id                       = sting         - (Required) The Client ID of this relying party application. Enables OpenIDConnection authentication with Azure Active Directory.<br>  client_secret                   = string        - (Optional) The Client Secret of this relying party application. If no secret is provided, implicit flow will be used.<br>  allowed_audiences               = list(string)  - (Optional) Allowed audience values to consider when validating JWTs issued by Azure Active Directory.<br>}</pre> | <pre>object({<br>    client_id         = string<br>    client_secret     = string<br>    allowed_audiences = list(string)<br>  })</pre> | `null` | no |
| <a name="input_auth_settings_facebook"></a> [auth\_settings\_facebook](#input\_auth\_settings\_facebook) | The schema for facebook auth\_settings should look like this:<pre>{<br>  app_id                          = string        - (Required) The App ID of the Facebook app used for login<br>  app_secret                      = string        - (Required) The App Secret of the Facebook app used for Facebook Login.<br>  oauth_scopes                    = list(string)  - (Optional) The OAuth 2.0 scopes that will be requested as part of Facebook Login authentication.<br>}</pre> | <pre>object({<br>    app_id       = string<br>    app_secret   = string<br>    oauth_scopes = list(string)<br>  })</pre> | `null` | no |
| <a name="input_auth_settings_google"></a> [auth\_settings\_google](#input\_auth\_settings\_google) | The schema for google auth\_settings should look like this:<pre>{<br>  client_id                       = string        - (Required) The OpenID Connect Client ID for the Google web application.<br>  client_secret                   = string        - (Required) The client secret associated with the Google web application.<br>  oauth_scopes                    = list(string)  - (Optional) The OAuth 2.0 scopes that will be requested as part of Google Sign-In authentication.<br>}</pre> | <pre>object({<br>    app_id       = string<br>    app_secret   = string<br>    oauth_scopes = list(string)<br>  })</pre> | `null` | no |
| <a name="input_auth_settings_microsoft"></a> [auth\_settings\_microsoft](#input\_auth\_settings\_microsoft) | The schema for microsoft auth\_settings should look like this:<pre>{<br>  client_id                       = string        - (Required) The OAuth 2.0 client ID that was created for the app used for authentication.<br>  client_secret                   = string        - (Required) The OAuth 2.0 client secret that was created for the app used for authentication.<br>  oauth_scopes                    = list(string)  - (Optional) The OAuth 2.0 scopes that will be requested as part of Microsoft Account authentication. https://msdn.microsoft.com/en-us/library/dn631845.aspx<br>}</pre> | <pre>object({<br>    app_id       = string<br>    app_secret   = string<br>    oauth_scopes = list(string)<br>  })</pre> | `null` | no |
| <a name="input_client_affinity_enabled"></a> [client\_affinity\_enabled](#input\_client\_affinity\_enabled) | Should the Function App send session affinity cookies, which route client requests in the same session to the same instance? | `bool` | `false` | no |
| <a name="input_client_cert_mode"></a> [client\_cert\_mode](#input\_client\_cert\_mode) | The mode of the Function App's client certificates requirement for incoming requests. Possible values are `Required` and `Optional`. | `string` | `null` | no |
| <a name="input_connection_strings"></a> [connection\_strings](#input\_connection\_strings) | One or more blocks of connection string configuration. supprots following.<br>    name  = string  - (Required) The name of the Connection String.<br>    type  = string  - (Required) The type of the Connection String. Possible values are `APIHub`, `Custom`, `DocDb`, `EventHub`, `MySQL`, `NotificationHub`, `PostgreSQL`, `RedisCache`, `ServiceBus`, `SQLAzure` and `SQLServer`.<br>    value = string  - (Required) The value for the Connection String. | <pre>list(object({<br>    name  = string<br>    type  = string<br>    value = string<br>  }))</pre> | `null` | no |
| <a name="input_daily_memory_time_quota"></a> [daily\_memory\_time\_quota](#input\_daily\_memory\_time\_quota) | The amount of memory in gigabyte-seconds that your application is allowed to consume per day. | `number` | `0` | no |
| <a name="input_enable_builtin_logging"></a> [enable\_builtin\_logging](#input\_enable\_builtin\_logging) | Should the built-in logging of this Function App be enabled? | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Is the Function App Enabled? | `bool` | `true` | no |
| <a name="input_function_app_name"></a> [function\_app\_name](#input\_function\_app\_name) | The name of the Function App. | `string` | n/a | yes |
| <a name="input_function_app_version"></a> [function\_app\_version](#input\_function\_app\_version) | The runtime version associated with the Function App. | `string` | `"~1"` | no |
| <a name="input_https_only"></a> [https\_only](#input\_https\_only) | Can the Function App only be accessed via HTTPS? Defaults to false. | `bool` | `false` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | The Principal ID for the Service Principal associated with the Managed Service Identity of this Function App.<br>The schema for identity should look like this:<pre>{<br>  type            = string        - Specifies the identity type of the Function App. Possible values are `SystemAssigned` (where Azure will generate a Service Principal for you), `UserAssigned` where you can specify the Service Principal IDs in the identity_ids field, and SystemAssigned, UserAssigned which assigns both a system managed identity as well as the specified user assigned identities.<br>  identity_ids    = list(string)  - (Optional) Specifies a list of user managed identity ids to be assigned. Required if type is UserAssigned.    <br>}</pre>**NOTE**: If a property above is not needed then it needs to be explicitly set to `null` or `[]` (empty list). | <pre>object({<br>    type         = string<br>    identity_ids = list(string)<br>  })</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the resource exists. | `string` | n/a | yes |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | A string indicating the Operating System type for this function app. This value will be linux for Linux derivatives, or an empty string for Windows (default). When set to linux you must also set azurerm\_app\_service\_plan arguments as kind = "Linux" and reserved = true | `string` | `""` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Function App. | `string` | n/a | yes |
| <a name="input_site_configs"></a> [site\_configs](#input\_site\_configs) | The schema for site\_configs should look like this:<pre>{<br>  always_on                             = bool          - (Optional) Should the app be loaded at all times? Defaults to false.<br>  app_scale_limit                       = number        - (Optional) The number of workers this function app can scale out to. Only applicable to apps on the Consumption and Premium plan.<br>  dotnet_framework_version              = string        - (Optional) The version of the .net framework's CLR used in this Function App. Possible values are `v2.0` (which will use the latest version of the .net framework for the .net CLR v2 - currently .net 3.5), `v4.0` (which corresponds to the latest version of the .net CLR v4 - which at the time of writing is .net 4.7.1), `v5.0` and v6.0.<br>  elastic_instance_minimum              = number        - (Optional) The number of minimum instances for this function app. Only affects apps on the Premium plan.<br>  ftps_state                            = string        - (Optional) State of FTP / FTPS service for this Function App. Possible values include: `AllAllowed`, `FtpsOnly`, `Disabled`.<br>  health_check_path                     = string        - (Optional) The health check path to be pinged by Function App.<br>  http2_enabled                         = bool          - (Optional) Is HTTP2 Enabled on this Function App? Defaults to false.<br>  java_version                          = string        - (Optional) The version of Java to use. If specified java_container and java_container_version must also be specified. Possible values are `1.7`, `1.8`, `11` and their specific versions - except for Java 11<br>  linux_fx_version                      = string        - (Optional) Linux App Framework and version for the Function App. Possible options are a `Docker container` , `a base-64 encoded Docker Compose file`.<br>  min_tls_version                       = string        - (Optional) The minimum supported TLS version for the Function App. Possible values are `1.0`, `1.1`, and `1.2`. Defaults to `1.2` for new Function Apps.<br>  pre_warmed_instance_count             = number        - (Optional) The number of pre-warmed instances for this function app. Only affects apps on the Premium plan.<br>  runtime_scale_monitoring_enabled      = bool          - (Optional) Should Runtime Scale Monitoring be enabled?. Only applicable to apps on the Premium plan. Defaults to false.        <br>  scm_type                              = string        - (Optional) The type of Source Control enabled for this Function App. Defaults to None. Possible values are: `BitbucketGit`, `BitbucketHg`, `CodePlexGit`, `CodePlexHg`, `Dropbox`, `ExternalGit`, `ExternalHg`, `GitHub`, `LocalGit`, `None`, `OneDrive`, `Tfs`, `VSO` and `VSTSRM`<br>  scm_use_main_ip_restriction           = bool          - (Optional) IP security restrictions for scm to use main. Defaults to false.<br>  **NOTE**: Any scm_ip_restriction blocks configured are ignored by the service when scm_use_main_ip_restriction is set to true. Any scm restrictions will become active if this is subsequently set to false or removed.<br>  use_32_bit_worker_process             = bool          - (Optional) Should the Function App run in 32 bit mode, rather than 64 bit mode? Defaults to true.<br><br>  cors = {<br>    allowed_origins                     = list(string)  - (Optional) A list of origins which should be able to make cross-origin calls. * can be used to allow all calls.<br>    support_credentials                 = bool          - (Optional) Are credentials supported? <br>  }<br>}</pre> | <pre>object({<br>    always_on                        = bool<br>    app_scale_limit                  = number<br>    dotnet_framework_version         = string<br>    elastic_instance_minimum         = number<br>    ftps_state                       = string<br>    health_check_path                = string<br>    http2_enabled                    = bool<br>    java_version                     = string<br>    linux_fx_version                 = string<br>    min_tls_version                  = string<br>    pre_warmed_instance_count        = number<br>    runtime_scale_monitoring_enabled = bool<br>    scm_type                         = string<br>    scm_use_main_ip_restriction      = bool<br>    use_32_bit_worker_process        = bool<br><br>    cors = object({<br>      allowed_origins     = list(string)<br>      support_credentials = bool<br>    })<br>  })</pre> | `null` | no |
| <a name="input_site_configs_ip_restriction"></a> [site\_configs\_ip\_restriction](#input\_site\_configs\_ip\_restriction) | A List of objects representing `ip restrictions` as defined below.<pre>[{<br>    name                      = string        - (Optional) The name for this IP Restriction.<br>    ip_address                = string        - (Optional) The IP Address used for this IP Restriction in CIDR notation.<br>    service_tag               = string        - (Optional) The Service Tag used for this IP Restriction.<br>    virtual_network_subnet_id = string        - (Optional) The Virtual Network Subnet ID used for this IP Restriction.<br>    **NOTE**:One of either ip_address, service_tag or virtual_network_subnet_id must be specified<br>    action                    = string        - (Optional) Allow or Deny access for this IP range. Defaults to Allow.<br>    priority                  = number        - (Optional) The priority for this IP Restriction. Restrictions are enforced in priority order. By default, priority is set to 65000 if not specified.     <br>        <br>    headers = {<br>      x_azure_fdid            = list(string)  - (Optional) A list of allowed Azure FrontDoor IDs in UUID notation with a maximum of 8.<br>      x_fd_health_probe       = list(string)  - (Optional) A list to allow the Azure FrontDoor health probe header. Only allowed value is "1".<br>      x_forwarded_for         = list(string)  - (Optional) A list of allowed 'X-Forwarded-For' IPs in CIDR notation with a maximum of 8<br>      x_forwarded_host        = list(string)  - (Optional) A list of allowed 'X-Forwarded-Host' domains with a maximum of 8.<br>    }      <br>  }]<br>**NOTE**: Explicitly set site_configs_ip_restriction to empty list ([]) to remove it.</pre> | <pre>list(object({<br>    name                      = string<br>    ip_address                = string<br>    service_tag               = string<br>    virtual_network_subnet_id = string<br>    action                    = string<br>    priority                  = number<br><br>    headers = object({<br>      x_azure_fdid      = list(string)<br>      x_fd_health_probe = list(string)<br>      x_forwarded_for   = list(string)<br>      x_forwarded_host  = list(string)<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_site_configs_scm_ip_restriction"></a> [site\_configs\_scm\_ip\_restriction](#input\_site\_configs\_scm\_ip\_restriction) | A List of objects representing `scm ip restrictions` as defined below.<pre>[{<br>    name                      = string        - (Optional) The name for this IP Restriction.<br>    ip_address                = string        - (Optional) The IP Address used for this IP Restriction in CIDR notation.<br>    service_tag               = string        - (Optional) The Service Tag used for this IP Restriction.<br>    virtual_network_subnet_id = string        - (Optional) The Virtual Network Subnet ID used for this IP Restriction.<br>    **NOTE**:One of either ip_address, service_tag or virtual_network_subnet_id must be specified<br>    action                    = string        - (Optional) Allow or Deny access for this IP range. Defaults to Allow.<br>    priority                  = number        - (Optional) The priority for this IP Restriction. Restrictions are enforced in priority order. By default, priority is set to 65000 if not specified.     <br>        <br>    headers = {<br>      x_azure_fdid            = list(string)  - (Optional) A list of allowed Azure FrontDoor IDs in UUID notation with a maximum of 8.<br>      x_fd_health_probe       = list(string)  - (Optional) A list to allow the Azure FrontDoor health probe header. Only allowed value is "1".<br>      x_forwarded_for         = list(string)  - (Optional) A list of allowed 'X-Forwarded-For' IPs in CIDR notation with a maximum of 8<br>      x_forwarded_host        = list(string)  - (Optional) A list of allowed 'X-Forwarded-Host' domains with a maximum of 8.<br>    }      <br>  }]<br>**NOTE**: Explicitly set site_configs_scm_ip_restriction to empty list ([]) to remove it.</pre> | <pre>list(object({<br>    name                      = string<br>    ip_address                = string<br>    service_tag               = string<br>    virtual_network_subnet_id = string<br>    action                    = string<br>    priority                  = number<br><br>    headers = object({<br>      x_azure_fdid      = list(string)<br>      x_fd_health_probe = list(string)<br>      x_forwarded_for   = list(string)<br>      x_forwarded_host  = list(string)<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_source_control"></a> [source\_control](#input\_source\_control) | Source Control information. To use this settings, require to set site\_config scm\_type variable <br>Supports the following. <br>repo\_url            = string  - (Required) The URL of the source code repository.<br>branch              = string  - (Optional) The branch of the remote repository to use. Defaults to 'master'.<br>manual\_integration  = bool    - (Optional) Limits to manual integration. Defaults to false if not specified.<br>rollback\_enabled    = bool    - (Optional) Enable roll-back for the repository. Defaults to false if not specified.<br>use\_mercurial       = bool    - (Optional) Use Mercurial if true, otherwise uses Git. | <pre>object({<br>    repo_url           = string<br>    branch             = string<br>    manual_integration = bool<br>    rollback_enabled   = bool<br>    use_mercurial      = bool<br>  })</pre> | `null` | no |
| <a name="input_storage_account_access_key"></a> [storage\_account\_access\_key](#input\_storage\_account\_access\_key) | The access key which will be used to access the backend storage account for the Function App. | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The backend storage account name which will be used by this Function App. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_app_custom_domain_verification_id"></a> [function\_app\_custom\_domain\_verification\_id](#output\_function\_app\_custom\_domain\_verification\_id) | An identifier used by Function App to perform domain ownership verification via DNS TXT record. |
| <a name="output_function_app_default_site_hostname"></a> [function\_app\_default\_site\_hostname](#output\_function\_app\_default\_site\_hostname) | The Default Hostname associated with the Function App - such as mysite.azurewebsites.net |
| <a name="output_function_app_identity"></a> [function\_app\_identity](#output\_function\_app\_identity) | An Managed Service Identity information for this Function App. |
| <a name="output_function_app_name"></a> [function\_app\_name](#output\_function\_app\_name) | The name of the Function App. |
| <a name="output_function_app_outbound_ip_addresses"></a> [function\_app\_outbound\_ip\_addresses](#output\_function\_app\_outbound\_ip\_addresses) | A comma separated list of outbound IP addresses. |
| <a name="output_function_app_possible_outbound_ip_addresses"></a> [function\_app\_possible\_outbound\_ip\_addresses](#output\_function\_app\_possible\_outbound\_ip\_addresses) | A comma separated list of outbound IP addresses |
| <a name="output_function_app_site_credential"></a> [function\_app\_site\_credential](#output\_function\_app\_site\_credential) | The username & password which can be used to publish to this Function App. |
| <a name="output_function_app_source_control"></a> [function\_app\_source\_control](#output\_function\_app\_source\_control) | A Source Control information when scm\_type is set to LocalGit |
| <a name="output_https_only"></a> [https\_only](#output\_https\_only) | The Function HTTP Only. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Function App. |

## Example

```hcl
terraform {
  required_version = "=1.0.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.77.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "mcesub"
  subscription_id = var.subscription_id
  features {}
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "postfix" {
  type    = string
  default = "mce"
}

variable "resource_group_name" {
  type    = string
  default = "mce-function-app-rg"
}

variable "function_app_name" {
  type    = string
  default = "mce-function-app"
}

variable "storage_account_name" {
  type    = string
  default = "mcestorageacc"
}

variable "account_tier" {
  type    = string
  default = "Standard"
}

variable "account_kind" {
  type    = string
  default = "StorageV2"
}

variable "app_service_plan_name" {
  type    = string
  default = "mce-function-app-plan"
}

locals {
  function_app_name          = format("%s-%s", var.resource_group_name, var.postfix)
  resource_group_name        = format("%s-%s", var.resource_group_name, var.postfix)
  app_service_plan_name      = format("%s-%s", var.app_service_plan_name, var.postfix)
  storage_account_name       = lower(format("%s%s", var.storage_account_name, var.postfix))
  location                   = var.location
  app_service_plan_id        = azurerm_app_service_plan.app_service_plan.id
  client_affinity_enabled    = null
  client_cert_mode           = "Optional"
  daily_memory_time_quota    = null
  enabled                    = true
  enable_builtin_logging     = true
  https_only                 = false
  os_type                    = null
  storage_account_access_key = null
  function_app_version       = null

  app_settings = {
    "function_app_title" = "my_first_app"
  }

  auth_settings = {
    enabled                        = false
    additional_login_params        = null
    allowed_external_redirect_urls = []
    default_provider               = null
    issuer                         = null
    runtime_version                = null
    token_refresh_extension_hours  = null
    token_store_enabled            = false
    unauthenticated_client_action  = null
  }

  auth_settings_active_directory = null /* {
      client_id = null
      client_secret = null
      allowed_audiences = []
    } */

  auth_settings_facebook = null /* {
      app_id = null
      app_secret = null
      oauth_scopes = []
    } */

  auth_settings_google = null /* {
      client_id     = ""
      client_secret = ""
      oauth_scopes  = []
    } */

  auth_settings_microsoft = null /* {
      client_id = null
      client_secret = null 
      oauth_scopes = []
    } */

  connection_strings = [{
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }]

  identity = {
    type         = "SystemAssigned"
    identity_ids = null
  }

  site_configs = {
    always_on                        = null
    app_scale_limit                  = null
    dotnet_framework_version         = null
    elastic_instance_minimum         = null
    ftps_state                       = null
    health_check_path                = null
    http2_enabled                    = null
    java_version                     = null
    linux_fx_version                 = null
    min_tls_version                  = null
    pre_warmed_instance_count        = null
    runtime_scale_monitoring_enabled = null
    scm_type                         = null
    scm_use_main_ip_restriction      = null
    use_32_bit_worker_process        = null

    cors = {
      allowed_origins     = ["mypage.html"]
      support_credentials = false
    }
  }

  site_configs_ip_restriction = [/* {
        name                      = null
        ip_address                = null
        service_tag               = null
        virtual_network_subnet_id = null
        action                    = null
        headers = {
          x_azure_fdid      = []
          x_fd_health_probe = []
          x_forwarded_for   = []
          x_forwarded_host  = []
        }
        priority = null    
      } */]

  site_configs_scm_ip_restriction = [/* {
        name                      = null
        ip_address                = null
        service_tag               = null
        virtual_network_subnet_id = null
        action                    = null
        headers = {
          x_azure_fdid      = []
          x_fd_health_probe = []
          x_forwarded_for   = []
          x_forwarded_host  = []
        }
        priority = null    
      } */]

  source_control = null /* {
    repo_url           = "https://vaibhavmalushte@dev.azure.com/vaibhavmalushte/myFirstAzureProject/_git/php_hello_world"
    branch             = "main"
    manual_integration = false
    rollback_enabled   = false
    use_mercurial      = false
  } */

  tags = {
    Environment = "mce"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = local.app_service_plan_name
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Medium"
    size = "P2V3"
  }
}

module "storage" {
  source               = "git::https://ava-opscentre.visualstudio.com/Central%20Terraform%20Repo/_git/tf-mce-azurerm-storage-account?ref=v1.0.0"
  storage_account_name = local.storage_account_name
  resource_group_name  = azurerm_resource_group.rg.name
  location             = local.location
  tags                 = local.tags
  account_tier         = var.account_tier
  account_kind         = var.account_kind
}

module "function_app" {
  source = "../"

  function_app_name   = local.function_app_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  app_service_plan_id = local.app_service_plan_id

  app_settings                   = local.app_settings
  auth_settings                  = local.auth_settings
  auth_settings_active_directory = local.auth_settings_active_directory
  auth_settings_facebook         = local.auth_settings_facebook
  auth_settings_google           = local.auth_settings_google
  auth_settings_microsoft        = local.auth_settings_microsoft

  connection_strings              = local.connection_strings
  client_affinity_enabled         = local.client_affinity_enabled
  client_cert_mode                = local.client_cert_mode
  daily_memory_time_quota         = local.daily_memory_time_quota
  enabled                         = local.enabled
  enable_builtin_logging          = local.enable_builtin_logging
  https_only                      = local.https_only
  identity                        = local.identity
  os_type                         = local.os_type
  site_configs                    = local.site_configs
  site_configs_ip_restriction     = local.site_configs_ip_restriction
  site_configs_scm_ip_restriction = local.site_configs_scm_ip_restriction
  source_control                  = local.source_control
  storage_account_name            = module.storage.storage_account_name
  storage_account_access_key      = module.storage.storage_primary_access_key
  function_app_version            = local.function_app_version
  tags                            = local.tags
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "function_app_url" {
  value       = module.function_app.function_app_default_site_hostname
  description = "The Default Hostname associated with the Function App"
}

output "function_app_name" {
  value       = module.function_app.function_app_name
  description = "The Function App name."
}

output "https_only" {
  value       = module.function_app.https_only
  description = "The Function App name."
}
```
