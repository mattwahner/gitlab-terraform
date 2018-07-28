variable "digital_ocean_token" {}
variable "public_key" {}
variable "private_key" {}
variable "ssh_fingerprint" {}

provider "digitalocean" {
  token = "${var.digital_ocean_token}"
}