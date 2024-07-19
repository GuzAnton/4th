provider "digitalocean" {
  token = var.do_token
}

provider "cloudflare" {
  api_token = var.cf_api_token
}

resource "local_file" "inventory" {
  filename = "${path.module}/Ansible/inventory.txt"
  content  = data.template_file.inventory_template.rendered
}
resource "null_resource" "copy_ssl_certificates" {
  depends_on = [digitalocean_droplet.server]

  provisioner "local-exec" {
    command = "ssh -o StrictHostKeyChecking=no root@${digitalocean_droplet.server.ipv4_address} 'mkdir -p /etc/letsencrypt/live/test.fourthestate.app/'"
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no /etc/letsencrypt/live/fourthestate.app/*.pem root@${digitalocean_droplet.bastion.ipv4_address}:/etc/letsencrypt/live/test.fourthestate.app/"
  }
}