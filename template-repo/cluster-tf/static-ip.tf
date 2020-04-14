resource "google_compute_address" "static" {
  provider = google-beta
  name = "load-balancer-${var.cluster_number}"
  address_type = "EXTERNAL"
  labels = {
    "owner": "kyounger"
  }
}
