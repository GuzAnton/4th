resource "digitalocean_droplet" "server" {

  image    = var.server_image
  name     = "${var.subdomain}-server"
  region   = var.region
  size     = var.server_size
  ssh_keys = [data.digitalocean_ssh_key.default.id]
  vpc_uuid = digitalocean_vpc.project.id
  tags     = ["${var.subdomain}-server"]


  lifecycle {
    create_before_destroy = true
  }
  user_data = <<EOF
  #cloud-config
  packages:
    - ansible
  EOF

  connection {
    type        = "ssh"
    host        = self.ipv4_address
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "git clone https://github.com/GuzAnton/4th.git ~/4th",
      "mkdir -p /root/4th/Ansible/group_vars/all"
    ]
  }
}

resource "digitalocean_firewall" "server" {
  name        = var.Firewall_name
  droplet_ids = [digitalocean_droplet.server.id]
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = [var.MyIP, "68.183.69.38"]
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
    protocol         = "tcp"
    port_range       = "5050"
    source_addresses = ["139.59.153.231"]
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
  value   = digitalocean_droplet.server.ipv4_address
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