# outputs.tf

output "bastion_public_ip" {
  description = "Public IP of the Bastion Host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_ssh_key" {
  description = "SSH Private Key for Bastion Access"
  value       = tls_private_key.bastion_key.private_key_pem
  sensitive   = true
}
