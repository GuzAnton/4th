terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.36"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region              = "us-east-1"
  access_key          = var.do_spaces_access_key
  secret_key          = var.do_spaces_secret_key

  endpoints {
    s3 = "https://fra1.digitaloceanspaces.com"
  }
}