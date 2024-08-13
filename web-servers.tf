resource "digitalocean_droplet" "web" {
  count    = var.web_droplet_count
  image    = var.web_image
  name     = "web-${count.index + 1}"
  region   = var.region
  size     = var.web_droplet_size
  ssh_keys = [data.digitalocean_ssh_key.default.id]
  vpc_uuid = digitalocean_vpc.project.id
  tags     = ["${var.name}-web"]

  lifecycle {
    create_before_destroy = true
  }
  connection {
    type        = "ssh"
    host        = self.ipv4_address
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /etc/letsencrypt/live/test.fourthestate.app"
    ]
  }
  depends_on = [digitalocean_vpc.project]
}

resource "digitalocean_droplet" "db" {
  count    = var.db_droplet_count
  image    = var.db_image
  name     = "db-${count.index + 1}"
  region   = var.region
  size     = var.db_droplet_size
  ssh_keys = [data.digitalocean_ssh_key.default.id]
  vpc_uuid = digitalocean_vpc.project.id
  tags     = ["${var.name}-db"]

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [digitalocean_vpc.project]
}

resource "digitalocean_firewall" "web" {

  #only for internal vpc traffic

  name        = var.FireWall_Name_Web
  droplet_ids = digitalocean_droplet.web.*.id

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = [var.MyIP]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "1-65535"
    source_addresses = [digitalocean_vpc.project.ip_range]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "1-65535"
    source_addresses = [digitalocean_vpc.project.ip_range]
  }

  inbound_rule {
    protocol         = "icmp"
    port_range       = "1-65535"
    source_addresses = [digitalocean_vpc.project.ip_range]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = [digitalocean_vpc.project.ip_range]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = [digitalocean_vpc.project.ip_range]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = [digitalocean_vpc.project.ip_range]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "all"
    destination_addresses = ["0.0.0.0/0"]
  }
}

resource "digitalocean_firewall" "db" {

  #only for internal vpc traffic

  name        = var.FireWall_Name_DB
  droplet_ids = digitalocean_droplet.db.*.id

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = [var.MyIP]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "5050"
    source_addresses = ["139.59.153.231"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "1-65535"
    source_addresses = [digitalocean_vpc.project.ip_range]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "1-65535"
    source_addresses = [digitalocean_vpc.project.ip_range]
  }

  inbound_rule {
    protocol         = "icmp"
    port_range       = "1-65535"
    source_addresses = [digitalocean_vpc.project.ip_range]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = [digitalocean_vpc.project.ip_range]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = [digitalocean_vpc.project.ip_range]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = [digitalocean_vpc.project.ip_range]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "all"
    destination_addresses = ["0.0.0.0/0"]
  }
}

resource "cloudflare_record" "project_subdomain" {
  zone_id = lookup(data.cloudflare_zones.fourthestate_app.zones[0], "id")
  name    = var.subdomain
  content   = element(digitalocean_droplet.web.*.ipv4_address, 0)
  type    = "A"
  ttl     = 300
}
terraform {
required_version = ">= 1.6.3"

  backend "s3" {
    endpoints = {
      s3 = "https://fra1.digitaloceanspaces.com"
    }

    bucket = "fe-autodeploy-01"
    key    = "test10/state/terraform.tfstate"

    # Deactivate a few AWS-specific checks
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
    region                      = "us-east-1"
  }
}