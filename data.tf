data "template_file" "inventory_template" {
  template = <<-TEMPLATE
[web_servers]
${join("\n", digitalocean_droplet.web.*.ipv4_address_private)}

[web_servers_public]
${join("\n", digitalocean_droplet.web.*.ipv4_address)}

[db_servers]
${join("\n", digitalocean_droplet.db.*.ipv4_address_private)}

[bastion]
bastion ansible_host=${digitalocean_droplet.bastion.ipv4_address_private} ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa
  TEMPLATE
}
#when working with load balancer we have to add this in TENPLATE section
#[load_balancers]
# ${join("\n", [digitalocean_loadbalancer.web.ip])}

data "cloudflare_zones" "fourthestate_app" {
  filter {
    name = var.domain_name
  }
}