
variable "template" {
  description = "Input template for cloud-init"
  type        = string
  default     = ""
}

variable "name" {
  description = "Name of the instance"
  type        = string
}

variable "ssh_key_name" {
  description = "Public key accessible in SkyHiGh to bootstrap VM with"
  type        = string
}

variable "ntnu_internal_network" {
  description = "Name of the external network in SkyHiGh"
  type        = string
  default     = "ntnu-internal"
}

variable "network" {
  description = "Network to attach the VM to"
  type        = string
}

variable "distro" {
  description = "Image name to use for the VM"
  type        = string
  default     = "Debian 13 (Trixie) stable amd64"
}

variable "flavor" {
  description = "Size and feature set of the VM"
  type        = string
  default     = "gx1.1c1r"
}

variable "security_rules" {
  type = map(object({
    port     = number
    protocol = string
    cidr     = string
  }))

  default = {
    ssh = {
      port     = 22
      protocol = "tcp"
      cidr     = "0.0.0.0/0"
    }
    http = {
      port     = 80
      protocol = "tcp"
      cidr     = "0.0.0.0/0"
    }
  }
}