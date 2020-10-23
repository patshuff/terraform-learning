# terraform-learning
Learning Terraform on Windows and Linux

Learning Terraform is relatively easy. There are a lot of resources to help you along the way.

With this repository we will build the foundation of using Terraform to build a virtual machine
 - on a local vSphere server
 - in AWS
 - in Azure
 - in GCP
 
and build tools and scripts along the way to help build this foundation. We will focus on building
a development environment on Windows and Linux as well as building a Windows and Linux virtual machine 
in all four environments.

For the first part of this exploration we will look at auto-generating code for vSphere. In this 
example we have a few files of interest
 - vsphere\minimal\config.ps1 - PowerShell script to generate variables.tf
 - vsphere\minimal\main.tf - minimal data declarations to declare an existing virtual machine with data object
 - vsphere\minimal\variables.tf - generated variables file from config.ps1
 - vsphere\minimal\test.xx - scratch copy of our variables.tf file to show generation of output
