# Generate SSH key pair
#resource "tls_private_key" "ssh" {
#  algorithm = "RSA"
#  rsa_bits  = 4096
#}

# Save private key to file
#resource "local_file" "private_key" {
# content         = tls_private_key.ssh.private_key_pem
#  filename        = var.ssh_privkey
#  file_permission = "0600"
#}