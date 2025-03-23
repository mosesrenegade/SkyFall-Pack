variable "resource_group_location" {
  type        = string
  default     = "westus2"
  description = "Location of the resource group."
}

variable "username" {
  type        = string
  description = "The username for the local account that will be created on the new VM."
  default     = "nickvourd"
}

# Add prefix variable for naming consistency
variable "prefix" {
  type        = string
  default     = "vm"
  description = "Prefix for all resources"
}

# Add SSH private key filename variable
variable "ssh_privkey" {
  type        = string
  default     = "ssh_privkey"
  description = "SSH private key filename"
}

# Add DNS name variable
variable "dns_name" {
  type        = string
  description = "DNS name label for the VM's public IP"
  default     = "skyfall"
}

# Add size type variable
variable "size" {
  type        = string
  description = "Azure VM size"
  default     = "Standard_B1ms"
}

# Keystore filename
variable "keystore_filename" {
  type        = string
  description = "Keystore Filename"
  default     = "keystore_filename"
}

# Keystore Password
variable "keystore_password" {
  type        = string
  description = "Keystore Password"
  default     = "keystore_password"
}

# Custom HTTP Header for TeamServer
variable "custom_header" {
  type        = string
  description = "Customer Header for TeamServer"
}

# Custom HTTP Header for TeamServer
variable "custom_header_lower" {
  type        = string
  description = "Customer Header for TeamServer in Lowercase"
}

# Custom HTTP Secret for TeamServer
variable "custom_secret" {
  type        = string
  description = "Customer Secret for TeamServer in Lowercase"
}

# TeamServer Port
variable "teamserver" {
  type        = string
  description = "Teamserver Port Default is 8443"
}