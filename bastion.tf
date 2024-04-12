resource "digitalocean_droplet" "bastion" {

  image    = var.bastion_image
  name     = "Bastion"
  region   = var.region
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  vpc_uuid = digitalocean_vpc.project.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "digitalocean_firewall" "bastion" {
  name        = var.Bastion_firewall_name
  droplet_ids = [digitalocean_droplet.bastion.id]
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }
  outbound_rule {
    protocol              = "tcp"
    port_range            = "22"
    destination_addresses = [digitalocean_vpc.project.ip_range]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = [digitalocean_vpc.project.ip_range]
  }
}