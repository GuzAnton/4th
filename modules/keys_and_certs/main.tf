provider "digitalocean" {
  token = var.do_token
}
resource "digitalocean_ssh_key" "default" {
  name       = var.ssh_key_name
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "digitalocean_certificate" "cert" {
  name              = var.cert_name
  private_key       = file("/etc/letsencrypt/live/fourthestate.app/privkey.pem")
  leaf_certificate  = file("/etc/letsencrypt/live/fourthestate.app/cert.pem")
  certificate_chain = file("/etc/letsencrypt/live/fourthestate.app/fullchain.pem")
}

output "ssh_key_id" {
  value = digitalocean_ssh_key.default.id
}

output "certificate_id" {
  value = digitalocean_certificate.cert.id
}

