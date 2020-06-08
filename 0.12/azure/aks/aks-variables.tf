variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "node_pool_name" {
  type = string
}

variable "node_pool_count" {
  type = number
}

variable "node_pool_vm_size" {
  type = string
}

variable "tags" {
  type = string
}

#variable "remote_AD_subnet_id" {
#  type = string
#}

#variable "private_dns_name" {
#  type = string
#}

#variable "subscription_id" {
#  type = string
#}

#variable "client_id" {
#  type = string
#}

#variable "tenant_id" {
#  type = string
#}

#variable "client_secret" {
#  type = string
#}

#variable "AD_Vnet_name" {
#  type = string
#}

#variable "AD_resource_group_name" {
#  type = string
#}

#variable "aksVnet_address_space" {
#  type = list
#}

#variable "aksVnet_dns_servers" {
#  type = list
#}

#variable "aksSubnet_address_prefix" {
#  type = string
#}