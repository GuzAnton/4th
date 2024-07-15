data "template_file" "inventory_template" {
  template = <<-TEMPLATE
[server]
${digitalocean_droplet.server.ipv4_address}

[server]
ansible_host=${digitalocean_droplet.server.ipv4_address_private} ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa
  TEMPLATE
}
data "cloudflare_zones" "fourthestate_app" {
  filter {
    name = var.domain_name
  }
}
data "digitalocean_ssh_key" "default" {
  name = "autodeploy_key"
}
data "digitalocean_certificate" "cert" {
  name = "autodeploy-certificate"
}