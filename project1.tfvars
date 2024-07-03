variable "cert_name" {
  default = "fourthestate-app-cert-1"
}
variable "vpc_name" {
  description = "Name of current VPC"
  default = "project-vpc-1"
}
variable "vpc_range" {
  default = "172.20.2.0/24"  
}
variable "ssh_key_name" {
  default = "key-1"
}