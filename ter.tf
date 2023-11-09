terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = ""
  cloud_id  = "b1g6o30rad2hkh87j34f"
  folder_id = "b1gum68ifoa9fbhijk7v"
  zone = "ru-central1-a"
}
  
data "yandex_compute_image" "ubuntu_image" {
  family = "ubuntu-2004-lts"
}

variable "paramsvm" {
  description = "параметры машин"
  type        = map(string)
  default     = {
    namevm1     = "lessonvm1",
    cor1        = 2,
    mem1        = 2,
    namevm2     = "lessonvm2",
    cor2        = 2,
    mem2        = 2,
  }
}
resource "yandex_compute_instance" "vm-1" {
  name = var.paramsvm.namevm1
 # id = var.paramsvm.namevm1
  allow_stopping_for_update = true
  resources {
    cores  = var.paramsvm.cor1
    memory = var.paramsvm.mem1
  }

  boot_disk {
    disk_id =  yandex_compute_disk.hddvm1.id
  }

  network_interface {
    subnet_id = "e9bohr7qvj70b390umrp"
    nat       = true
  }

  metadata = {
    user-data = "${file("./user.yml")}"
  }
  scheduling_policy {
    preemptible = true 
  }
  connection {
    type     = "ssh"
    user     = "user"
    private_key = file("/var/lib/jenkins/.ssh/id_rsa")
    host = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
  }
}

resource "yandex_compute_disk" "hddvm1" {
  type     = "network-hdd"
  zone     = "ru-central1-a"
  image_id = data.yandex_compute_image.ubuntu_image.id
  size = 15
}

resource "yandex_compute_instance" "vm-2" {
  name = var.paramsvm.namevm2
 # id = var.paramsvm.namevm1
  allow_stopping_for_update = true
  resources {
    cores  = var.paramsvm.cor2
    memory = var.paramsvm.mem2
  }

  boot_disk {
    disk_id =  yandex_compute_disk.hddvm2.id
  }

  network_interface {
    subnet_id = "e9bohr7qvj70b390umrp"
    nat       = true
  }

  metadata = {
    user-data = "${file("./user.yml")}"
  }
  scheduling_policy {
    preemptible = true 
  }
  connection {
    type     = "ssh"
    user     = "user"
    private_key = file("/var/lib/jenkins/.ssh/id_rsa")
    host = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
  }
}

resource "yandex_compute_disk" "hddvm2" {
  type     = "network-hdd"
  zone     = "ru-central1-a"
  image_id = data.yandex_compute_image.ubuntu_image.id
  size = 15
}

output "ipbild" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}
output "ipprod" {
  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
}
