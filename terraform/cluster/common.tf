terraform {
  required_version = ">= 1.5.7"

  backend "gcs" {
    bucket = "tf-state-3427"
    prefix = "terraform/state/cluster"
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

data "terraform_remote_state" "network" {
  backend = "gcs"

  config = {
    bucket = "tf-state-31004"
    prefix = "terraform/state/network/shared-vpc"
  }
}

data "terraform_remote_state" "bastion" {
  backend = "gcs"

  config = {
    bucket = "tf-state-31004"
    prefix = "terraform/state/vm/bastion"
  }
}
