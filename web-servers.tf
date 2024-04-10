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

resource "digitalocean_loadbalancer" "web" {
  name = var.LoadBalancer_Name
  region = var.region
  droplet_ids = digitalocean_droplet.web.*.id
  
  forwarding_rule {
    entry_port = 443
    entry_protocol = "https"
    target_port = 80
    target_protocol = "http"
    
  }
  vpc_uuid = digitalocean_vpc.project.id
  redirect_http_to_https = true
}

resource "digitalocean_firewall" "web" {
  name = var.FireWall_Name

  droplet_ids = digitalocean_droplet.web.*.id
  
    inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["192.168.1.0/24", "2002:1:2::/48"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

}