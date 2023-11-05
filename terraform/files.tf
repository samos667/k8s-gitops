resource "proxmox_virtual_environment_file" "debian_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"

  source_file {
    path      = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
    file_name = "debian-12-genericcloud-amd64.img"
    # checksum  = "6b55e88b027c14da1b55c85a25a9f7069d4560a8fdb2d948c986a585db469728a06d2c528303e34bb62d8b2984def38fd9ddfc00965846ff6e05b01d6e883bfe"
  }
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"

  source_file {
    path = "cloud-init/user-data.yml"
  }
}
