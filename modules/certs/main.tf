# resource "digitalocean_certificate" "cert" {
#   name              = "autodeploy-certificate"
#   private_key       = file("/etc/letsencrypt/live/fourthestate.app/privkey.pem")
#   leaf_certificate  = file("/etc/letsencrypt/live/fourthestate.app/cert.pem")
#   certificate_chain = file("/etc/letsencrypt/live/fourthestate.app/fullchain.pem")
# }
resource "digitalocean_certificate" "cert" {
  count             = var.create_cert ? 1 : 0
  name              = var.cert_name
  private_key       = file(var.private_key_path)
  leaf_certificate  = file(var.leaf_certificate_path)
  certificate_chain = file(var.certificate_chain_path)
}
