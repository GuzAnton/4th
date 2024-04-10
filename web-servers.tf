resource "digitalocean_droplet" "web" {
  count = var.droplet_count
  image = var.image
  name = "web-${var.name}-${count.index + 1}"
  region = var.region
  size = var.droplet_size
  ssh_keys = //
  vpc_uuid = digitalocean_vpc.project.id
  tags = ["${var.name}-webserver"]
  lifecycle {
    create_before_destroy = true
  }  
}