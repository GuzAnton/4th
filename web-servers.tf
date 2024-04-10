resource "digitalocean_droplet" "web" {
  count = var.droplet_count
  image = var.image
  name = "web-${count.index + 1}"
  region = var.region
  size = var.droplet_size
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  vpc_uuid = digitalocean_vpc.project.id
  tags = ["${var.name}-webserver"]
  lifecycle {
    create_before_destroy = true
  }  
  
}
resource "digitalocean_ssh_key" "default" {
  name       = "Terraform Example"
  public_key = file("D:/System/Users/User-Arch/.ssh/id_rsa.pub")
}