
# This program connects to a vSphere server and generates a variables.tf file that can be used as a basis for a terraform build
# 
# the program starts by looking for TF_VAR_vsphere_server, TF_VAR_vsphere_user, and TF_VAR_vsphere_password environment variables
#  and pushing them into the variables file if they are not defined and leaving them blank if they are defined.
#
# the program then connects to the vSphere server and creates a terraform ready file that can be used for vsphere provider, vsphere_hosts, 
#  vsphere_datastore, vsphere_resource_pool, and virtual machine templates. 
#
# assumptions:
#  username and password to connect to a vSphere server using the PowerCLI tools installed in a PowerShell 6+ environment. 
#

# change file_name to variables.tf if you want a single step generation of the variables.tf file. This program will prompt overwrite but will not
#   preserve the old file.
#
# Created and maintained by: pat@patshuff.com
#
$file_name = "test.yy"

# test to verify overwriting $file_name is ok and exit if it is not
if (Test-Path $file_name) {
  $q1 = 'overwrite ' + $file_name + '? (type yes to confirm)'
  $resp = Read-Host -Prompt $q1
  if ($resp -ne "yes") {
    Write-Host "please delete $file_name before executing this script"
	Exit
  }
}  

# Start-Transcript is used to record the output of this script and generate the $file_name file
Start-Transcript -UseMinimalHeader -Path "$file_name"

Write-Host "# this file is auto-generated from connect.ps1 file, edit at your own risk"
Write-Host "# the server, username, and password should be defined in environment variable or .tfvars file"

# check for a vsphere_server definition in environment variables
if (!$TF_VAR_vsphere_server) {
  $TF_VAR_vsphere_server = Read-Host -Prompt 'Input your server name'
  Write-Host -Separator "" 'variable "vsphere_server" {
    type    = string 
    default = "'$TF_VAR_vsphere_server'"' 
  '}' 
} else {
  Write-Host 'variable "vsphere_server" { 
    type    = string 
  }'
}
Write-Host " "

# check for a vsphere_user definition in environment variables
if (!$TF_VAR_vsphere_user) {
  $TF_VAR_vsphere_user = Read-Host -Prompt 'Connect with username'
  Write-Host -Separator "" 'variable "vsphere_user" {
    type    = string
    default = "'$TF_VAR_vsphere_user'"'
  '}'
} else {
  Write-Host 'variable "vsphere_user" {
    type    = string
  }'
}
Write-Host " "

# check for a vsphere_password definition in environment variables
if (!$TF_VAR_vsphere_password) {
  $TF_VAR_vsphere_password = Read-Host -Prompt 'Connect with password'
  Write-Host -Separator "" 'variable "vsphere_password" {
    type    = string
    default = "'$TF_VAR_vsphere_password'"'
  '}'
} else {
  Write-Host 'variable "vsphere_password" {
    type    = string
  }'
}
Write-Host " "

Write-Host "# provider vsphere declaration"
Write-Host " "
# connect to the vSphere server
$connect = Connect-VIServer -Server $TF_VAR_vsphere_server -User $TF_VAR_vsphere_user -Password $TF_VAR_vsphere_password

# output provider vsphere declaration
Write-Host 'provider "vsphere" {
  user = var.vsphere_user
  password = var.vsphere_password
  vsphere_server = var.vsphere_server
  allow_unverified_ssl = true
}'
Write-Host " "

# output vsphere_datacenter declaration
$dc = Get-Datacenter
Write-Host '# vsphere_datacenter definition'
Write-Host ' '
Write-Host -Separator "" 'data "vsphere_datacenter" "dc" {
   name = "'$dc.Name'"'
   '}'
Write-Host ' '   

# search for templates and create a vsphere_virtual_machine for each template found
Write-Host '# vsphere_virtual_machine (template) definition'
Write-Host ' '
$Template_Name = @()
$Template_Name = Get-Template

foreach ($item in $Template_Name) {
  $item2 = $item -replace ' ',''
  Write-Host -Separator "" 'data "vsphere_virtual_machine" "'$item'"' ' {
   name = "'$item'"'
   '   datacenter_id = data.vsphere_datacenter.dc.id
}'
Write-Host ' '
}
Write-Host ' '   

# search for hosts and create a vsphere_host for each host found
Write-Host '# vsphere_host definition'
Write-Host ' '
$Host_name = @()
$Host_name = Get-Datacenter | Get-VMHost 

foreach ($item in $Host_name) {
  $item2 = $item -replace '\.','_'
  Write-Host -Separator "" 'data "vsphere_host" "Host-'$item2'"' ' {
   name = "'$item'"'
   '   datacenter_id = data.vsphere_datacenter.dc.id
}'
  Write-Host ' '
  Write-Host -Separator "" 'data "vsphere_resource_pool" "Resources-'$item2'"' ' {
   name = "' $item '/Resources"
   datacenter_id = data.vsphere_datacenter.dc.id
}'
  Write-Host ' '
}
Write-Host ' '   

# search for datastores and create a vsphere_datastore for each host found
Write-Host '# vsphere_datastore definition'
Write-Host ' '
$Datastore_name = @()
$Datastore_name = Get-Datastore

foreach ($item in $Datastore_name) {
# get rid of spaces, open and close parenthesis, and postfix ds if datastore starts with non character
  $item2 = $item -replace ' ',''
  $item2 = $item2 -replace '\(','_'
  $item2 = $item2 -replace '\)',''
  $item2 = $item2 -replace '\.','_'
  # if datastore starts with non charater, postfix ds- before name
  if ($item2 -match '^[a-z]') {
  Write-Host -Separator "" 'data "vsphere_datastore" "'$item2'"' ' {
   name = "'$item'"'
   '   datacenter_id = data.vsphere_datacenter.dc.id
}'
   }
   else {
   Write-Host -Separator "" 'data "vsphere_datastore" "ds-'$item2'"' ' {
   name = "'$item'"'
   '   datacenter_id = data.vsphere_datacenter.dc.id
}'
   }
Write-Host ' '
} 
Write-Host ' '   

# search for network connections and create a vsphere_network for each host found
Write-Host '# vsphere_network definition'
Write-Host ' '
$Network_name = @()
$Network_name = Get-VirtualNetwork

foreach ($item in $Network_name) {
  $item2 = $item -replace ' ',''
  Write-Host -Separator "" 'data "vsphere_network" "'$item2'"' ' {
   name = "'$item'"'
   '   datacenter_id = data.vsphere_datacenter.dc.id
}'
Write-Host ' '
}
Write-Host ' '   

# output the variables.tf file to $file_name and truncate the first few and last few lines residual from the Transcript command
Stop-Transcript
$test = Get-Content "$file_name"
$test[5..($test.count - 5)] | Out-File "$file_name"
