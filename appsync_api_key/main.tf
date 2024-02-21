locals {
  has_appsync = var.appsync.id != ""
}

resource "time_rotating" "main" {
  rotation_months = var.rotation_months
}

locals {
  api_key_expires = timeadd(
    time_rotating.main.id,
    "${var.expiry_months * 30 * 24}h"
  )
}

resource "aws_appsync_api_key" "main" {
  count = local.has_appsync ? 1 : 0
  api_id = var.appsync.id
  description = "${var.name} (Managed by Terraform)"
  expires = format("%sT12:00:00Z", element(split("T", local.api_key_expires), 0))
}
