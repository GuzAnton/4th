# output "cert_name" {
#   value = digitalocean_certificate.cert.name
# }
output "cert_name" {
  value = var.create_cert ? digitalocean_certificate.cert[0].name : data.digitalocean_certificate.cert[0].name
}