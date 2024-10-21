output "cert_name" {
  value = var.create_cert ? digitalocean_certificate.certificate[0].name : data.digitalocean_certificate.certificate[0].name
}


