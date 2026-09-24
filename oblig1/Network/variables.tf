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

# Dette er de subnettsene vi skal ha, en for frontend, en for backend og en for database
variable "subnets" {
  description = "Liste over subnett"
  type        = map(string)

  default = {
    frontend = "10.0.1.0/24"
    backend  = "10.0.2.0/24"
    database = "10.0.3.0/24"
  }
}