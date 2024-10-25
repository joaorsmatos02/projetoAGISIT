
# Elemets of the cloud such as virtual servers,
# networks, firewall rules are created as resources
# syntax is: resource RESOURCE_TYPE RESOURCE_NAME
# https://www.terraform.io/docs/configuration/resources.html

###########  Vuecalc   #############
# This method creates as many identical instances as the "count" index value
resource "google_compute_instance" "vuecalc" {
    count = 1
    name = "vuecalc${count.index+1}"
    machine_type = var.GCP_MACHINE_TYPE
    zone = var.GCP_ZONE

    boot_disk {
        initialize_params {
        # image list can be found at:
        # https://console.cloud.google.com/compute/images
        image = "ubuntu-2004-focal-v20240830"
        }
    }

    network_interface {
        network = "default"
        access_config {
        }
    }

    metadata = {
      ssh-keys = "ubuntu:${file("/home/vagrant/.ssh/id_rsa.pub")}"
    }
  tags = ["vuecalc"]
}

###########  Expressed   #############
# This method creates as many identical instances as the "count" index value
resource "google_compute_instance" "expressed" {
    count = 2
    name = "expressed${count.index+1}"
    machine_type = var.GCP_MACHINE_TYPE
    zone = var.GCP_ZONE

    boot_disk {
        initialize_params {
        # image list can be found at:
        # https://console.cloud.google.com/compute/images
        image = "ubuntu-2004-focal-v20240830"
        }
    }

    network_interface {
        network = "default"
        access_config {
        }
    }

    metadata = {
      ssh-keys = "ubuntu:${file("/home/vagrant/.ssh/id_rsa.pub")}"
    }
  tags = ["expressed"]
}

###########  Happy   #############
# This method creates as many identical instances as the "count" index value
resource "google_compute_instance" "happy" {
    count = 2
    name = "happy${count.index+1}"
    machine_type = var.GCP_MACHINE_TYPE
    zone = var.GCP_ZONE

    boot_disk {
        initialize_params {
        # image list can be found at:
        # https://console.cloud.google.com/compute/images
        image = "ubuntu-2004-focal-v20240830"
        }
    }

    network_interface {
        network = "default"
        access_config {
        }
    }

    metadata = {
      ssh-keys = "ubuntu:${file("/home/vagrant/.ssh/id_rsa.pub")}"
    }
  tags = ["happy"]
}


###########  Load Balancer   #############
resource "google_compute_instance" "balancer" {
    name = "balancer"
    machine_type = var.GCP_MACHINE_TYPE
    zone = var.GCP_ZONE

    boot_disk {
        initialize_params {
        # image list can be found at:
        # https://console.cloud.google.com/compute/images
        image = "ubuntu-2004-focal-v20240830"
        }
    }

    network_interface {
        network = "default"
        access_config {
        }
    }

    metadata = {
      ssh-keys = "ubuntu:${file("/home/vagrant/.ssh/id_rsa.pub")}"
    }

  tags = ["balancer"]
}

###########  Bootstorage   #############
resource "google_compute_instance" "bootstorage" {
  count        = 2
  name         = "bootstorage-${count.index + 1}"
  machine_type = var.GCP_MACHINE_TYPE
  zone         = count.index == 0 ? var.GCP_ZONE : var.GCP_ZONE_2  # Bootstorage1 in GCP_ZONE, Bootstorage2 in GCP_ZONE_2

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20240830"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:${file("/home/vagrant/.ssh/id_rsa.pub")}"
  }

  tags = ["bootstorage"]
}


###########  MongoDB   #############
resource "google_compute_instance" "mongodb" {
  count = 1
  name = "mongodb"
  machine_type = var.GCP_MACHINE_TYPE
  zone = var.GCP_ZONE
  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20240830"
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    ssh-keys = "ubuntu:${file("/home/vagrant/.ssh/id_rsa.pub")}"
  }
  tags = ["mongodb"]
}

###########  Prometheus   #############
resource "google_compute_instance" "prometheus" {
    count = 1
    name = "prometheus"
    machine_type = var.GCP_MACHINE_TYPE
    zone = var.GCP_ZONE_2

    boot_disk {
        initialize_params {
        image = "ubuntu-2004-focal-v20240830"
        }
    }

    network_interface {
        network = "default"
        access_config {}
    }

    metadata = {
      ssh-keys = "ubuntu:${file("/home/vagrant/.ssh/id_rsa.pub")}"
    }
  tags = ["prometheus"]
}