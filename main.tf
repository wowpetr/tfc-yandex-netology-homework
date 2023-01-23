provider "yandex" {
  token         = var.provider_token 
  cloud_id      = var.provider_cloud_id
  folder_id     = var.provider_folder_id
  zone          = "ru-central1-a"
}

resource "yandex_compute_instance" "vm-1" {
  name          = "vm-1"
  platform_id   = "standard-v3"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd85jf9kn9r40o1neolo" # debian-11-v20220509
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
  }

  metadata = {
    user-data = "${file("./meta.txt")}" 
  }
}

resource "yandex_vpc_network" "vpc-1" {
}

resource "yandex_vpc_subnet" "subnet-1" {
  network_id        = yandex_vpc_network.vpc-1.id
  v4_cidr_blocks    = ["10.0.1.0/28"]
}