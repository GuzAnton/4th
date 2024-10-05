output "bastion_public_ip" {
  value = digitalocean_droplet.bastion.ipv4_address
}
output "web_servers_private_ips" {
  value = digitalocean_droplet.web.*.ipv4_address_private
}
# output "db_server_private_ips" {
#   value = digitalocean_droplet.db.*.ipv4_address_private
# }
output "web_public_ip" {
  value = digitalocean_droplet.web.*.ipv4_address
}
output "mysql_cluster_host" {
  value = digitalocean_database_cluster.mysql_ki_cluster.host
}
output "mysql_cluster_port" {
  value = digitalocean_database_cluster.mysql_ki_cluster.port
}

output "mysql_cluster_user" {
  value     = digitalocean_database_cluster.mysql_ki_cluster.user
  sensitive = true
}

output "mysql_cluster_password" {
  value     = digitalocean_database_cluster.mysql_ki_cluster.password
  sensitive = true
}