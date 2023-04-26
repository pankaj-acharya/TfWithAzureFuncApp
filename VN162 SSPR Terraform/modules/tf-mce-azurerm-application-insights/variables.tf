variable "name" {
  type        = string
  description = "Specifies the name of the Application Insights component."
}

variable "location" {
  type        = string
  description = "The location/region where the resources will be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group where the resources will be created."
}

variable "application_type" {
  type        = string
  description = "Specifies the type of Application Insights Instance to create. Valid values are `ios for iOS`, `java for Java web`, `MobileCenter for App Center`, `Node.JS for Node`, `other for General`, `phone for Windows Phone`, `store for Windows Store` and `web for ASP.NET`. These values are case sensitive; unmatched values are treated as ASP.NET by Azure."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
}

variable "daily_data_cap_in_gb" {
  type        = number
  description = "Specifies the Application Insights component daily data volume cap in GB."
  default     = null
}

variable "daily_data_cap_notifications_disabled" {
  type        = bool
  description = "Specifies if a notification email will be send when the daily data volume cap is met."
  default     = null
}

variable "retention_in_days" {
  type        = number
  description = "Specifies the retention period in days. Possible values are `30`, `60`, `90`, `120`, `180`, `270`, `365`, `550` or `730`."
  default     = 90
}

variable "sampling_percentage" {
  type        = number
  description = "Specifies the percentage of the data produced by the monitored application that is sampled for Application Insights telemetry."
  default     = null
}

variable "disable_ip_masking" {
  type        = bool
  description = "By default the real client ip is masked as `0.0.0.0` in the logs. Use this argument to disable masking and log the real client ip."
  default     = false
}

variable "workspace_id" {
  type        = string
  description = "Specifies the id of a log analytics workspace resource. This is required to create an Application Insights instance in Workspace mode."
  default     = null
}

variable "local_authentication_disabled" {
  type        = bool
  description = "Disable Non-Azure AD based Auth."
  default     = false
}

variable "internet_ingestion_enabled" {
  type        = bool
  description = "Should the Application Insights component support ingestion over the Public Internet?"
  default     = true
}

variable "internet_query_enabled" {
  type        = bool
  description = "Should the Application Insights component support querying over the Public Internet?"
  default     = true
}