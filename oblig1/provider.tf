terraform {
  required_version = ">= 1.12.0"

  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3"
    }
  }

  backend "swift" {
      container         = "terranova-tfstate"
      archive_container = "terranova-tfstate-archive"
      key               = "poc/terraform.tfstate"
    }
}



# Configure the OpenStack Provider
provider "openstack" {
}
