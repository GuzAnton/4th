resource "digitalocean_droplet" "bastion" {

  image    = var.bastion_image
  name     = "Bastion"
  region   = var.region
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  vpc_uuid = digitalocean_vpc.project.id
  tags     = ["${var.name}-bastion"]

  provisioner "remote-exec" {
    inline = [
      "git clone https://github.com/GuzAnton/4th.git"
    ]
  }

  lifecycle {
    create_before_destroy = true
  }
  user_data = <<EOF
  #cloud-config
  packages:
    - ansible
  EOF
}

resource "digitalocean_firewall" "bastion" {
  name        = var.Bastion_firewall_name
  droplet_ids = [digitalocean_droplet.bastion.id]
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = [var.MyIP]
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
  outbound_rule {
    protocol              = "tcp"
    port_range            = "all"
    destination_addresses = ["0.0.0.0/0"]
  }
}
resource "null_resource" "generate_ssh_key" {
  depends_on = [digitalocean_droplet.bastion]

  provisioner "remote-exec" {
    inline = [
      "ssh-keygen -t rsa -b 4096 -C 'bastion' -f ~/.ssh/id_rsa -N ''"
    ]

    connection {
      type     = "ssh"
      user     = "root"
      private_key = file("~/.ssh/id_rsa")
      host     = digitalocean_droplet.bastion.ipv4_address
    }
  }
}
resource "null_resource" "copy_ssh_key_from_bastion" {
  provisioner "local-exec" {
    command = <<-EOT
      retries=2
      count=0
      while [ $count -lt $retries ]; do
        scp -o StrictHostKeyChecking=no root@${digitalocean_droplet.bastion.ipv4_address}:~/.ssh/id_rsa.pub ~/.ssh/bastion_id_rsa.pub && break
        count=$((count+1))
        sleep 20
      done
    EOT
  }
}

# resource "null_resource" "copy_ssh_key_from_bastion" {
#   provisioner "local-exec" {
#     command = "scp -o StrictHostKeyChecking=no root@${digitalocean_droplet.bastion.ipv4_address}:~/.ssh/id_rsa.pub ~/.ssh/bastion_id_rsa.pub"
#   }
# }

resource "null_resource" "copy_ssh_key_to_web" {
  for_each = { for idx, instance in digitalocean_droplet.web : idx => instance.ipv4_address }

  depends_on = [null_resource.copy_ssh_key_from_bastion]

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no ~/.ssh/bastion_id_rsa.pub root@${each.value}:~/.ssh/authorized_keys"
  }
}

resource "null_resource" "copy_ssh_key_to_db" {
  for_each = { for idx, instance in digitalocean_droplet.db : idx => instance.ipv4_address }

  depends_on = [null_resource.copy_ssh_key_from_bastion]

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no ~/.ssh/bastion_id_rsa.pub root@${each.value}:~/.ssh/authorized_keys"
  }
}
