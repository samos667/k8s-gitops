terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.43.1"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  # api_token = var.proxmox_API
  username = "root@pam"
  password = var.proxmox_password
  insecure = true
  ssh {
    agent    = true
    username = "root"
    password = var.proxmox_password
  }
}


resource "proxmox_virtual_environment_vm" "k3s" {
  name        = "cp1.steropes"
  description = "Steropes K8S cluster"
  tags        = ["terraform", "k8s", "steropes", "prod", "cp", "nixos"]
  node_name   = "pve"
  vm_id       = 696

  cpu {
    cores = 6
    type  = "host"
  }

  memory {
    dedicated = 16384
  }


  network_device {
    bridge      = "vmbr1"
    mac_address = var.mac_address
  }

  scsi_hardware = "virtio-scsi-single"

  disk { # OS disk
    datastore_id = "local-lvm"
    interface    = "scsi0"
    file_format  = "raw"
    size         = 100
    iothread     = "true"
    ssd          = "true"
    cache        = "writeback"
    discard      = "on"
  }

  cdrom { # Nixos ISO
    enabled   = "true"
    file_id   = proxmox_virtual_environment_download_file.nixos_image.id
    interface = "ide0"
  }

  disk {
    datastore_id      = ""
    path_in_datastore = "/dev/disk/by-id/nvme-NE-256_979032100018"
    interface         = "scsi1"
    file_format       = "raw"
    iothread          = "true"
    ssd               = "true"
    cache             = "writeback"
    discard           = "on"
  }

  disk {
    datastore_id      = ""
    path_in_datastore = "/dev/disk/by-id/ata-PNY_CS900_240GB_SSD_PNY4519191104050689E"
    interface         = "scsi2"
    file_format       = "raw"
    iothread          = "true"
    ssd               = "true"
    cache             = "writeback"
    discard           = "on"
  }


  disk { # AKA big-data: a single sata 4To disk, low IO, no replicated/backup used for monitoring and multimedia
    datastore_id      = ""
    path_in_datastore = "/dev/disk/by-id/ata-ST4000DM004-2CV104_ZFN4EQ27"
    interface         = "scsi3"
    file_format       = "raw"
    iothread          = "true"
    cache             = "writeback"
  }

  operating_system {
    type = "l26"
  }

}
