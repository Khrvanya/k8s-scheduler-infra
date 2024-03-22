locals {
  docker_repo_name = "k8s-docker"
}

/******************************************
   GAR Repo configuration 
 *****************************************/
resource "google_artifact_registry_repository" "repo" {
  project       = var.project_id
  location      = var.region

  repository_id = local.docker_repo_name
  description   = "${local.docker_repo_name} Docker repository (Terraform managed)"
  format        = "DOCKER"

  docker_config {
    immutable_tags = false
  }
}