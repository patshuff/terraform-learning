
$file_name = "test.xx"
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
Stop-Transcript
$test = Get-Content "$file_name"
$test[5..($test.count - 5)] | Out-File "$file_name"
