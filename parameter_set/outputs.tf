output "name" {
  value = local.name
}

output "keys" {
  value = keys(local.params)
}
