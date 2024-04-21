resource "digitalocean_droplet" "web" {
  count    = var.web_droplet_count
  image    = var.web_image
  name     = "web-${count.index + 1}"
  region   = var.region
  size     = var.web_droplet_size
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  vpc_uuid = digitalocean_vpc.project.id
  tags     = ["${var.name}-webserver"]

  user_data = <<EOF
  packages:
    - nginx
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "digitalocean_droplet" "db" {
  count    = var.db_droplet_count
  image    = var.db_image
  name     = "db-${count.index + 1}"
  region   = var.region
  size     = var.db_droplet_size
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  vpc_uuid = digitalocean_vpc.project.id
  tags     = ["${var.name}-db"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "digitalocean_ssh_key" "default" {
  name       = "Terraform Example"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "digitalocean_loadbalancer" "web" {
  name   = var.LoadBalancer_Name
  region = var.region


  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 8080
    target_protocol = "http"

    certificate_name = digitalocean_certificate.certificate.name
  }
  vpc_uuid               = digitalocean_vpc.project.id
  redirect_http_to_https = true

  lifecycle {
    create_before_destroy = true
  }

  healthcheck {
    port     = 8080
    protocol = "http"
    path     = "/"
  }

  droplet_ids = digitalocean_droplet.web.*.id
}
resource "digitalocean_firewall" "web" {

  #only for internal vpc traffic

  name        = var.FireWall_Name
  droplet_ids = digitalocean_droplet.web.*.id

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
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0"]
  }
}

resource "digitalocean_certificate" "certificate" {
  name = "web-certificate"
  type = "lets_encrypt"
  domains = ["${var.subdomain}.${data.digitalocean_domain.web.name}"]

  lifecycle {
    create_before_destroy = true
  }
}

#Just for testing reson create new domain
# resource "digitalocean_domain" "web" {
#   name       = var.domain_name
#   ip_address = digitalocean_loadbalancer.web.id
# }

resource "digitalocean_record" "web" {
  domain = data.digitalocean_domain.web.name
  type   = "A"
  name   = var.subdomain
  value  = digitalocean_loadbalancer.web.ip
  ttl    = 300
}
