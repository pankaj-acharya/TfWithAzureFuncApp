variable "storage_account_name" {
  type        = string
  description = "The name of the Azure Storage Account. Name must be globally unique."

  validation {
    condition     = (length(var.storage_account_name) > 2 && length(var.storage_account_name) < 25 && can(regex("^[a-z0-9]+$", var.storage_account_name)))
    error_message = "The storage_account_name can only contain lower case alphanumeric values and be between 3-24 characters in length."
  }
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which the Storage Account is created."
}

variable "location" {
  type        = string
  description = "The location/region where the resource will be created."
}

variable "account_kind" {
  type        = string
  default     = "StorageV2"
  description = "The kind of Storage Acccount. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2."
}

variable "account_tier" {
  type        = string
  default     = "Standard"
  description = "Defined the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlockStorage and FileStorage accounts only Premium is valid."
}

variable "account_replication_type" {
  type        = string
  default     = "LRS"
  description = "Defines the type of replication to use for this Storage Account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS."
}

variable "access_tier" {
  type        = string
  default     = "Hot"
  description = "Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
}

variable "enable_https_traffic_only" {
  type        = bool
  default     = true
  description = "Boolean flag which forces HTTPS if enabled. Defaults to true."
}

variable "hns_enabled" {
  type        = bool
  default     = false
  description = "Do you need Hierarchical NameSpace enabled. This is for DataLake Gen2 deployments."
}

variable "min_tls_version" {
  type        = string
  default     = "TLS1_2"
  description = "The minimum supported TLS version for the Storage Account. Possible values are TLS1_0, TLS1_1, and TLS1_2."
}

variable "infrastructure_encryption_enabled" {
  type        = bool
  default     = false
  description = "Is infrastructure encryption enabled? Changing this forces a new resource to be created. Defaults to false. This can only be true when account_kind is StorageV2."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
}