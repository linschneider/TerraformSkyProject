# TerraformSkyProject

## Table of Contents
- [Installation Instructions](#installation-instructions)
- [About the TerraformSkyProject](#about-the-terraformskyproject)
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
