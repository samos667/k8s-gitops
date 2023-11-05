# terraform apply -var-file=customH.tfvars -auto-approve
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.37.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://172.16.66.100:8006/"
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
  name        = "k3s1"
  description = "Managed by Terraform"
  tags        = ["terraform"]
  node_name   = "pve"
  vm_id       = 961

  cpu {
    cores = 6
    type  = "host"
    flags = ["-spec-ctrl"]
  }

  memory {
    dedicated = 16384
  }

  agent {
    enabled = true
  }

  network_device {
    bridge      = "vmbr1"
    mac_address = "96:24:c7:fd:77:e2"
  }

  scsi_hardware = "virtio-scsi-single"

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_file.debian_cloud_image.id
    interface    = "scsi0"
    size         = 50
    iothread     = "true"
    ssd          = "true"
    cache        = "writeback"
    discard      = "on"
  }

  disk {
    datastore_id      = ""
    path_in_datastore = "/dev/pve/k3s-data-production"
    interface         = "scsi1"
    file_format       = "raw"
    iothread          = "true"
    ssd               = "true"
    cache             = "writeback"
    discard           = "on"
  }

  disk {
    datastore_id      = ""
    path_in_datastore = "/dev/disk/by-id/ata-ST4000DM004-2CV104_ZFN4EQ27"
    interface         = "scsi2"
    file_format       = "raw"
    iothread          = "true"
    cache             = "writeback"
  }

  serial_device {} # The Debian cloud image expects a serial port to be present

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    datastore_id      = "local-lvm"
    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
}
