# outputs.tf

output "bastion_public_ip" {
  description = "Public IP of the Bastion Host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_ssh_key" {
  description = "SSH Key for the Bastion Host"
  value       = aws_key_pair.bastion_key.key_name
}
