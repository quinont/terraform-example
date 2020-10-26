resource "tls_private_key" "sshkey" {
  algorithm   = "RSA"
  ecdsa_curve = "P384"
}

resource "local_file" "private_key_file" {
  content         = tls_private_key.sshkey.private_key_pem
  file_permission = "0600"
  filename        = "${path.module}/private_key"
}

resource "random_id" "instance_id" {
  byte_length = 3
}

data "template_file" "startup_script" {
  template = file("${path.module}/startup_script.sh")
  vars = {
    MENSAJE = "Hola desde una instancia de gcp test!"
  }
}

resource "google_compute_instance" "server" {
  name         = "flask-vm-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata_startup_script = data.template_file.startup_script.rendered

  network_interface {
    network = var.network_vpc

    access_config {
    }
  }

  tags = ["webserver"]

  metadata = {
    ssh-keys = "usuario:${tls_private_key.sshkey.public_key_openssh}"
  }
}

resource "google_compute_firewall" "access_to_5000" {
  name    = "access-to-web-server"
  network = var.network_vpc

  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }

  source_tags = ["webserver"]
}
