resource "proxmox_virtual_environment_download_file" "nixos_image" {
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "nixos-latest.iso"
  node_name          = "pve"
  url                = "https://channels.nixos.org/nixos-23.11/latest-nixos-minimal-x86_64-linux.iso"
  checksum           = "6644ee3ec26909814bcdb82857188dc492eecb3c97435c9d895c2d1cb02b274d"
  checksum_algorithm = "sha256"
}
