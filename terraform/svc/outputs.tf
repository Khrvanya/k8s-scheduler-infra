output "images_repo_id" {
  description = "The ID of the GAR repo for saas dev docker images."
  value       = google_artifact_registry_repository.repo.id
}

output "images_repo_name" {
  description = "The name of the GAR repo for saas dev docker images."
  value       = google_artifact_registry_repository.repo.name
}
