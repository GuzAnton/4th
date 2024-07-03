variable "cert_name" {
  default = "fourthestate-app-cert-2"
}
variable "vpc_name" {
  description = "Name of current VPC"
  default = "project-vpc-2"
}
variable "vpc_range" {
  default = "172.20.3.0/24"  
}
variable "ssh_key_name" {
  default = "key-3"
}