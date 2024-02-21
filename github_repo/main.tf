locals {
  pages_domain = var.pages_domain == null ? "${var.organization}.github.io" : var.pages_domain
  pages_url = var.pages_enabled ? "https://${local.pages_domain}/${var.name}/" : null
}

resource "github_repository" "main" {
  name = var.name
  description = var.description
  visibility = var.visibility == null ? "private" : var.visibility
  has_issues = true
  has_projects = false
  has_wiki = false
  is_template = false
  allow_merge_commit = var.allow_merge_commit
  allow_squash_merge = var.allow_squash_merge
  allow_rebase_merge = var.allow_rebase_merge
  has_downloads = false
  delete_branch_on_merge = true
  auto_init = false
  archive_on_destroy = true
  homepage_url = var.homepage_url == null ? local.pages_url : var.homepage_url
  topics = var.topics

  dynamic "pages" {
    for_each = var.pages_enabled ? [var.pages_enabled] : []
    content {
      cname = var.pages_cname
      source {
        branch = var.pages_branch
        path = var.pages_path
      }
    }
  }

  lifecycle {
    ignore_changes = [
      branches
    ]
  }
}

resource "github_team_repository" "main" {
  for_each = var.teams
  team_id = each.value.id
  repository = github_repository.main.name
  permission = each.value.permission
}

resource "github_repository_collaborator" "main" {
  for_each = var.collaborators
  repository = github_repository.main.name
  username = each.key
  permission = each.value.permission
}
