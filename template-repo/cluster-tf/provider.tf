provider "google" {
  credentials = file("../../creds/key.json")
  project     = var.project
  region      = var.region
}
provider "google-beta" {
  credentials = file("../../creds/key.json")
  project     = var.project
  region      = var.region
}
