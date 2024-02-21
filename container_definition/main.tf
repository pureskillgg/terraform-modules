locals {
  xray_factor = var.xray_enabled ? 1 : 0
  xray_cpu = 32 * local.xray_factor
  xray_memory = 256 * local.xray_factor
}

locals {
  cpu = var.cpu - local.xray_cpu
  memory = var.memory - local.xray_memory
}

locals {
  xray_config = templatefile("${path.module}/xray.json.tpl", {
    cpu = local.xray_cpu
    memory = local.xray_memory
  })

  config = templatefile("${path.module}/config.json.tpl", {
    name = var.name
    image = var.image
    cpu = local.cpu
    memory = local.memory
    uid = var.uid
    gid = var.gid
    stop_timeout = var.stop_timeout
    xray_enabled = var.xray_enabled
    health_check_cmd = var.health_check_cmd
    log_group = var.log_group
    log_level = var.log_level
    stage = var.meta.stage
    region = var.region
    environment = var.environment
    secrets = var.secrets
  })
}
