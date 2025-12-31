variable "azure_local_logical_networks" {
  description = "Map of Azure Local logical networks"
  type = map(object({
    address_prefix       = optional(string)
    default_gateway      = optional(string)
    dns_servers          = optional(list(string))
    starting_address     = optional(string)
    ending_address       = optional(string)
    enable_telemetry     = optional(bool)
    ip_allocation_method = string
    vlan_id              = optional(string)
    logical_network_tags = optional(map(string))
  }))
  default = {}
}

variable "azure_local_cluster_name" {
  type    = string
  default = ""
}

variable "azure_local_logical_network_name_prefix" {
  type    = string
  default = ""
}

variable "azure_local_resource_group_name" {
  type    = string
  default = ""
}

variable "azure_local_vm_switch_name" {
  type    = string
  default = ""
}

variable "azure_local_extended_location_custom_location_name" {
  type    = string
  default = ""
}

variable "subscription_id" {
  type      = string
  default   = ""
  sensitive = true
}

variable "tenant_id" {
  type      = string
  default   = ""
  sensitive = true
}