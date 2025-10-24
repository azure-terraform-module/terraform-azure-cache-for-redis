# Optional Private DNS (only if network_mode = "private")
resource "azurerm_private_dns_zone" "redis" {
  count               = var.network_mode == "private" ? 1 : 0
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "redis" {
  count                 = var.network_mode == "private" ? 1 : 0
  name                  = "${var.name}-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.redis[0].name
  virtual_network_id    = var.vnet_id
  tags                  = var.tags
}

# Redis Module
module "redis" {
  source  = "Azure/avm-res-cache-redis/azurerm"
  version = "0.4.0"

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  # SKU / version
  sku_name      = var.sku_name
  capacity      = var.capacity
  redis_version = var.redis_version

  # Security
  access_keys_authentication_enabled = var.access_keys_authentication_enabled
  enable_non_ssl_port                = var.enable_non_ssl_port
  public_network_access_enabled      = var.network_mode == "public"

  # Managed Identity
  managed_identities = { system_assigned = true }

  # Private endpoint (only if private)
  private_endpoints = var.network_mode == "private" ? {
    redis = {
      subnet_resource_id              = var.subnet_id 
      private_dns_zone_resource_ids   = [azurerm_private_dns_zone.redis[0].id]
      private_dns_zone_group_name     = "redis-private-dns-zone-group"
      private_service_connection_name = "redis-private-link"
      name                            = "${var.name}-pe"
      location                        = var.location
      resource_group_name             = var.resource_group_name
      tags                            = var.tags
    }
  } : {}

  # Redis Configuration
  redis_configuration = {
    enable_authentication = var.enable_authentication
  }

  # Zones (nullable)
  zones = var.zones

  tags = var.tags
}
