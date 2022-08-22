resource "random_id" "suffix" {
  byte_length = 4
}

resource "random_integer" "panoramapassword-length" {
  min = 12
  max = 25
}

resource "random_password" "panoramapassword" {
  length           = random_integer.panoramapassword-length.result
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  special          = true
  override_special = "_%!"
}

resource "azurerm_storage_account" "panorama_stg_ac" {
  name                     = "panorama_stg_ac${random_id.suffix.dec}"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

resource "azurerm_public_ip" "panorama_public_ip" {
  name                = "panorama_public_ip-${random_id.suffix.dec}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  domain_name_label   = "panorama_public_ip-${random_id.suffix.dec}"
}


resource "azurerm_network_interface" "panorama_vnic" {
  name                = "panorama_vnic-${random_id.suffix.dec}"
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_public_ip.panorama_public_ip]

  ip_configuration {
    name                          = "panorama_ip"
    subnet_id                     = var.consul_subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.panorama_public_ip.id
  }

  tags = {
    displayName = "panorama_vnic"
  }
}


resource "azurerm_virtual_machine" "panorama_vm" {
  name                = "panorama_vm-${random_id.suffix.dec}"
  location            = var.location
  resource_group_name = var.resource_group_name
  vm_size             = var.panorama_size

  depends_on = [azurerm_network_interface.panorama_vnic]
  plan {
    name      = var.panorama_sku
    publisher = var.panorama_publisher
    product   = var.panorama_offer
  }

  storage_image_reference {
    publisher = var.panorama_publisher
    offer     = var.panorama_offer
    sku       = var.panorama_sku
    version   = "latest"
  }

  storage_os_disk {
    name          = "panorama_vm-${random_id.suffix.dec}-osDisk"
    vhd_uri       = "${azurerm_storage_account.panorama_stg_ac.primary_blob_endpoint}vhds/panorama_vm-${random_id.suffix.dec}-${var.panorama_offer}-${var.panorama_sku}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "panorama_vm-${random_id.suffix.dec}"
    admin_username = var.panorama_username
    admin_password = random_password.panoramapassword.result
  }

  primary_network_interface_id = azurerm_network_interface.panorama_vnic.id
  network_interface_ids        = [azurerm_network_interface.panorama_vnic.id]

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
