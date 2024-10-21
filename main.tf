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

resource "null_resource" "send_inventory_to_bastion" {
  depends_on = [local_file.inventory]

  provisioner "local-exec" {
    command = <<-EOT
      retries=2
      count=0
      while [ $count -lt $retries ]; do
        scp -o StrictHostKeyChecking=no ${path.module}/Ansible/inventory.txt root@${digitalocean_droplet.bastion.ipv4_address}:${path.module}/4th/Ansible/inventory.txt && break
        count=$((count+1))
        sleep 20
      done
    EOT
  }
}

module "keys_and_certs" {
  source                 = "./modules/certs"
  cert_name              = "ki-cert"
  private_key_path       = "/etc/letsencrypt/live/fourthestate.app-0001/privkey.pem"
  leaf_certificate_path  = "/etc/letsencrypt/live/fourthestate.app-0001/cert.pem"
  certificate_chain_path = "/etc/letsencrypt/live/fourthestate.app-0001/fullchain.pem"
  create_cert            = var.create_cert
}

