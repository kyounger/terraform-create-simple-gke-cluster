locals {
  cluster_name = "kyounger${var.cluster_number}"
}

resource "google_container_cluster" "primary" {
  name               = local.cluster_name
  location           = var.zone
  remove_default_node_pool = true
  initial_node_count = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }

  }

  # Setup kubectl with current context of new cluster
  provisioner "local-exec" {
    command = "KUBECONFIG=../tf-kubeconfig-${local.cluster_name}.yaml gcloud container clusters get-credentials ${local.cluster_name} --zone ${google_container_cluster.primary.location} --project ${var.project}"
  }
}

resource "google_container_node_pool" "primary" {
  name       = "primary"
  location   = google_container_cluster.primary.location
  cluster    = google_container_cluster.primary.name
  node_count = 4

  node_config {
    preemptible  = false
    machine_type = "n1-standard-4"
    disk_size_gb = "30"
    disk_type    = "pd-ssd"

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

