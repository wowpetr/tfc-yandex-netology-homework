provider "yandex" {
  token         = var.provider_token 
  cloud_id      = var.provider_cloud_id
  folder_id     = var.provider_folder_id
  zone          = "ru-central1-a"
}

module "instance" {
  source = "./modules/instance"

  subnet_id     = module.vpc.subnet_ids[0]
  zone          = "ru-central1-a"
  folder_id     = var.provider_folder_id
  image         = "debian-11"
  platform_id   = "standard-v3"
  name          = "vm-1"
  users         = "wp"
  ssh_key       = var.ssh_public_key
  cores         = local.cores[terraform.workspace]
  boot_disk     = "network-ssd"
  disk_size     = local.disk_size[terraform.workspace]
  nat           = "true"
  memory        = "2"
  core_fraction = "100"
  depends_on = [
    module.vpc
  ]
}

module "vpc" {
  source  = "github.com/hamnsk/terraform-yandex-vpc?ref=master"
  create_folder = false
  yc_folder_id = var.provider_folder_id
  name = terraform.workspace
  subnets = local.vpc_subnets[terraform.workspace]
}

locals {
  cores = {
    default = 2
    plosev-netology-workspace = 2
  }
  disk_size = {
    default = 10
    plosev-netology-workspace  = 10
  }
  instance_count = {
    default = 1
    plosev-netology-workspace  = 1
  }
  vpc_subnets = {
    default = [
      {
        zone            = "ru-central1-a"
        v4_cidr_blocks  = ["10.0.1.0/28"]
      }
    ]
    plosev-netology-workspace = [
      {
        zone            = "ru-central1-a"
        v4_cidr_blocks  = ["10.0.1.0/28"]
      }
    ]
  }
}

/*
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
*/