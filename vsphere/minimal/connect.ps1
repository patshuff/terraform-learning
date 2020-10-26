
$file_name = "test.yy"
if (Test-Path $file_name) {
  $q1 = 'overwrite ' + $file_name + '? (type yes to confirm)'
  $resp = Read-Host -Prompt $q1
  if ($resp -ne "yes") {
    Write-Host "please delete $file_name before executing this script"
	Exit
  }
}  
Start-Transcript -UseMinimalHeader -Path "$file_name"
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

if (!$TF_VAR_vsphere_password) {
  $TF_VAR_vsphere_password = Read-Host -Prompt 'Connect with username'
  Write-Host -Separator "" 'variable "vsphere_password" {
    type    = string
    default = "'$TF_VAR_vsphere_password'"'
  '}'
} else {
  Write-Host 'variable "vsphere_password" {
    type    = string
  }'
}

$connect = Connect-VIServer -Server $TF_VAR_vsphere_server -User $TF_VAR_vsphere_user -Password $TF_VAR_vsphere_password

$dc = Get-Datacenter
Write-Host '# vsphere_datacenter definition'
Write-Host ' '
Write-Host -Separator "" 'data "vsphere_datacenter" "dc" {
   name = "'$dc.Name'"'
   '}'
Write-Host ' '   

Write-Host 'provider "vsphere" {
  user = var.vsphere_user
  password = var.vsphere_password
  vsphere_server = var.vsphere_server
  allow_unverified_ssl = true
}'

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

Write-Host '# vsphere_datastore definition'
Write-Host ' '
$Datastore_name = @()
$Datastore_name = Get-Datastore

foreach ($item in $Datastore_name) {
  $item2 = $item -replace ' ',''
  $item2 = $item2 -replace '\(','_'
  $item2 = $item2 -replace '\)',''
  $item2 = $item2 -replace '\.','_'
  Write-Host -Separator "" 'data "vsphere_datastore" "ds-'$item2'"' ' {
   name = "'$item'"'
   '   datacenter_id = data.vsphere_datacenter.dc.id
}'
Write-Host ' '
}
Write-Host ' '   

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

Stop-Transcript
$test = Get-Content "$file_name"
$test[5..($test.count - 5)] | Out-File "$file_name"
