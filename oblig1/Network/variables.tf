variable "network_name" {
  description = "Name of backend network"
}

variable "network_subnet_name" {
  description = "Name of backend subnet"
}

variable "network_subnet_cidr" {
  description = "CIDR for backend network"

}

variable "network_router_name" {
  description = "Name for backend router"

}

variable "ntnu_internal_network" {
  description = "Name of the external network in SkyHiGh"
  default     = "ntnu-internal"
}