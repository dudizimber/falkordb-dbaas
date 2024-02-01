# locals {
#   service_account_email = reverse(split("/", var.tenant_provision_sa))[0]
#   service_account_name  = split("@", local.service_account_email)[0]
# }
# resource "kubernetes_role" "tenant_provision_sa_role" {
#   metadata {
#     name = "provisioner-sa-role"
#   }

#   rule {
#     api_groups = ["*"]
#     resources  = ["*"]
#     verbs      = ["*"]
#   }
# }

# resource "kubernetes_service_account" "tenant_provision_sa" {
#   metadata {
#     name = local.service_account_name
#     annotations = {
#       "iam.gke.io/gcp-service-account" = local.service_account_email
#     }
#   }
# }

# resource "kubernetes_role_binding" "tenant_provision_sa_role_binding" {
#   metadata {
#     name = "provisioner-sa-role-binding"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "Role"
#     name      = kubernetes_role.tenant_provision_sa_role.metadata[0].name
#   }

#   subject {
#     kind      = "ServiceAccount"
#     name      = kubernetes_service_account.tenant_provision_sa.metadata[0].name
#     namespace = "default"
#   }
# }

# # Bind the GCP Service Account to the Kubernetes Service Account
# Try to move this to control plane project to prevent tenant group from deleting it

# resource "google_service_account_iam_binding" "tenant_provision_sa_binding" {
#   service_account_id = var.tenant_provision_sa
#   members = [
#     "serviceAccount:${var.project_id}.svc.id.goog[default/${kubernetes_service_account.tenant_provision_sa.metadata[0].name}]"
#   ]
#   role = "roles/iam.workloadIdentityUser"
# }

module "falkordb_monitoring" {
  source = "./monitoring"
}
