output "ip" {
  value = google_compute_instance.server.network_interface.0.access_config.0.nat_ip
}

output "vm_private_key" {
  value     = tls_private_key.sshkey.private_key_pem
  sensitive = true
}

output "vm_public_key" {
  value = tls_private_key.sshkey.public_key_openssh
}

