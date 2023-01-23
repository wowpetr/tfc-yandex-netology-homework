terraform {

  cloud {
    organization = "plosev-netology-homework"

    workspaces {
      name = "plosev-netology-workspace"
    }
  }

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  required_version = ">= 0.74"
}