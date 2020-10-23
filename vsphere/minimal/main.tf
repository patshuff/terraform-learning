
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "Home-lab"
}

data "vsphere_host" "devTest" {
  name          = "10.0.0.92"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_resource_pool" "devTest" {
  name = "Resources"
  parent_resource_pool_id = data.vsphere_host.devTest.id
}   
  
data "vsphere_virtual_machine" "test_minimal" {
  name          = "esxi6.7"
  datacenter_id = data.vsphere_datacenter.dc.id
}

#resource "vsphere_virtual_machine" "test_new_minimal" {
#  name           = "test_minimal"
#  datacenter_id = data.vsphere_datacenter.dc.id
#}
