# Credentials come from clouds.yaml (var.os_cloud) or from OS_* environment variables (os_cloud = null).
provider "openstack" {
  cloud = var.os_cloud
}
