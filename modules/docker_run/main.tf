terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}

resource "docker_network" "dockernet" {
   name = "Nginx"
}
provider "docker" {
  host = "tcp://${var.ssh_host}:2375"
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}
resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "nginx"
  ports {
    internal = 80
    external = 81
  }
  networks_advanced {
	name = docker_network.dockernet.name
  }
}
