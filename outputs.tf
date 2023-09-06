output "public_ip_address" {
value = azurerm_public_ip.load_ip.ip_address
 }

output "public_ip_address_web" {
value = azurerm_linux_virtual_machine.vm_web_sky_terraform.public_ip_address
 }

output "public_ip_address_db" {
value = azurerm_linux_virtual_machine.vm_db_sky_terraform.public_ip_address
 }

output "dbvm_id" {
value = azurerm_linux_virtual_machine.vm_db_sky_terraform.id
}