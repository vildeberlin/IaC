// Nettverk 

variable "network_name" {
  description = "Navn på nettverket"
  type        = string
  default     = "oblig1-nettverk"
}

variable "router_name" {
  description = "Navn på routeren"
  type        = string
  default     = "oblig1-router"
}

variable "subnet_cidr" {
    description = "IP-område per lag i 3-lagsarkitekturen"
    type        = map(string)

    default     = {
        frontend = "10.0.1.0/24"
        backend  = "10.0.2.0/24"
        database = "10.0.3.0/24"
    }
}

variable "external_network_name" {
    description = "Navn på det eksterne nettverket i SkyHiGh"
    type        = string
    default     = "ntnu-internal"
}


// VM 

variable "ssh_key_name" {
  description = "Navn på SSH-nøkkel som skal brukes for å logge inn på VM"
  type        = string
}

  variable "image_name" {
    description = "Image som brukes på VM-ene"
    type        = string
    default     = "Debian 13 (Trixie) stable amd64"
  }

variable "frontend_vm_name" {
    description = "Navn på frontend-VM-en"
    type        = string
    default     = "frontend"
}

  variable "frontend_flavor" {
    description = "Flavor (størrelse) på frontend-VM-en"
    type        = string
    default     = "gx1.1c1r"
  }


variable "frontend_template" {
    description = "Cloud-init-mal for frontend (relativ til rotmodulen)"
    type        = string
    default     = "templates/frontend-init.yaml"
}

variable "db_vm_name" {
    description = "Navn på database-VM-en"
    type        = string
    default     = "db"
}

variable "db_flavor" {
    description = "Flavor (størrelse) på database-VM-en"
    type        = string
    default     = "gx1.1c1r"
}   


variable "db_template" {
    description = "Cloud-init-mal for database (relativ til rotmodulen)"
    type        = string
    default     = "templates/db-init.yaml"
}


// sikkerhetsgrupper


variable "frontend_secgroup_name" {
    description = "Navn på sikkerhetsgruppen til frontend"
    type        = string
    default     = "frontend-secgroup"
}

variable "db_secgroup_name" {
    description = "Navn på sikkerhetsgruppen til database"
    type        = string
    default     = "db-secgroup"
}

variable "ssh_allowed_cidr" {
    description = "Hvilke IP-er som får SSH-tilgang til VM-ene"
    type        = string
    default     = "0.0.0.0/0"
}

variable "frontend_public_ports" {
    description = "Porter som åpnes mot frontend fra hele verden (HTTP/HTTPS)"
    type        = list(number)
    default     = [80, 443]
}

variable "db_port" {
    description = "Porten databasen lytter på (5432 = PostgreSQL, 3306 = MySQL)"
    type        = number
    default     = 5432
}

// lastbalanserer 

variable "enable_load_balancer" {
    description = "Slå lastbalanserer av/på"
    type        = bool
    default     = true
}

variable "lb_name" {
    description = "Navn på lastbalansereren"
    type        = string
    default     = "terranova-lb"
}

variable "lb_protocol" {
    description = "Protokoll som skal balanseres (HTTP, HTTPS, TCP)"
    type        = string
    default     = "HTTP"
}

variable "lb_port" {
    description = "Porten tjenesten lytter på"
    type        = number
    default     = 80
}

// Persistent storage

variable "attach_volume" {
    description = "Koble et persistent volum til database-VM-en"
    type        = bool
    default     = true
}

variable "volume_name" {
    description = "Navn på det persistente volumet"
    type        = string
    default     = "db-volume"
}

variable "volume_size_gb" {
    description = "Størrelse på volumet i GB"
    type        = number
    default     = 20
}


// Storage container    

variable "storage_container_name" {
    description = "Navn på storage containeren"
    type        = string
    default     = "terranova-container"
}   


// Load balancer 
 variable "lb_health_check_path" {
    description = "Stien lastbalansereren bruker til helsesjekk"
    type        = string
    default     = "/"
}