
locals {
  network = data.terraform_remote_state.network.outputs.network_name

  private_subnet                             = data.terraform_remote_state.network.outputs.subnets["us-central1/saas-dev-us-central1-private"].name
  private_subnet_secondary_range_gke_pods    = data.terraform_remote_state.network.outputs.subnets_secondary_ranges_private[1].range_name
  private_subnet_secondary_range_gke_service = data.terraform_remote_state.network.outputs.subnets_secondary_ranges_private[2].range_name

  bastion_private_ip = data.terraform_remote_state.bastion.outputs.ip_address

  gke_name = "scheduler-${var.zone}"
}

/******************************************
  Kubernetes configuration 
 *****************************************/
module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "~> 30.0"

  project_id = var.project_id
  name       = local.gke_name
  
  regional = false 
  zones    = [var.zone]

  network_project_id = var.network_project_id 
  network            = local.network
  subnetwork         = local.private_subnet

  ip_range_pods     = local.private_subnet_secondary_range_gke_pods
  ip_range_services = local.private_subnet_secondary_range_gke_service

  enable_private_endpoint = true
  enable_private_nodes    = true
  
  master_ipv4_cidr_block = var.master_ipv4_cidr_block
  master_authorized_networks = [
    {
      cidr_block   = "${local.bastion_private_ip}/32"
      display_name = "bastion-host-dev"
    }
  ]
  
  release_channel    = "UNSPECIFIED"
  kubernetes_version = "1.27.3-gke.100"    # https://cloud.google.com/kubernetes-engine/docs/release-notes
  datapath_provider  = "ADVANCED_DATAPATH" # enable dataplane V2 (cilium)

  # Features
  horizontal_pod_autoscaling           = true
  http_load_balancing                  = true
  network_policy                       = false 
  dns_cache                            = false
  monitoring_enable_managed_prometheus = false
  enable_cost_allocation               = true
  node_metadata           = "GKE_METADATA"

  create_service_account = true
  grant_registry_access  = true
  registry_project_ids   = []

  remove_default_node_pool = true
  node_pools = [
    {
      name            = "node-pool1"
      machine_type       = "e2-standard-2"

      node_count         = 2
      autoscaling = false

      auto_upgrade = false
      auto_repair  = true

      disk_type       = "pd-standard"
      local_ssd_count = 0
      disk_size_gb    = 100

      enable_gcfs                 = false
      enable_integrity_monitoring = true
      enable_secure_boot          = true
      logging_variant             = "DEFAULT"

      workload_metadata = "GKE_METADATA"
    },
    {
      name            = "node-pool2"
      machine_type       = "e2-standard-4"

      node_count         = 1
      autoscaling = false

      auto_upgrade = false
      auto_repair  = true

      disk_type       = "pd-standard"
      local_ssd_count = 0
      disk_size_gb    = 100

      enable_gcfs                 = false
      enable_integrity_monitoring = true
      enable_secure_boot          = true
      logging_variant             = "DEFAULT"

      workload_metadata = "GKE_METADATA"
    },
  ]

  node_pools_tags = {
    "all" : [
      "allow-igw",
      "allow-ssh-from-iap",
      "allow-all-egress",

      # Those are necessary since GCP service project does not have permission to create firewall rules automatically in host project
      "allow-http-ingress",
      "allow-nginx-webhook-admission-from-k8s-master"
    ],
  }

}
