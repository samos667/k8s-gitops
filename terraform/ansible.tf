resource "local_file" "ansible_inventory" {
  filename = "./ansible/hosts-production"
  content  = <<-EOF
  [masters]
  k3s1 IP=${proxmox_virtual_environment_vm.k3s.ipv4_addresses[1][0]}

  [workers]

  [nodes:children]
  masters
  workers
  EOF

  provisioner "local-exec" {
    command     = "ansible-playbook -i hosts-production --become --become-user=root deploy-k3s.yaml"
    working_dir = "ansible"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "false"
    }
  }
}
