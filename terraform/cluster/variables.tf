variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "zone" {
  description = "The zone for the GKE cluster"
  type        = string
}

variable "network_project_id" {
  type        = string
  description = "The GCP project housing the VPC network to host the cluster in"
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "The IP range in CIDR notation used for the hosted master network"
}