output "web_servers_private" {
  value = digitalocean_droplet.web.*.ipv4_address_private
}
output "web_server_private" {
  value = digitalocean_droplet.db.*.ipv4_address_private
}