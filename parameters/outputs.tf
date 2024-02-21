output "names" {
  sensitive = true
  value = local.names
}

output "keys" {
  sensitive = true
  value = keys(var.parameters)
}
