locals {
  admin_username                 = "admin_user"
  admin_password_length          = 20
  example_vm_logical_network_key = "1"

  marketplace_gallery_image_name                 = "2025-datacenter-azure-edition"
  marketplace_gallery_image_hyperv_generation    = "V2"
  marketplace_gallery_image_os_type              = "Windows"
  marketplace_gallery_image_version              = "26100.7092.251105"
  marketplace_gallery_image_identifier_publisher = "MicrosoftWindowsServer"
  marketplace_gallery_image_identifier_offer     = "WindowsServer"
  marketplace_gallery_image_identifier_sku       = "2025-datacenter-azure-edition"
}

data "azurerm_extended_location_custom_location" "azure-local-custom-location" {
  name                = var.azure_local_extended_location_custom_location_name
  resource_group_name = var.azure_local_resource_group_name
}

data "azurerm_resource_group" "azure-local-resource-group" {
  name = var.azure_local_resource_group_name
}

data "azurerm_stack_hci_cluster" "azure-local-cluster" {
  name                = var.azure_local_cluster_name
  resource_group_name = var.azure_local_resource_group_name
}

resource "random_string" "azure-local-virtualmachineinstance-admin-password" {
  length           = local.admin_password_length
  special          = true
  override_special = "!$"
}

module "azure-local-logicalnetworks" {
  source  = "Azure/avm-res-azurestackhci-logicalnetwork/azurerm"
  version = "2.0.0"

  for_each = var.azure_local_logical_networks

  name             = "${var.azure_local_logical_network_name_prefix}-${each.key}"
  address_prefix   = each.value.address_prefix
  default_gateway  = each.value.default_gateway
  dns_servers      = each.value.dns_servers
  starting_address = each.value.starting_address
  ending_address   = each.value.ending_address

  enable_telemetry     = each.value.enable_telemetry
  ip_allocation_method = each.value.ip_allocation_method
  vlan_id              = each.value.vlan_id
  logical_network_tags = each.value.logical_network_tags

  custom_location_id = data.azurerm_extended_location_custom_location.azure-local-custom-location.id
  location           = data.azurerm_stack_hci_cluster.azure-local-cluster.location
  resource_group_id  = data.azurerm_resource_group.azure-local-resource-group.id
  vm_switch_name     = var.azure_local_vm_switch_name
}

resource "azurerm_stack_hci_marketplace_gallery_image" "windows-server-2025" {
  name                = local.marketplace_gallery_image_name
  resource_group_name = data.azurerm_resource_group.azure-local-resource-group.name
  location            = data.azurerm_resource_group.azure-local-resource-group.location
  custom_location_id  = data.azurerm_extended_location_custom_location.azure-local-custom-location.id
  hyperv_generation   = local.marketplace_gallery_image_hyperv_generation
  os_type             = local.marketplace_gallery_image_os_type
  version             = local.marketplace_gallery_image_version
  identifier {
    publisher = local.marketplace_gallery_image_identifier_publisher
    offer     = local.marketplace_gallery_image_identifier_offer
    sku       = local.marketplace_gallery_image_identifier_sku
  }

  lifecycle {
    ignore_changes = [storage_path_id]
  }
}

module "azure-local-virtualmachineinstance" {
  source  = "Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm"
  version = "2.1.1"

  name               = "win2025"
  admin_username     = local.admin_username
  admin_password     = random_string.azure-local-virtualmachineinstance-admin-password.result
  image_id           = azurerm_stack_hci_marketplace_gallery_image.windows-server-2025.id
  logical_network_id = module.azure-local-logicalnetworks[local.example_vm_logical_network_key].resource_id

  memory_mb   = "8192"
  v_cpu_count = "2"
  os_type     = "Windows"

  enable_tpm          = true
  secure_boot_enabled = true
  security_type       = "TrustedLaunch"

  custom_location_id  = data.azurerm_extended_location_custom_location.azure-local-custom-location.id
  location            = data.azurerm_stack_hci_cluster.azure-local-cluster.location
  resource_group_name = var.azure_local_resource_group_name
}