output "definitions" {
  value = var.xray_enabled ? [local.xray_config, local.config] : [local.config]
}
