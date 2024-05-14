resource "digitalocean_droplet" "bastion" {

  image    = var.bastion_image
  name     = "Bastion"
  region   = var.region
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  vpc_uuid = digitalocean_vpc.project.id
  tags     = ["${var.name}-bastion"]

  lifecycle {
    create_before_destroy = true
  }
  user_data = <<EOF
  #cloud-config
  packages:
    - ansible
  #!/bin/bash
    echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
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
    command = "scp root@${digitalocean_droplet.bastion.ipv4_address}:~/.ssh/id_rsa.pub ~/.ssh/bastion_id_rsa.pub"
  }
}

resource "null_resource" "copy_ssh_key_to_web" {
  for_each = toset(digitalocean_droplet.web[*].ipv4_address)

  depends_on = [null_resource.copy_ssh_key_from_bastion]

  provisioner "local-exec" {
    command = "ssh root@${each.value} 'echo \"$(cat ~/.ssh/bastion_id_rsa.pub)\" >> ~/.ssh/authorized_keys'"
  }
}

resource "null_resource" "copy_ssh_key_to_db" {
  for_each = toset(digitalocean_droplet.db[*].ipv4_address)

  depends_on = [null_resource.copy_ssh_key_from_bastion]

  provisioner "local-exec" {
    command = "ssh root@${each.value} 'echo \"$(cat ~/.ssh/bastion_id_rsa.pub)\" >> ~/.ssh/authorized_keys'"
  }
}

# resource "null_resource" "configure_ssh" {
#   # Этот ресурс используется только для настройки SSH.
#   # Он не создает новый ресурс, но может выполнять команды локально
#   # после создания других ресурсов.

#   # Возможность обновлять SSH конфигурацию после создания других ресурсов.
#   triggers = {
#     always_run = "${timestamp()}"
#   }

#   # Провиженеры, которые будут выполняться после создания других ресурсов.
#   provisioner "local-exec" {
#     command = <<-EOT
#       # Создаем временный файл с конфигурацией SSH.
#       echo "StrictHostKeyChecking no" > ~/.ssh/temp_config
      
#       # Копируем временный файл конфигурации SSH на все серверы веб.
#       ${join("\n", formatlist("scp -i /path/to/private/key ~/.ssh/temp_config root@%s:~/.ssh/config", digitalocean_droplet.web[*].ipv4_address))}
      
#       # Копируем временный файл конфигурации SSH на все серверы баз данных.
#       ${join("\n", formatlist("scp -i /path/to/private/key ~/.ssh/temp_config root@%s:~/.ssh/config", digitalocean_droplet.db[*].ipv4_address))}
      
#       # Копируем временный файл конфигурации SSH на сервер бастиона.
#       scp -i /path/to/private/key ~/.ssh/temp_config root@${digitalocean_droplet.bastion.ipv4_address}:~/.ssh/config
      
#       # Удаляем временный файл конфигурации SSH.
#       rm -f ~/.ssh/temp_config
#     EOT
#   }
# }
