resource "digitalocean_certificate" "cert" {
  count             = var.create_cert ? 1 : 0
  name              = "autodeploy-certificate"
  private_key       = file("/etc/letsencrypt/live/fourthestate.app/privkey.pem")
  leaf_certificate  = file("/etc/letsencrypt/live/fourthestate.app/cert.pem")
  certificate_chain = file("/etc/letsencrypt/live/fourthestate.app/fullchain.pem")
}