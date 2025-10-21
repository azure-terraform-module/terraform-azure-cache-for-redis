variable "subscription_id" {}

variable "resource_group_name" {}

variable "location" {}

variable "name" { description = "Redis name prefix" }

variable "network_mode" {
  description = "public or private"
  type        = string
  default     = "public"
}

variable "subnet_id" {
  description = "Optional subnet for private endpoint"
  type        = string
  default     = null
}

variable "vnet_id" {
  description = "Optional vnet for private DNS zone link"
  type        = string
  default     = null
}

variable "sku_name" { default = "Standard" }

variable "capacity" { default = 1 }

variable "redis_version" { default = "6.0" }

variable "enable_authentication" { default = true }

variable "access_keys_authentication_enabled" { default = true }

variable "enable_non_ssl_port" { default = false }

variable "zones" {
  description = "Optional availability zones (Premium only)"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}


