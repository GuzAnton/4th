terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.36"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

  module "keys_and_certs" {
  source = "./modules/keys_and_certs"

  providers = {
    digitalocean = digitalocean.digitalocean
  }

}