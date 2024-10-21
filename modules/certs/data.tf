# data "digitalocean_certificate" "certificate" {
#   count = var.create_cert ? 0 : 1
#   name  = var.cert_name
# }

# Data source to check if the certificate already exists
data "digitalocean_certificate" "existing" {
  name = var.cert_name
}