# Her definerer vi alle variabler, og dens type 

variable "name" {
  description = "Navn på vm, en frontend og en database"
  type        = string
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "image_name" {
  type = string
}

variable "flavor_name" {
  type = string
}

variable "key_pair" {
  type = string
}

variable "network_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "user_data" {
  description = "Rendered cloud-init content."
  type        = string
  default     = ""
}

variable "assign_floating_ip" {
  type    = bool
  default = false
}

variable "floating_ip_pool" {
  type    = string
  default = null
}

variable "volume_ids" {
  description = "Volumes to attach: volume_ids[i] is attached to instance i (max one per instance)."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.volume_ids) <= var.instance_count
    error_message = "volume_ids cannot contain more entries than instance_count."
  }
}
