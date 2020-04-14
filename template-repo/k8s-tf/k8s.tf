variable "cluster_number" { }

# use default current context, set with `gcloud container clusters get-credentials` in clusters-tf
provider "kubernetes" {
  config_path="../tf-kubeconfig-kyounger${var.cluster_number}.yaml"
}

# Specific application namespaces. Manged here because including 
# them in helm manifests makes it very easy to delete them. I really 
# only want to delete these if I'm deleting the entire infra.
resource "kubernetes_namespace" "cloudbees" {
  metadata {
    name = "cloudbees"
  }
}
resource "kubernetes_namespace" "nginx-ingress" {
  metadata {
    name = "nginx-ingress"
  }
}

# We provision a namespace for the cluster-admin SA that we use to 
# run helmfile via CI/CD. This SA should be outside all other namespaces to
# ensure token secret is not leaked.
#
# This could be a reduced permission rolebinding. You would need to manage 
# roles and permissions. cluster-admin is a simple catch all for demonstration.
resource "kubernetes_namespace" "hf_installer" {
  metadata {
    name = "hf-installer"
  }
}
resource "kubernetes_service_account" "hf_installer" {
  metadata {
    name = "hf-installer"
    namespace = "hf-installer"
  }
}
resource "kubernetes_cluster_role_binding" "hf_installer" {
  metadata {
    name = "hf-installer"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.hf_installer.metadata[0].name
    namespace = kubernetes_service_account.hf_installer.metadata[0].namespace
  }
}
