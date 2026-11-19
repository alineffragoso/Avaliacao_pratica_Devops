terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.7.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "base_ubuntu" {
  name   = "ubuntu24-base-prova.qcow2"
  pool   = "default"
  source = "/var/lib/libvirt/images/ubuntu24.04-cloud.qcow2"
  format = "qcow2"
}

resource "libvirt_volume" "disco_vm1" {
  name           = "vm1-app-web.qcow2"
  pool           = "default"
  base_volume_id = libvirt_volume.base_ubuntu.id
}

resource "libvirt_volume" "disco_vm2" {
  name           = "vm2-api-banco.qcow2"
  pool           = "default"
  base_volume_id = libvirt_volume.base_ubuntu.id
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit-prova.iso"
  pool      = "default"
  user_data = file("${path.module}/cloud_init.yaml")
}

resource "libvirt_domain" "vm1" {
  name    = "vm1-app-web"
  memory  = "1024"
  vcpu    = 1

  cpu {
    mode = "host-passthrough"
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name = "default"
    mac = "52:54:00:fa:e6:a4"
  }

  disk {
    volume_id = libvirt_volume.disco_vm1.id
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
}

resource "libvirt_domain" "vm2" {
  name    = "vm2-api-banco"
  memory  = "2048"
  vcpu    = 1

  cpu {
    mode = "host-passthrough"
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name = "default"
    mac = "52:54:00:4e:c2:98"
  }

  disk {
    volume_id = libvirt_volume.disco_vm2.id
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
}
