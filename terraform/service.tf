terraform {
    required_providers {
        yandex = {
            source = "yandex-cloud/yandex"
        }
    }
}

provider "yandex" {
    token     = ""
    cloud_id  = ""
    folder_id = ""
    zone      = "ru-central1-a"
}



# resource "yandex_vpc_network" "default" {}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "hw2-network"
  zone           = "ru-central1-a"
  network_id     = ""
  v4_cidr_blocks = ["10.0.0.0/24"]
}



resource "yandex_compute_instance" "db" {
  name = "db"
  hostname = "db"

  resources {
    cores  = 2
    memory = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk"
      size     = 13
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = file("./meta.txt")
  }
}

output "external_ip_address_db" {
  value = yandex_compute_instance.db.network_interface.0.nat_ip_address
}

output "internal_ip_address_db" {
  value = yandex_compute_instance.db.network_interface.0.ip_address
}



resource "yandex_compute_instance" "app" {
  name = "app"
  hostname = "app"

  resources {
    cores  = 2
    memory = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk"
      size     = 13
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = file("./meta.txt")
  }
}

output "external_ip_address_app" {
  value = yandex_compute_instance.app.network_interface.0.nat_ip_address
}

output "internal_ip_address_app" {
  value = yandex_compute_instance.app.network_interface.0.ip_address
}



resource "yandex_compute_instance" "app2" {
  name = "app2"
  hostname = "app2"

  resources {
    cores  = 2
    memory = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk"
      size     = 13
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = file("./meta.txt")
  }
}

output "external_ip_address_app2" {
  value = yandex_compute_instance.app2.network_interface.0.nat_ip_address
}

output "internal_ip_address_app2" {
  value = yandex_compute_instance.app2.network_interface.0.ip_address
}



resource "yandex_compute_instance" "nginx" {
  name = "nginx"
  hostname = "nginx"

  resources {
    cores  = 2
    memory = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk"
      size     = 13
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = file("./meta.txt")
  }
}

output "external_ip_address_nginx" {
  value = yandex_compute_instance.nginx.network_interface.0.nat_ip_address
}

output "internal_ip_address_nginx" {
  value = yandex_compute_instance.nginx.network_interface.0.ip_address
}
