variable "region" {
  default = "fra1"
}
variable "do_token" {}

variable "droplet_count" {
  default = 2
}

variable "name" {
  default = "Fourth_Estate"
}

variable "image" {
  default = "ubuntu-20-04-x64"
}

variable "droplet_size" {
  default = "s-1vcpu-1gb"
}

variable "domain_name" {
  type = string
}

variable "subdomain" {
  type = string
}

variable "LoadBalancer_Name" {
  default = "web"
}

variable "FireWall_Name" {
  default = "web"
}