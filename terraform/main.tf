provider "azurerm" {
  tenant_id       = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  features {}
}
terraform {
  backend "azurerm" {
    storage_account_name = "tstate10494"
    container_name       = "tstate"
    access_key           = "Gt06tbj6PSgPHLwC2dqO0MVqNcdyyiWpygyybWoVptyVyIiboZ+hai+Y03aEPvrCGkBJ/aaKETI++ASte4UiCw=="
  }
}
# Get the resource group
data "azurerm_resource_group" "udacity-rg" {
  name = var.resource_group
}

module "network" {
  source               = "./modules/network"
  address_space        = "${var.address_space}"
  location             = data.azurerm_resource_group.udacity-rg.location
  virtual_network_name = "${var.virtual_network_name}"
  application_type     = "${var.application_type}"
  resource_type        = "NET"
  resource_group       = data.azurerm_resource_group.udacity-rg.name
  address_prefix_test  = "${var.address_prefix_test}"
}

module "nsg-test" {
  source           = "./modules/networksecuritygroup"
  location         = data.azurerm_resource_group.udacity-rg.location
  application_type = "${var.application_type}"
  resource_type    = "NSG"
  resource_group   = data.azurerm_resource_group.udacity-rg.name
  subnet_id        = "${module.network.subnet_id_test}"
  address_prefix_test = "${var.address_prefix_test}"
}
module "appservice" {
  source           = "./modules/appservice"
  location         = data.azurerm_resource_group.udacity-rg.location
  application_type = "${var.application_type}"
  resource_type    = "AppService"
  resource_group   = data.azurerm_resource_group.udacity-rg.name
}
module "publicip" {
  source           = "./modules/publicip"
  location         = data.azurerm_resource_group.udacity-rg.location
  application_type = "${var.application_type}"
  resource_type    = "publicip"
  resource_group   = data.azurerm_resource_group.udacity-rg.name
}