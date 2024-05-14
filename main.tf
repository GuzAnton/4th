provider "digitalocean" {
  token = var.do_token
}

resource "local_file" "inventory" {
  filename = "${path.module}/Ansible/inventory.txt"
  content  = data.template_file.inventory_template.rendered
}

resource "null_resource" "send_inventory_to_bastion" {
  depends_on = [local_file.inventory]

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no ${path.module}/Ansible/inventory.txt root@${digitalocean_droplet.bastion.ipv4_address}:${path.module}/Ansible/inventory.txt"
  }
}
