resource "random_id" "suffix" {
  byte_length = 3
}

resource "random_integer" "panopass-length" {
  min = 12
  max = 25
}

resource "random_password" "panopass" {
  length           = random_integer.panopass-length.result
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  special          = true
  override_special = "_%!"
}

resource "azurerm_storage_account" "panstgac" {
  name                     = "panstgac${random_id.suffix.dec}"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

resource "azurerm_public_ip" "pano_public_ip" {
  name                = "panopublicip${random_id.suffix.dec}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  domain_name_label   = "pano${random_id.suffix.dec}"
}


resource "azurerm_network_interface" "pano_vnic" {
  name                = "panovnic${random_id.suffix.dec}"
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_public_ip.pano_public_ip]

  ip_configuration {
    name                          = "panoip"
    subnet_id                     = var.consul_subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pano_public_ip.id
  }

  tags = {
    displayName = "pano_vnic"
  }
}


resource "azurerm_virtual_machine" "pano_vm" {
  name                = "pano${random_id.suffix.dec}"
  location            = var.location
  resource_group_name = var.resource_group_name
  vm_size             = var.pano_size

  depends_on = [azurerm_network_interface.pano_vnic]
  plan {
    name      = var.pano_sku
    publisher = var.pano_publisher
    product   = var.pano_offer
  }

  storage_image_reference {
    publisher = var.pano_publisher
    offer     = var.pano_offer
    sku       = var.pano_sku
    version   = "latest"
  }

  storage_os_disk {
    name          = "panovm${random_id.suffix.dec}-osDisk"
    vhd_uri       = "${azurerm_storage_account.panstgac.primary_blob_endpoint}vhds/panovm${random_id.suffix.dec}-${var.pano_offer}-${var.pano_sku}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "panovm${random_id.suffix.dec}"
    admin_username = var.pano_username
    admin_password = random_password.panopass.result
  }

  primary_network_interface_id = azurerm_network_interface.pano_vnic.id
  network_interface_ids        = [azurerm_network_interface.pano_vnic.id]

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
