output "web_servers_private" {
    value = digitalocean_droplet.web.*.ipv4_address_private
}