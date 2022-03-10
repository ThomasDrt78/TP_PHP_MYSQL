variable "ssh_host" {}

variable "ssh_user" {}

variable "ssh_key" {}

variable "ssh_password" {}

variable "php_port" {}

module "docker_install" {
  source       = "./modules/docker_install"
  ssh_host     = var.ssh_host
  ssh_user     = var.ssh_user
  ssh_password = var.ssh_password
  ssh_key      = var.ssh_key
}

module "docker_run" {
  source       = "./modules/docker_run"
  ssh_host     = var.ssh_host
  ssh_user     = var.ssh_user
  ssh_password = var.ssh_password
  ssh_key      = var.ssh_key
}


module "docker_php" {
  source 		= "./modules/docker_php"
  ssh_host		= var.ssh_host
  ssh_user 	  	= var.ssh_user
  ssh_key  		= var.ssh_key
  ssh_password          = var.ssh_password
  php_port	        = var.php_port
}

output "docker_ip_db" {
  value = module.docker_php.docker_ip_db
}
output "docker_ip_php" {
  value = module.docker_php.docker_ip_php
}
output "docker_volume" {
  value = module.docker_php.docker_volume
}
