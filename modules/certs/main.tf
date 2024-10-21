resource "digitalocean_certificate" "certificate" {
  count             = var.create_cert ? 1 : 0
  name              = var.cert_name
  private_key       = file(var.private_key_path)
  leaf_certificate  = file(var.leaf_certificate_path)
  certificate_chain = file(var.certificate_chain_path)
}

