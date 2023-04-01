# https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs
# https://docs.digitalocean.com/reference/api/create-personal-access-token/
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_ssh_key" "default" {
  name       = "Terraform-DigitalOcean-key"
  public_key = file(var.do_ssh_pub_key_file)
}

resource "digitalocean_vpc" "default" {
  name     = "showcase-network"
  region   = var.region
  ip_range = "10.10.11.0/24"
}

resource "digitalocean_reserved_ip" "default" {
  region = var.region
}

resource "digitalocean_project" "default" {
  name        = "proyecto-museos"
  description = "Un proyecto web del curso: Conceptos básicos de ingeniería de software para la web."
  purpose     = "Web Application"
  environment = "Development"
}
