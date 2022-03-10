output "docker_ip_db" {
  value = docker_container.db.ip_address
}
output "docker_ip_php" {
  value = docker_container.php.ip_address
}
output "docker_volume" {
  value = docker_volume.db_data.driver_opts.device
}
