variable "storage_container_name" {
  description = "The name of the storage container"
  type        = string
}

variable "storage_container_content_type" {
  description = "The access type of the storage container"
  type        = string
  default     = "application/octet-stream"
}

variable "storage_container_versioning" {
  description = "Enable versioning for the storage container"
  type        = bool
  default     = false
}