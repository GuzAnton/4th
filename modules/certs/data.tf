data "digitalocean_certificate" "cert" {
  count = var.create_cert ? 0 : 1
  name  = var.cert_name
}