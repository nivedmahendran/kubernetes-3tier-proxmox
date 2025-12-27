output "vm_info" {
  value = {
    for vm in proxmox_virtual_environment_vm.k8s_nodes : vm.name => {
      id      = vm.vm_id
      name    = vm.name
      node    = vm.node_name
      running = vm.started
    }
  }
}

output "vm_ip_addresses" {
  value = {
    for vm in proxmox_virtual_environment_vm.k8s_nodes : vm.name => vm.ipv4_addresses
  }
}

output "vm_network_info" {
  value = {
    for vm in proxmox_virtual_environment_vm.k8s_nodes : vm.name => vm.network_interface_names
  }
}
