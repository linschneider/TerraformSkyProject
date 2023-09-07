# Define a resource group
resource "azurerm_resource_group" "rg_sky_terraform" {
  name     = var.resource_group_name
  location = var.location
}

# Define a virtual network
resource "azurerm_virtual_network" "vnet_sky_terraform" {
  name                = "${var.vnet_name}${var.project_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_sky_terraform.location
  resource_group_name = azurerm_resource_group.rg_sky_terraform.name
}

# Define subnets
resource "azurerm_subnet" "web_subnet" {
  name                 = "web${var.subnet_name}"
  resource_group_name  = azurerm_resource_group.rg_sky_terraform.name
  virtual_network_name = azurerm_virtual_network.vnet_sky_terraform.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "db_subnet" {
  name                 = "db${var.subnet_name}"
  resource_group_name  = azurerm_resource_group.rg_sky_terraform.name
  virtual_network_name = azurerm_virtual_network.vnet_sky_terraform.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Define Network Security Groups (NSGs)
resource "azurerm_network_security_group" "nsg_sky_terraform_web"{
  name                = "${var.nsg_name}web_${var.project_name}"
  location            = azurerm_resource_group.rg_sky_terraform.location
  resource_group_name = azurerm_resource_group.rg_sky_terraform.name

  security_rule {
    name                       = "Allow-Inbound-ports"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["8080", "80", "5000", "22"]
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.0.0/24"
  }
} 

resource "azurerm_network_security_group" "nsg_sky_terraform_db"{
  name                = "${var.nsg_name}db_${var.project_name}"
  location            = azurerm_resource_group.rg_sky_terraform.location
  resource_group_name = azurerm_resource_group.rg_sky_terraform.name

  security_rule {
    name                       = "Allow-DB-Inbound-5432"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp" 
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "10.0.0.0/24"
    destination_address_prefix = "10.0.1.0/24"
  }

 security_rule {
    name                       = "Allow-Inbound-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_web_subnet_association" {
  subnet_id                 = azurerm_subnet.web_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_sky_terraform_web.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_db_subnet_association" {
  subnet_id                 = azurerm_subnet.db_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_sky_terraform_db.id
}

resource "azurerm_public_ip" "load_ip" {
  name                = "load-ip"
  location            = azurerm_resource_group.rg_sky_terraform.location
  resource_group_name = azurerm_resource_group.rg_sky_terraform.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_public_ip" "web_public_ip" {
  name                = "web_public_ip"
  resource_group_name = azurerm_resource_group.rg_sky_terraform.name
  location            = azurerm_resource_group.rg_sky_terraform.location
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "db_public_ip" {
  name                = "db_public_ip"
  resource_group_name = azurerm_resource_group.rg_sky_terraform.name
  location            = azurerm_resource_group.rg_sky_terraform.location
  allocation_method   = "Dynamic"
}

# Define network interface for web vm
resource "azurerm_network_interface" "nic_vmweb_sky_terraform" {
  name                = "nic_vmweb_sky_terraform"
  location            = azurerm_resource_group.rg_sky_terraform.location
  resource_group_name = azurerm_resource_group.rg_sky_terraform.name
  ip_configuration {
    name                          = "internal_web_nic_configuration"
    subnet_id                     = azurerm_subnet.web_subnet.id
    public_ip_address_id          = azurerm_public_ip.web_public_ip.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic_vmdb_sky_terraform" {
  name                = "nic_vmdb_sky_terraform"
  location            = azurerm_resource_group.rg_sky_terraform.location
  resource_group_name = azurerm_resource_group.rg_sky_terraform.name
  ip_configuration {
    name                          = "db-nic-configuration"
    public_ip_address_id          = azurerm_public_ip.db_public_ip.id
    subnet_id                     = azurerm_subnet.db_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.1.4"
  }
}

# Define virtual machines
resource "azurerm_linux_virtual_machine" "vm_web_sky_terraform" {
   admin_ssh_key {
    username   = "skyuser"
    public_key = file("${var.ssh_public_key}")
  }

  name                  = "VMweb"
  location              = azurerm_resource_group.rg_sky_terraform.location
  resource_group_name   = azurerm_resource_group.rg_sky_terraform.name
  network_interface_ids = [azurerm_network_interface.nic_vmweb_sky_terraform.id]
  size                  = "Standard_D2s_v3"
  
  computer_name                   = "VMweb"
  admin_username                  = "skyuser"
  admin_password                  = ""

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
    
    os_disk {
    name                 = "web_os_disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
 depends_on = [ azurerm_linux_virtual_machine.vm_db_sky_terraform ]
}

resource "null_resource" "remote_execution_sky_web" { 
    connection {
      type     = "ssh"
      user     = "skyuser"
      private_key = file("${var.ssh_private_key}")
      host     = azurerm_linux_virtual_machine.vm_web_sky_terraform.public_ip_address
    }
       provisioner "file" {
      source = var.secret_path
      destination = "./secret.tfvar.tf"
    }

  
    provisioner "remote-exec" {
    inline = [
      "git clone https://github.com/linschneider/TerraformSkyProject.git",
      "touch dbpass",
      "echo $(cat secret.tfvar.tf | grep -o 'default\\s*=\\s*\"[^\\\"]*\"' | sed 's/default\\s*=\\s*\\\"\\(.*\\)\\\"/\\1/') > dbpass",
      "sudo chmod 777 .",
      "mv dbpass TerraformSkyProject/dbpass",
      "cd TerraformSkyProject",
      "chmod 777 app_script.sh",
      "sudo ./app_script.sh"
    ] 
  }
}

resource "azurerm_linux_virtual_machine" "vm_db_sky_terraform" {
  admin_ssh_key {
    username   = "skyuser"
    public_key = file("${var.ssh_public_key}")
  }
  
  name                  = "VMdb"
  location              = azurerm_resource_group.rg_sky_terraform.location
  resource_group_name   = azurerm_resource_group.rg_sky_terraform.name
  network_interface_ids = [azurerm_network_interface.nic_vmdb_sky_terraform.id]
  size                  = "Standard_D2s_v3"
  computer_name                   = "VMdb"
  admin_username                  = "skyuser"
  admin_password                  = ""

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    name                 = "db_os_disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

# create db vm managed disk
resource "azurerm_managed_disk" "pdisk_sky_db" {
  name                 = "${azurerm_linux_virtual_machine.vm_db_sky_terraform.name}-disk1"
  location              = azurerm_resource_group.rg_sky_terraform.location
  resource_group_name   = azurerm_resource_group.rg_sky_terraform.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 4
}
# attach db disk to db vm
resource "azurerm_virtual_machine_data_disk_attachment" "disk_attach_sky_db_dev" {
  managed_disk_id    = azurerm_managed_disk.pdisk_sky_db.id
  virtual_machine_id = azurerm_linux_virtual_machine.vm_db_sky_terraform.id
  lun                = "4"
  caching            = "ReadWrite"
}

resource "null_resource" "remote_execution_sky_db" { 
    connection {
      type     = "ssh"
      user     = "skyuser"
      private_key = file("${var.ssh_private_key}")
      host     = azurerm_linux_virtual_machine.vm_db_sky_terraform.public_ip_address
    }

    provisioner "file" {
      source = var.secret_path
      destination = "./secret.tfvar.tf"
    }

    provisioner "remote-exec" {
    inline = [
      "git clone https://github.com/linschneider/TerraformSkyProject.git",
      "touch dbpass",
      "echo $(cat secret.tfvar.tf | grep -o 'default\\s*=\\s*\"[^\\\"]*\"' | sed 's/default\\s*=\\s*\\\"\\(.*\\)\\\"/\\1/') > dbpass",
      "sudo chmod 777 .",
      "mv dbpass TerraformSkyProject/dbpass",
      "cd TerraformSkyProject",
      "sudo chmod 777 ./postgresql_script.sh",
      "sudo ./postgresql_script.sh"
      ]
  }
}
