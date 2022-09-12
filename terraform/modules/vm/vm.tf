resource "azurerm_network_interface" "test" { 
  name                = "nic0"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id_test
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.instance_ids
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "vm0"
  location                        = var.location
  resource_group_name             = var.resource_group
  size                            = "Standard_B1s"
  admin_username                  = var.admin_username
  source_image_id                 = var.packer_image
  disable_password_authentication = true
  
  network_interface_ids = [azurerm_network_interface.test.id]

  admin_ssh_key {
    username       = var.admin_username
    public_key     = file(var.public_key_path)
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    environment  = "test"
    project_name = "Udacity"
    stage        = "Testing"
  }
}