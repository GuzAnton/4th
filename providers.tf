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
  access_key          = "${AWS_ACCESS_KEY_ID}"
  secret_key          = "${AWS_SECRET_ACCESS_KEY}"

  endpoints {
    s3 = "https://fra1.digitaloceanspaces.com"
  }
}