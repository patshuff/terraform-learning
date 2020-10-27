  
data "vsphere_virtual_machine" "test_minimal" {
  name          = "esxi6.7"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "iso_location" {
   name = "USB-DS3.2"
   datacenter_id = data.vsphere_datacenter.dc.id
}

variable "windows_10_iso" {
   type = string
   default = "iso/Windows10 (1).iso"
}

resource "vsphere_virtual_machine" "vm" {
   name = "terraform-test"
   resource_pool_id = data.vsphere_resource_pool.Resources-10_0_0_92.id
   datastore_id = data.vsphere_datastore.datastore1-ssd.id
   
   host_system_id = data.vsphere_host.Host-10_0_0_92.id
   
   scsi_type = data.vsphere_virtual_machine.win_10_template.scsi_type
   guest_id = data.vsphere_virtual_machine.win_10_template.guest_id
   network_interface {
     network_id = data.vsphere_network.VMNetwork.id
	 adapter_type = data.vsphere_virtual_machine.win_10_template.network_interface_types[0]
   }
   disk {
     label = data.vsphere_virtual_machine.win_10_template.disks.0.label
	 size = data.vsphere_virtual_machine.win_10_template.disks.0.size
   }
   
#   cdrom {
#     datastore_id = data.vsphere_datastore.iso_location.id
#	 path = var.windows_10_iso
#   }
   
   clone {
     template_uuid = data.vsphere_virtual_machine.win_10_template.id
   }
}
