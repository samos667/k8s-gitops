terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.37.0"
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
  tags        = ["terraform", "k8s", "steropes", "prod", "cp"]
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
    size         = 50
    iothread     = "true"
    ssd          = "true"
    cache        = "writeback"
    discard      = "on"
  }

  cdrom { # Talos ISO
    enabled   = "true"
    file_id   = proxmox_virtual_environment_file.talos-image.id
    interface = "ide0"
  }

  disk { # AKA speed-data: a LVM volume of 100Go from pve local-lvm, who is made by a NVME SSD. For storing small data volumes and for fast IO
    datastore_id      = ""
    path_in_datastore = "/dev/pve/cp1-steropes-data-production"
    interface         = "scsi1"
    file_format       = "raw"
    iothread          = "true"
    ssd               = "true"
    cache             = "writeback"
    discard           = "on"
  }

  disk { # AKA big-data: a single sata 4To disk for storing large data volumes on K8S
    datastore_id      = ""
    path_in_datastore = "/dev/disk/by-id/ata-ST4000DM004-2CV104_ZFN4EQ27"
    interface         = "scsi2"
    file_format       = "raw"
    iothread          = "true"
    cache             = "writeback"
  }

  operating_system {
    type = "l26"
  }

}
