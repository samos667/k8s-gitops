resource "proxmox_virtual_environment_file" "talos-image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"

  source_file {
    path      = "https://github.com/siderolabs/talos/releases/download/v1.5.4/metal-amd64.iso"
    file_name = "talos-amd64.iso"
    checksum  = "9bdbd2ecd35fe94298d017bc137540a439ab3ca4c077e24712632aef2d202bf7"
  }
}
