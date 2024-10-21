output "cert_name" {
  value = var.create_cert ? digitalocean_certificate.ki_cert[0].name : data.digitalocean_certificate.ki_cert[0].name
}