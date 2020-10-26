  
data "vsphere_virtual_machine" "test_minimal" {
  name          = "esxi6.7"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
   name = "terraform-test"
   resource_pool_id = data.vsphere_resource_pool.Resources-10_0_0_92.id
   host_system_id = data.vsphere_host.Host-10_0_0_92.id
   guest_id = "windows9_64Guest"
   network_interface {
     network_id = data.vsphere_network.VMNetwork.id
   }
   disk {
     label = "Disk0"
	 size = 40
   }
   clone {
     template_uuid = data.vsphere_virtual_machine.win_10_template.id
   }
}
