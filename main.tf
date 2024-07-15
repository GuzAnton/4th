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
