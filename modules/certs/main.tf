resource "digitalocean_certificate" "cert" {
  name              = "autodeploy-certificate"
  private_key       = file("/etc/letsencrypt/live/fourthestate.app/privkey.pem")
  leaf_certificate  = file("/etc/letsencrypt/live/fourthestate.app/cert.pem")
  certificate_chain = file("/etc/letsencrypt/live/fourthestate.app/fullchain.pem")
}