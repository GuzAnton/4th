output "bastion_public_ip" {
  value = digitalocean_droplet.bastion.ipv4_address
}
# output "LoadBalancer_ip" {
#   value = digitalocean_loadbalancer.web.ip
# }
output "web_servers_private_ips" {
  value = digitalocean_droplet.web.*.ipv4_address_private
}

output "db_server_private_ips" {
  value = digitalocean_droplet.db.*.ipv4_address_private
}

output "bastion_private_ip" {
  value = digitalocean_droplet.bastion.ipv4_address_private
}
output "web_public_ip" {
  value = digitalocean_droplet.web.*.ipv4_address
}
output "db_public_ip"{
  value = digitalocean_droplet.db.*.ipv4_address
}