resource "null_resource" "ssh_target" {
  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file(var.ssh_key)
    password    = var.ssh_password
  }
  provisioner "file" {
    source      = "index.html"
    destination = "/tmp/index.html"
  }
  provisioner "remote-exec" {
    inline = [
      "echo ${var.ssh_password} | sudo -S mkdir -p /srv/php/",
      "echo ${var.ssh_password} | sudo -S chmod 777 -R /srv/php/",
      "sleep 5s"
    ]
  }
}

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}

provider "docker" {
  host = "tcp://${var.ssh_host}:2375"
}

resource "docker_network" "appnet" {
  name = "app_net"
}

resource "docker_volume" "db_data" {
  name = "db_data"
  driver = "local"
  driver_opts = {
    o = "bind"
    type = "none"
    device = "/srv/php/"
  }
  depends_on = [ null_resource.ssh_target ] 
}

resource "docker_container" "db" {
  name  = "db"
  image = "mysql:5.7"
  restart = "always"
  network_mode = "app_net"
  env = [
     "MYSQL_ROOT_PASSWORD=php",
     "MYSQL_PASSWORD=php",
     "MYSQL_USER=php",
     "MYSQL_DATABASE=php"
  ]
  networks_advanced {
    name = docker_network.appnet.name
  }
  volumes {
    host_path = "/srv/php/"
    container_path = "/var/lib/mysql/"
    volume_name = "db_data"
  }
}

resource "docker_container" "php" {
  name  = "php"
  image = "formationsk8s/tp_php_mysql:latest"
  restart = "always"
  networks_advanced {
    name = docker_network.appnet.name
  }
  env = [
    "MYSQL_HOST=php",
    "MYSQL_PORT=8080",
    "MYSQL_USER=php",
    "MYSQL_PASSWORD=php",
    "MYSQL_DB=php"
  ]
  ports {
    internal = 80
    external = var.php_port
  }
}
