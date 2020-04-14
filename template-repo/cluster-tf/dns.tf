resource "google_dns_record_set" "core" {
  name = "${local.cluster_name}.${data.google_dns_managed_zone.sharpwit.dns_name}"
  type = "A"
  ttl  = 300
  managed_zone = data.google_dns_managed_zone.sharpwit.name
  rrdatas = [google_compute_address.static.address]
}

data "google_dns_managed_zone" "sharpwit" {
  name = var.managed_zone_name
}
