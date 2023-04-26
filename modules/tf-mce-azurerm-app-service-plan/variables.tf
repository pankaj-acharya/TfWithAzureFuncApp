variable "app_service_plan_name" {
  type        = string
  description = "Specifies the name of the App Service Plan component."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the App Service Plan component."
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists."
}

variable "kind" {
  type        = string
  
  description = <<EOF
    The kind of the App Service Plan to create. Possible values are `Windows`,`Linux`,`elastic`,`FunctionApp`. Defaults to Windows.
    **NOTE**: When creating a Linux App Service Plan, the reserved field must be set to true, and when creating a Windows/app App Service Plan the reserved field must be set to false.
  EOF

  default = null
}

variable "maximum_elastic_worker_count" {
  type        = string
  description = "The maximum number of total workers allowed for this ElasticScaleEnabled App Service Plan."
}

variable "sku" {
  
  type = object({
    tier     = string
    size     = string
    capacity = number
  })

  description = <<-EOT
  A sku block as documented below.
  ```
    {
      tier = string - (Required) Specifies the plan's pricing tier. Accepted values are `B1`,`B2`,`B3`,`D1`,`F1`,`FREE`,`I1`,`I1v2`,`I2`,`I2v2`,`I3`,`I3v2`,`P1V2`,`P1V3`,`P2V2`,`P2V3`,`P3V2`,`P3V3`,`PC2`,`PC3`,`PC4`,`S1`,`S2`,`S3`,`SHARED`
      size = string - (Required) Specifies the plan's instance size. Accepted values are `Small`,`Medium` & `Large`
      capacity = number - (Optional) Specifies the number of workers associated with this App Service Plan.
    }
  ```  
  **NOTE**: If a property above is not needed then it needs to be explicitly set to `null` or `[]` (empty list).
  EOT

  validation {
    condition     = (var.sku == null) ? false : (var.sku.tier == null && var.sku.size == null) ? false : true
    error_message = "SKU is required. And Tier & Size cannot be null."
  }
}

variable "app_service_environment_id" {
  type = string

  description = <<-EOT
  The ID of the App Service Environment where the App Service Plan should be located.
  **NOTE**: Attaching to an App Service Environment requires the App Service Plan use a Premium SKU (when using an ASEv1) and the Isolated SKU (for an ASEv2).
  EOT

  default = null
}

variable "reserved" {
  type        = bool
  description = "Is this App Service Plan Reserved."
  default     = false
}

variable "per_site_scaling" {
  type = bool

  description = <<-EOT
  Can Apps assigned to this App Service Plan be scaled independently?
  **NOTE**:If set to false apps assigned to this plan will scale to all instances of the plan. 
  EOT

  default = false
}

variable "zone_redundant" {
  type        = bool
  description = "Specifies if the App Service Plan should be Zone Redundant."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
}