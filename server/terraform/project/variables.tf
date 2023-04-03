# La primera esta vacia aqui pero tiene valor en terraform.tfvars (Archivo que debe meterse en el .gitignore)
# do_token            = "<TOKEN>"

variable "do_token" {}

variable "do_ssh_pub_key_file" {
  default = "../../../secure/do_rsa.pub"
}

variable "do_user_data_file" {
  default = "../../../secure/terramino.yml"
}

variable "region" {
  default = "nyc3"
}

variable "domain" {
  default = "museos.website"
}

# Este se toma del output de foundation
variable "reserved_ip_address" {
  default = "138.197.52.4"
}
