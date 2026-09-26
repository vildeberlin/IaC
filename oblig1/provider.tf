 terraform {
    required_version = ">= 1.12.0"

    required_providers {
      openstack = {
        source  = "terraform-provider-openstack/openstack"
        version = "~> 3"
      }
    }
 }
 
 
backend "s3" {
      bucket = "terranova-tfstate"
      region = "us-east-1" # dummyverdi, kreves av backenden

      endpoints = { s3 = "https://swift.skyhigh.iik.ntnu.no" }

      skip_credentials_validation = true
      skip_region_validation      = true
      skip_requesting_account_id  = true
      skip_metadata_api_check     = true
      skip_s3_checksum            = true
      use_path_style              = true
}




# Configure the OpenStack Provider
provider "openstack" {
}
