variable "cert_name" {
  description = "The name of the DigitalOcean certificate."
  type        = string
  default = "ki-cert"
}

variable "private_key_path" {
  description = "The path to the private key file."
  type        = string
}

variable "leaf_certificate_path" {
  description = "The path to the leaf certificate file."
  type        = string
}

variable "certificate_chain_path" {
  description = "The path to the certificate chain file."
  type        = string
}
variable "create_cert" {
  description = "Flag to indicate whether to create the certificate or not"
  type        = bool
  default     = true
}