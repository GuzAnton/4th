data "template_file" "inventory_template" {
  template = <<-TEMPLATE
[web_servers]
${join("\n", digitalocean_droplet.web.*.ipv4_address_private)}

[db_servers]
${join("\n", digitalocean_droplet.db.*.ipv4_address_private)}

[bastion]
bastion ansible_host=${digitalocean_droplet.bastion.ipv4_address_private} ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa
  TEMPLATE
}

data "cloudflare_zones" "example" {
  filter {
    name = var.domain_name
  }
}
data "external" "cert_dir" {
  program = ["bash", "-c", "cat certificate.env && env"]
}