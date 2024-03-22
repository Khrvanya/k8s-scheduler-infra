terraform {
  required_version = ">= 1.5.7"

  backend "gcs" {
    bucket = "tf-state-3427"
    prefix = "terraform/state/svc"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.4"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.4"
    }
  }
}
