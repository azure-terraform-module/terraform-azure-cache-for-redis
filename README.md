# terraform-azurerm-cache-for-redis

Terraform module to provision Azure Cache for Redis (azurerm_redis_cache) with optional Private Endpoint and Private DNS zone for secure connectivity.

## Features 
- Create Azure Cache for Redis (default version: 6.0)
- Supports both Public and Private network modes
- Private Endpoint + DNS zone privatelink.redis.cache.windows.net when network_mode = "private"
- Optional Availability Zones for Premium SKU

| name                                 | description                                                                               | default      | options                                  |
| ------------------------------------ | ----------------------------------------------------------------------------------------- | ------------ | ---------------------------------------- |
| `subscription_id`                    | Azure subscription ID.                                                                    | —            | string                                   |
| `resource_group_name`                | Target resource group.                                                                    | —            | string                                   |
| `location`                           | Azure region.                                                                             | —            | string (e.g., `eastus`, `westus2`)       |
| `name`                               | Redis cache name prefix.                                                                  | —            | string                                   |
| `network_mode`                       | Connectivity mode. `"private"` disables public access and creates Private Endpoint + DNS. | `"public"`   | `public`, `private`                      |
| `subnet_id`                          | Subnet for Private Endpoint. Required when `network_mode = "private"`.                    | `null`       | Azure subnet resource ID                 |
| `vnet_id`                            | Virtual network for DNS zone linking.                                                     | `null`       | Azure virtual network ID                 |
| `sku_name`                           | Redis SKU tier.                                                                           | `"Standard"` | `Basic`, `Standard`, `Premium`           |
| `capacity`                           | Size within the SKU tier.                                                                 | `1`          | integer (depends on SKU)                 |
| `redis_version`                      | Redis engine version.                                                                     | `"6.0"`      | `"4.0"`, `"6.0"`, `"7.0"` (per provider) |
| `enable_authentication`              | Enable authentication for Redis.                                                          | `true`       | `true`, `false`                          |
| `access_keys_authentication_enabled` | Enable access-key authentication.                                                         | `true`       | `true`, `false`                          |
| `enable_non_ssl_port`                | Allow non-SSL access.                                                                     | `false`      | `true`, `false`                          |
| `zones`                              | Availability Zones (Premium only).                                                        | `null`       | list(string)                             |
| `tags`                               | Resource tags.                                                                            | `{}`         | map(string)                              |


## Examples

### Private network mode

```hcl 
data "terraform_remote_state" "vnet" {
  backend = "azurerm"
  config = {
    subscription_id      = "xxx"
    resource_group_name  = "xxx"
    storage_account_name = "xxx"
    container_name       = "xxx"
    key                  = "xxx"
  }
}

module "redis_cache" {
  source = ""

  subscription_id      = "xxx"
  resource_group_name  = "xxx"
  location             = "xxx"

  name                 = "xxx-dev-redis"
  network_mode         = "private"
  sku_name             = "Standard"
  capacity             = 1
  redis_version        = "6.0"
  zones                = null

  subnet_id = data.terraform_remote_state.vnet.outputs.subnet_ids[0]
  vnet_id   = data.terraform_remote_state.vnet.outputs.vnet_id

  enable_authentication              = true
  access_keys_authentication_enabled = true
  enable_non_ssl_port                = false

  tags = {
    service    = "redis"
  }
}
``` 

### Public network mode

```hcl
module "redis_cache" {
  source = "./modules/terraform-azure-cache-for-redis"

  subscription_id      = "xxx"
  resource_group_name  = "xxx"
  location             = "xxx"

  name                 = "xxx-redis-public"
  network_mode         = "public"
  sku_name             = "Basic"
  capacity             = 1
  redis_version        = "6.0"
  zones                = null

  enable_authentication              = true
  access_keys_authentication_enabled = true
  enable_non_ssl_port                = false

  tags = {
    service = "redis"
  }
}
``` 

