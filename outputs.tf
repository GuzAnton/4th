output "srver_public_ip" {
  value = digitalocean_droplet.server.ipv4_address
}
