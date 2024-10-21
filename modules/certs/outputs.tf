# output "cert_name" {
#   value = var.create_cert ? digitalocean_certificate.certificate[0].name : data.digitalocean_certificate.certificate[0].name
# }

output "cert_name" {
  value = var.create_cert && length(data.digitalocean_certificate.existing) == 0 ? digitalocean_certificate.certificate[0].name : data.digitalocean_certificate.existing.name
}
