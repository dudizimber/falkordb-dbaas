module "project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.4.0"

  name            = var.project_name
  folder_id       = var.project_parent_id
  org_id          = var.org_id
  billing_account = var.billing_account_id
  lien            = true

  create_project_sa = false

  activate_apis = [
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "servicemanagement.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com",
  ]
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id = var.project_id

  network_name            = var.public_network_name
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false

  subnets = [
    {
      subnet_name           = "falkordb-control-plane-public-subnet"
      subnet_region         = "me-west1",
      subnet_ip             = "10.0.0.0/24"
      subnet_private_access = true
    }
  ]

}

module "tenant_provision" {
  source = "./control_plane_provision"

  project_id = var.project_id
}
