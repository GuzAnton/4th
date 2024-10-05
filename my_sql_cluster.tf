resource "digitalocean_database_cluster" "mysql__ki_cluster" {
  name       = "mysql_ki_cluster"
  engine     = "mysql"
  version    = "8"
  size       = var.cluster_size
  region     = var.region
  node_count = var.cluster_node_count
}
resource "digitalocean_database_firewall" "mysql_ki_firewall" {
  cluster_id = digitalocean_database_cluster.mysql__ki_cluster.id

  rule {
    type  = "tag"
    value = "${var.name}-web"
  }
  rule {
    type = "tag"
    value = "${var.name}-db"
  }
  rule {
    type  = "ip_addr"
    value = digitalocean_droplet.bastion.ipv4_address_private
  }
}
