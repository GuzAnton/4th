terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.36"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.39.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.67"
    }
  }
}