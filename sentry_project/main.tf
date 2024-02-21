resource "sentry_project" "main" {
  name = var.name
  organization = var.organization
  team = var.team
  slug = var.name == "auth" ? "auth-" : var.name
  platform = var.platform
}

resource "sentry_key" "main" {
  name = "main"
  organization = var.organization
  project = sentry_project.main.slug
}

module "parameters" {
  source = "../parameters"
  name = var.name
  meta = var.meta
  tags = var.tags
  parameters = {
    dsn = sentry_key.main.dsn_public
  }
}
