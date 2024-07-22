variable "region" {
  default = "fra1"
}
variable "do_token" {
  type = string
}
variable "cf_api_token" {
  type = string
}
variable "web_droplet_count" {
  default = 1
}
variable "db_droplet_count" {
  default = 1
}
variable "name" {
  description = "Project name"
  default     = "Fourth_Estate"
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
  default = "s-2vcpu-2gb"
}
variable "domain_name" {
  type    = string
  default = "fourthestate.app"
}
variable "subdomain" {
  type    = string
  default = "test10"
}
variable "LoadBalancer_Name" {
  default = "web10"
}
variable "FireWall_Name_Web" {
  default = "web10"
}
variable "FireWall_Name_DB" {
  default = "db10"
}
variable "Bastion_firewall_name" {
  default = "bastion10"
}
variable "MyIP" {
  default = "164.92.190.148"
}
variable "vpc_name" {
  description = "Name of current VPC"
  default     = "project-vpc10"
}
variable "vpc_range" {
  default = "172.20.10.0/24"
}
variable "private_key_path" {
  description = "Path to the private key file"
  default     = "/etc/letsencrypt/live/fourthestate.app/privkey.pem"
}
variable "cert_path" {
  description = "Path to the certificate file"
  default     = "/etc/letsencrypt/live/fourthestate.app/cert.pem"
}
variable "chain_path" {
  description = "Path to the certificate chain file"
  default     = "/etc/letsencrypt/live/fourthestate.app/fullchain.pem"
}