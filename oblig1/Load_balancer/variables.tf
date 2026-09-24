variable "lb_name" {
  type = string
}

variable "protocol" {
  type = string
  default = "HTTP"
}

variable "protocol_port" {
  type = number
  default = 80
}

variable "flag" {
  type = bool
  default = true
}

variable "member_address" {
  description = "IP-adressen til VM-en (f.eks. frontend) som skal balanseres"
  type        = string
}

variable "member_subnet_id" {
  description = "Subnett-ID medlemmet (VM-en) ligger i"
  type        = string
}

variable "external_network_name" {
  description = "Navn på det eksterne nettverket floating IP hentes fra"
  type        = string
  default     = "ntnu-internal"
}