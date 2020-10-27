# this file is auto-generated from connect.ps1 file, edit at your own risk
# the server, username, and password should be defined in environment variable or .tfvars file
variable "vsphere_server" { 
    type    = string 
  }

variable "vsphere_user" {
    type    = string
  }

variable "vsphere_password" {
    type    = string
  }

# provider vsphere declaration

provider "vsphere" {
  user = var.vsphere_user
  password = var.vsphere_password
  vsphere_server = var.vsphere_server
  allow_unverified_ssl = true
}

# vsphere_datacenter definition

data "vsphere_datacenter" "dc" {
   name = "Home-lab"
}

# vsphere_virtual_machine (template) definition

data "vsphere_virtual_machine" "win-2019-template" {
   name = "win-2019-template"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "win_10_template" {
   name = "win_10_template"
   datacenter_id = data.vsphere_datacenter.dc.id
}


# vsphere_host definition

data "vsphere_host" "Host-10_0_0_92" {
   name = "10.0.0.92"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "Resources-10_0_0_92" {
   name = "10.0.0.92/Resources"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "Host-10_0_0_3" {
   name = "10.0.0.3"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "Resources-10_0_0_3" {
   name = "10.0.0.3/Resources"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "Host-10_0_0_94" {
   name = "10.0.0.94"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "Resources-10_0_0_94" {
   name = "10.0.0.94/Resources"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "Host-10_0_0_71" {
   name = "10.0.0.71"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "Resources-10_0_0_71" {
   name = "10.0.0.71/Resources"
   datacenter_id = data.vsphere_datacenter.dc.id
}


# vsphere_datastore definition

data "vsphere_datastore" "datastore1" {
   name = "datastore1"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "USB-DS3_2" {
   name = "USB-DS3.2"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "ds2-ssd" {
   name = "ds2-ssd"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore1_2" {
   name = "datastore1 (2)"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "ds0_5" {
   name = "ds0.5"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "ds3-ssd" {
   name = "ds3-ssd"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "external" {
   name = "external"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "ds1_8t" {
   name = "ds1.8t"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "ds-235NFSShare" {
   name = "235NFSShare"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore1_1" {
   name = "datastore1 (1)"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "USB-DS2" {
   name = "USB-DS2"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore1-ssd" {
   name = "datastore1-ssd"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore2" {
   name = "datastore2"
   datacenter_id = data.vsphere_datacenter.dc.id
}


# vsphere_network definition

data "vsphere_network" "Networkadapter1" {
   name = "Network adapter 1"
   datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "VMNetwork" {
   name = "VM Network"
   datacenter_id = data.vsphere_datacenter.dc.id
}


