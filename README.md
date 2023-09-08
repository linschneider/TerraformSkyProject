# TerraformSkyProject
# Installation instructions
before instalition,
make sure to add secret.tfvar file with this syntax in order to creat new password for you:



variable "dbpassword" {
  description = "Password for the database user"
  type        = string
  default     = "<password you choose>"
  sensitive = true
}

in order to install the project 

$ az login --tent <your azure subsciption>

$ git clone https://github.com/linschneider/TerraformSkyProject.git
$ cd TerraformSkyProject

$ terraform init
$ terraform plan 
$ terraform apply

In order to exit, 
$ terraform destroy


# About the TerraformSkyProject
In this Terraform project, I have incorporated the following technologies and components:

•Terraform

•Bash scripting

•Microsoft Azure

•Python

•Git version control

•Flask framework

•PostgreSQL database




