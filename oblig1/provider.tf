terraform {
  required_version = ">= 1.12.0"

  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3"
    }
  }

  backend "swift" {
    container = "kops"
    archive_container = "kops"
    key = "terraform.tfstate"

    /*
    secret_suffix = "oblig1"
    namespace     = "iac"
    config_path   = "./kube_config.yaml"
    */

  }
}



# Configure the OpenStack Provider
provider "openstack" {
}
