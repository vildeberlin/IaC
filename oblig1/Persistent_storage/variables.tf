variable "name" {
  description = "Navnet på min persistant storage"
}

variable "size_gb" {
  description = "Størrelsen på persistant storage"
  type = number
  default = 20
}

variable "attach_storage_to_vm" {
 type = bool 
 default = true
}

variable "instance_id" {
  type = string
}