variable "region" {
  default = "ams3"
}
variable "do_token" {
  type      = string
  sensitive = true
}
variable "cf_api_token" {
  type      = string
  sensitive = true
}
variable "web_droplet_count" {
  default = 2
}
variable "db_droplet_count" {
  default = 1
}
# variable "cluster_node_count" {
#   default = 2
# }
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
# variable "cluster_image" {
#   default = "ubuntu-20-04-x64"
# }
variable "web_droplet_size" {
  default = "s-1vcpu-2gb"
}
# variable "cluster_size" {
#   default = "db-s-1vcpu-1gb"
# }
variable "db_droplet_size" {
  default = "s-2vcpu-2gb"
}
variable "domain_name" {
  type    = string
  default = "fourthestate.app"
}
variable "subdomain" {
  type    = string
  default = "test1"
}
variable "LoadBalancer_Name" {
  default = "web1"
}
variable "FireWall_Name_Web" {
  default = "web1"
}

variable "FireWall_Name_DB" {
  default = "db1"
}
variable "Bastion_firewall_name" {
  default = "bastion1"
}

variable "MyIP" {
  default = "164.92.190.148"
}

# variable "vpc_name" {
#   default = "project-vpc1"
# }
# variable "vpc_range" {
#   default = "172.20.1.0/24"
# }
variable "create_cert" {
  type    = bool
  default = true
}