terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0.0"
    }
  }
}

provider "openstack" {}

//keypair
/*Men: ikke skriv file("~/.ssh/id_ed25519.pub") 
direkte i koden — det er en filsti som bare funker 
på din maskin. Gjør den om til en variabel i stedet, 
så andre (eller en CI/CD-robot) kan sende inn sin egen nøkkel.
*/
resource "openstack_compute_keypair_v2" "kp" {
  name = "id_ed25519"
  public_key = var.ssh_public_key //file("~/.ssh/id_ed25519.pub")  
}


variable "vm-flavor" {
  type = string
}

variable "vm-image" {
  type = string
}



//instance/vm
resource "openstack_compute_instance_v2" "DB" {
  name            = "DB"
  image_id        = var.vm-image
  flavor_name     = var.vm-flavor
  key_pair        = resource.openstack_compute_keypair_v2.kp.name
  security_groups = [openstack_networking_secgroup_v2.secgroup.name]

  network {
        uuid = openstack_networking_network_v2.network_1.id //reference the network by ID
  }
}

resource "openstack_compute_instance_v2" "frontend" {
  name            = "frontend"
  image_id        = var.vm-image
  flavor_name     = var.vm-flavor
  key_pair        = resource.openstack_compute_keypair_v2.kp.name
  security_groups = [openstack_networking_secgroup_v2.secgroup.name]

  network {
        uuid = openstack_networking_network_v2.network_1.id //reference the network by ID
  }
}


resource "openstack_networking_secgroup_v2" "secgroup" {
  name        = "my_security_group"
  description = "Security group for my instance"
}

variable "vm-flavor" {
  default = "gx1.1c1r"
}



variable "vm-image" {
  default = "cf5dc427-0a2d-41ea-a9e8-d3e62e8477d0" //"Ubuntu Server 24.04 LTS (Noble Numbat) amd64"
}