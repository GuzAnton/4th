resource "digitalocean_vpc" "project" {
  name     = "project-vpc"
  region   = var.region
  ip_range = "172.20.1.0/24"
}