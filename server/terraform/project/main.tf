terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# Obtener la llave SSH
data "digitalocean_ssh_key" "default" {
  name = "Pruebas-DigitalOcean-key"
}

data "digitalocean_vpc" "default" {
  name = "pruebas-network"
}

# Create a new tag
resource "digitalocean_tag" "default" {
  name = "apb"
}

# Create a web server
resource "digitalocean_droplet" "default" {
  name              = "puppet"
  size              = "s-1vcpu-1gb"
  image             = "ubuntu-22-04-x64"
  region            = var.region
  monitoring        = true
  graceful_shutdown = true
  ssh_keys          = [data.digitalocean_ssh_key.default.id]
  user_data         = file(var.do_user_data_file)
  vpc_uuid          = data.digitalocean_vpc.default.id
  tags              = [digitalocean_tag.default.id]
}

resource "digitalocean_monitor_alert" "cpu_alert" {
  alerts {
    email = ["jm.gonzalez1844@uniandes.edu.co"]
    /*
    slack {
      channel   = "Production Alerts"
      url       = "https://hooks.slack.com/services/T1234567/AAAAAAAA/ZZZZZZ"
    }
    */
  }
  window      = "5m"
  type        = "v1/insights/droplet/cpu"
  compare     = "GreaterThan"
  value       = 90
  enabled     = true
  entities    = [digitalocean_droplet.default.id]
  description = "Alert about CPU usage"
}

data "digitalocean_reserved_ip" "default" {
  ip_address = var.reserved_ip_address
}

resource "digitalocean_reserved_ip_assignment" "default" {
  ip_address = data.digitalocean_reserved_ip.default.ip_address
  droplet_id = digitalocean_droplet.default.id
}

resource "digitalocean_firewall" "web" {
  name = "web-22-53-80-443-8080-y-3306-local"

  droplet_ids = [digitalocean_droplet.default.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "8080"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "3306"
    source_addresses = ["127.0.0.1/8", "::1/128"]
  }
  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "tcp"
    port_range            = "3000"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "tcp"
    port_range            = "3306"
    destination_addresses = ["127.0.0.1/8", "::1/128"]
  }
}

data "digitalocean_project" "default" {
  name = "proyecto-pruebas"
}

resource "digitalocean_project_resources" "default" {
  project = data.digitalocean_project.default.id
  resources = [
    digitalocean_droplet.default.urn
  ]
}
