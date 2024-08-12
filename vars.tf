variable "region" {
  default = "fra1"
}
variable "do_token" {
  type = string
}
variable "cf_api_token" {
  type = string
}
variable "name" {
  description = "Project name"
  default     = "Fourth_Estate"
}
variable "server_image" {
  default = "ubuntu-20-04-x64"
}
variable "server_size" {
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
variable "Firewall_name" {
  default = "server-firewall10"
}
variable "MyIP" {
  default = "164.92.190.148"
}
variable "vpc_name" {
  description = "Name of current VPC"
  default     = "project-vpc10"
}
variable "vpc_range" {
  default = "172.20.1.0/24"
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
