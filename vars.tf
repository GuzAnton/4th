variable "region" {
  default = "fra1"
}
variable "do_token" {}
variable "web_droplet_count" {
  default = 1
}
variable "db_droplet_count" {
  default = 1
}
variable "name" {
  default = "Fourth_Estate"
}
variable "web_image" {
  default = "ubuntu-20-04-x64"
}
variable "bastion_image" {
  default = "ubuntu-20-04-x64"
}
variable "db_image" {
  default = "ubuntu-20-04-x64"
}
variable "web_droplet_size" {
  default = "s-1vcpu-1gb"
}
variable "db_droplet_size" {
  default = "s-1vcpu-1gb"
}
variable "domain_name" {
  type    = string
  default = "fourthestate.app"
}
variable "subdomain" {
  type    = string
  default = "@"
}
variable "LoadBalancer_Name" {
  default = "web"
}
variable "FireWall_Name_Web" {
  default = "web"
}

variable "FireWall_Name_DB" {
  default = "db"
}
variable "Bastion_firewall_name" {
  default = "bastion"
}
variable "MyIP" {
  default = "176.36.180.171"
}
