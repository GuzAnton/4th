resource "digitalocean_droplet" "web" {
  count    = var.web_droplet_count
  image    = var.web_image
  name     = "web-${count.index + 1}"
  region   = var.region
  size     = var.web_droplet_size
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  vpc_uuid = digitalocean_vpc.project.id
  tags     = ["${var.name}-web"]

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
  name       = "key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "digitalocean_loadbalancer" "web" {
  name   = var.LoadBalancer_Name
  region = var.region


  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"
    target_port      = 80
    target_protocol  = "http"
    certificate_name = digitalocean_certificate.cert.name

  }
  # healthcheck {
  #   port                     = 80
  #   protocol                 = "http"
  #   path                     = "/"
  #   check_interval_seconds   = 10
  #   response_timeout_seconds = 5
  #   unhealthy_threshold      = 5
  #   healthy_threshold        = 2
  # }

  droplet_ids = digitalocean_droplet.web.*.id
  vpc_uuid               = digitalocean_vpc.project.id
  redirect_http_to_https = true
  lifecycle {
    create_before_destroy = true
  }
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
    protocol = "tcp"
    port_range = "5050"
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
resource "digitalocean_certificate" "cert" {
  name              = "fourthestate-app-cert"
  private_key       = file("/etc/letsencrypt/live/fourthestate.app/privkey.pem")
  leaf_certificate  = file("/etc/letsencrypt/live/fourthestate.app/cert.pem")
  certificate_chain = file("/etc/letsencrypt/live/fourthestate.app/fullchain.pem")
}