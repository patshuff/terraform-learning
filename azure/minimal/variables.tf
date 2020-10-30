provider "azurerm" {
  features {}
}

variable "createdby" {
  type    = string
  default = "TechEnablement"
}

variable "environment" {
  type    = string
  default = "TechEnablement"
}

variable "location" {
  type    = string
  default = "eastus"
}

resource "azurerm_resource_group" "rg" {
  name     = "TechEnablement3"
  location = var.location
  tags = {
    environment = var.environment
    deployedby  = var.createdby
  }
}

resource "azurerm_virtual_network" "myNet" {
  name                = "cmvltNet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    environment = var.environment
    createdby   = var.createdby
  }
}
