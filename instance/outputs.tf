output "ids" {
  value = aws_instance.main.*.id
}

output "network_interface_ids" {
  value = aws_instance.main.*.primary_network_interface_id
}

output "public_dns" {
  value = aws_instance.main.*.public_dns
}
