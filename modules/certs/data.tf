data "digitalocean_certificate" "ki_cert" {
  count = var.create_cert ? 0 : 1
  name  = var.cert_name
}