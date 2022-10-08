provider "azurerm" {
  tenant_id       = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  features {}
}
terraform {
  backend "azurerm" {
    key = "terraform.tfstate"
    storage_account_name = "tstate24037"
    container_name       = "tstate"
    access_key           = "RZ5lKqfTtcJnNs/447KHn4NrNTSAqPk87k9ZiVLc1KLQuHxZNadxyyt8uLHH/l/OnLTqbblyH2q4+ASttYj4fA=="
  }
}
# Get the resource group
data "azurerm_resource_group" "udacity-rg" {
  name = var.resource_group
}

# Get the custom packer image
data "azurerm_image" "udacity-image" {
  name                = var.packer_image
  resource_group_name = var.resource_group
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

module "vm" {
  source               = "./modules/vm"
  location             = data.azurerm_resource_group.udacity-rg.location
  resource_group       = data.azurerm_resource_group.udacity-rg.name
  resource_type        = "vm"

  admin_username       = var.admin_username
  subnet_id_test       = module.network.subnet_id_test
  instance_ids         = module.publicip.public_ip_address_id
  packer_image         = data.azurerm_image.udacity-image.id
  public_key_path      = var.public_key_path
}