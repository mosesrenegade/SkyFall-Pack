# Generates a cloud-init configuration file for the VM using a template
resource "local_file" "compute_cloud_init" {
  content = templatefile("${path.module}/templates/compute_cloud_init.tmpl",
    {
      hostname            = "vm-${var.prefix}-${random_string.main.result}", # Dynamic hostname
      fqdn                = azurerm_public_ip.main.fqdn,                    # Public FQDN from Azure
      keystore_filename   = var.keystore_filename,                          # Keystore filename
      keystore_password   = var.keystore_password,                          # Keystore password
      custom_header       = var.custom_header,                              # Custom HTTP header
      custom_header_lower = var.custom_header_lower,                        # Lowercased header version
      custom_secret       = var.custom_secret,                              # Custom secret value
      teamserver          = var.teamserver                                  # Teamserver IP or DNS
    }
  )
  filename = "${path.module}/files/compute_cloud_init.cfg" # Output path for the rendered config
}

# Deploys the main Linux VM
resource "azurerm_linux_virtual_machine" "main" {
  name                = "vm-${var.prefix}-${random_string.main.result}"    # Dynamic VM name
  resource_group_name = azurerm_resource_group.main.name                  # Target resource group
  location            = var.resource_group_location                       # Azure region
  size                = var.size                                          # VM size (e.g., Standard_B2s)
  admin_username      = var.username                                      # SSH username
  network_interface_ids = [
    azurerm_network_interface.main.id                                     # NIC attachment
  ]
  disable_password_authentication = true                                  # Enforce key-based auth

  admin_ssh_key {
    username   = var.username                                             # SSH username
    public_key = file("${var.ssh_privkey}.pub")                           # Public key path
  }

  user_data = base64encode(local_file.compute_cloud_init.content)         # Cloud-init config (base64)

  os_disk {
    caching              = "ReadWrite"                                    # Disk caching mode
    storage_account_type = "Standard_LRS"                                 # Disk storage type
  }

  source_image_reference {
    publisher = "Canonical"                                               # Image publisher
    offer     = "0001-com-ubuntu-server-jammy"                            # Ubuntu offer
    sku       = "22_04-lts-gen2"                                          # SKU version
    version   = "latest"                                                  # Always latest image
  }
}
