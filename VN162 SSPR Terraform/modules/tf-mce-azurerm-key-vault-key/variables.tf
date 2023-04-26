variable "key_name" {
  type        = string
  description = "The name of the Key Vault Key."
}

variable "key_vault_id" {
  type        = string
  description = "The ID of the Key Vault where this key should be created."
}

variable "key_type" {
  type        = string
  description = "Specifies the Key Type to use for this Key Vault Key. Possible values are `EC` (Elliptic Curve), `EC-HSM`, `Oct` (Octet), `RSA` and `RSA-HSM`."
}

variable "key_operations" {
  type = list(string)

  description = <<-EOT
  A list of JSON web key operations. Possible values include: `decrypt`, `encrypt`, `sign`, `unwrapKey`, `verify` and `wrapKey`.

  **Note**: Please note these values are case sensitive.
  EOT
}

variable "key_size" {
  type = number

  description = <<-EOT
  Specifies the Size of the RSA key to create in bytes. For example, `1024` or `2048`.

  **Note**: This field is required if key_type is `RSA` or `RSA-HSM`. Changing this forces a new resource to be created.
  EOT

  default = null
}

variable "not_before_date" {
  type        = string
  description = "Key not usable before the provided UTC datetime (Y-m-d'T'H:M:S'Z')."
  default     = null
}

variable "expiration_date" {
  type        = string
  description = "Expiration UTC datetime (Y-m-d'T'H:M:S'Z')."
  default     = null
}

variable "key_curve" {
  type = string

  description = <<-EOT
  Specifies the curve to use when creating an EC key. Possible values are `P-256`, `P-256K`, `P-384`, and `P-521`. 
  
  This field will be required in a future release if key_type is `EC` or `EC-HSM`. The API will default to `P-256` if nothing is specified. 
  EOT

  default = null
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
}