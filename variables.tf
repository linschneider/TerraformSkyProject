variable "project_name" {
    type            = string
    description     = "Resource group name"
    default         = "sky_terraform"
}

variable "resource_group_name" {
    type            = string
    description     = "Resource group name"
    default         = "rg_sky_terraform"
}

variable "nsg_name" {
    type            = string
    description     = "Network security group name"
    default         = "nsg_"
}

variable "vnet_name" {
    type            = string
    description     = "vnet name"
    default         = "vnet_"
}

variable "subnet_name" {
    type            = string
    description     = "subnet_name"
    default         = "_snet_sky"
}

variable "location" {
  type              = string
  description       = "default location"
  default           = "West Europe"
}


variable "nic_db" {
  type              = string
  description       = "network interface for db vm"
  default           = "nic_vmdb_sky_terraform"
}


variable "nic_web" {
  type              = string
  description       = "network interface for web vm"
  default           = "nic_vmweb_sky_terraform"
}


variable "ssh_public_key" {
  description = "SSH public key for authentication"
  default = "C:/Users/lin schneider/.ssh/id_rsa.pub"

}

variable "ssh_private_key" {
  description = "SSH private key for authentication"
  default = "C:/Users/lin schneider/.ssh/id_rsa"

}

variable "app_script_path" {
  default = "C:/Terraform/sky/app_script.sh"
}

variable "db_script_path" {
  default = "C:/Terraform/sky/postgresql_script.sh"
}

variable "secret_path" {
  default = "C:/Terraform/sky/secret.tfvars.tf"
}