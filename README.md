# TerraformSkyProject

## Table of Contents
- [Installation Instructions](#installation-instructions)
- [About the TerraformSkyProject](#about-the-terraformskyproject)
- [Terraform Infrastructure in Azure Portal](#terraform-infrastructure-in-azure-portal)
- [App Script](#app-script)
- [Main Configuration](#main-configuration)
- [DB Script](#db-script)
- [Flask App](#flask-app)

## Installation Instructions

Before installation, please make sure to follow these steps:

1. Create a `secret.tfvar` file with the following syntax to set up a new password:

    ```hcl
    variable "dbpassword" {
      description = "Password for the database user"
      type        = string
      default     = ""
      sensitive   = true
    }
    ```

2. To install the project, follow these steps:

   ```bash
   $ az login --tenant

   $ git clone https://github.com/linschneider/TerraformSkyProject.git
   $ cd TerraformSkyProject

   $ terraform init
   $ terraform plan
   $ terraform apply
To exit and destroy the resources:

```bash
$ terraform destroy
```
## About the TerraformSkyProject
The TerraformSkyProject incorporates the following technologies and components:

Terraform
Bash scripting
Microsoft Azure
Python
Git version control
Flask framework
PostgreSQL database


## Terraform Infrastructure in Azure Portal

The following Terraform configuration defines the infrastructure components that will be created in the Azure portal:

- **Resource Group:** The resource group is created with the name specified in the `var.resource_group_name` variable and located in the specified Azure region (`var.location`).

- **Virtual Network:** A virtual network named `${var.vnet_name}${var.project_name}` is created within the previously defined resource group. It uses the address space `10.0.0.0/16`.

- **Subnets:** Two subnets are defined within the virtual network:
  - `web_subnet` with the address prefix `10.0.0.0/24`.
  - `db_subnet` with the address prefix `10.0.1.0/24`.

- **Network Security Groups (NSGs):** Two NSGs are created, one for the web subnet and one for the database subnet. They define security rules to allow inbound traffic on specific ports and protocols.

- **Public IPs:** Three public IPs are defined, including one for load balancing and two for the web and database VMs. The allocation method for the load IP is static, while the web and database IPs are dynamic.

- **Network Interfaces:** Two network interfaces are defined for the web and database VMs, respectively. They are associated with the appropriate subnets and public IPs.

- **Virtual Machines:** Two Linux virtual machines are created, one for the web (`VMweb`) and one for the database (`VMdb`). They use SSH keys for authentication and specify the image reference for the OS disk.

- **Managed Disk for Database VM:** A managed disk named `${azurerm_linux_virtual_machine.vm_db_sky_terraform.name}-disk1` is created and attached to the database VM. It has a size of 4 GB.

This Terraform configuration automates the provisioning of these resources in Azure, allowing you to easily create and manage your infrastructure in a consistent and repeatable manner.


## App Script
To run the app script, follow these steps:

```bash
# Clone the repository
git clone https://github.com/linschneider/TerraformSkyProject.git

# Navigate to the Flask app directory
cd TerraformSkyProject
sudo apt update
sudo apt install -y python3 python3-pip

# Install or update Python dependencies
pip install flask
pip install psycopg2
python3 -m pip install psycopg2-binary
sleep 1

# Run your Flask application (adjust the command as needed)
flask --app=sky_flask_app.py run --host=0.0.0.0 --port=8080
```

## Main Configuration
The main Terraform configuration defines Azure resources such as resource groups, virtual networks, subnets, network security groups, public IPs, network interfaces, and virtual machines. It also sets up the necessary network and security configurations.

## DB Script
The DB script sets up a PostgreSQL database on the virtual machine. It performs the following tasks:

- Mounts a data disk to the VM.
- Adds the PostgreSQL repository.
- Imports the PostgreSQL repository key.
- Installs PostgreSQL.
- Configures PostgreSQL with user, database, and table.
- Grants privileges to the user.
- Inserts sample data into the database.

## Flask App
The Flask app provides a RESTful API to interact with the PostgreSQL database. It includes endpoints for retrieving data from the "data" table, inserting new data, and deleting data. The app uses the psycopg2 library to connect to the PostgreSQL database.

To interact with the Flask app, you can make HTTP requests to the following endpoints:
```bash
GET /data: Retrieves data from the "data" table.
POST /data: Inserts new data into the "data" table.
DELETE /data/<int:data_id>: Deletes data from the "data" table by ID.
Make sure to replace <int:data_id> with the ID of the data you want to delete when using the DELETE endpoint.
```
Note: The database password is read from the secret.tfvar file, so ensure it's set correctly before running the Flask app.

## Feel free to reach out if you have any questions or need further assistance with the TerraformSkyProject.
