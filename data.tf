data "template_file" "inventory_template" {
  template = <<-TEMPLATE
[web_servers]
${join("\n", digitalocean_droplet.web.*.ipv4_address_private)}

[web_servers_public]
${join("\n", digitalocean_droplet.web.*.ipv4_address)}

[db_servers]
${join("\n", digitalocean_droplet.db.*.ipv4_address_private)}

[mysql_cluster]
${join("\n", [for cluster in digitalocean_database_cluster.mysql_ki_cluster : "mysql_primary ansible_host=${cluster.host} ansible_port=${cluster.port} ansible_user=${cluster.user} ansible_password=${cluster.password}"])}


[bastion]
bastion ansible_host=${digitalocean_droplet.bastion.ipv4_address_private} ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa
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
data "digitalocean_vpc" "ki_vpc" {
  name = "default-ams3"
}