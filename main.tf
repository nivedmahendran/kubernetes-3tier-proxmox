# Get node information
data "proxmox_virtual_environment_nodes" "nodes" {}

output "available_nodes" {
  value = data.proxmox_virtual_environment_nodes.nodes.names
}

# Create Kubernetes control node
resource "proxmox_virtual_environment_vm" "k8s_control" {
  name        = "k8s-control"
  description = "Managed by Terraform"
  tags        = ["terraform", "ubuntu", "k8s", "control"]
  node_name   = var.proxmox_host
  vm_id       = 100

  # CPU configuration
  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  # Memory configuration
  memory {
    dedicated = 4096 # 4GB for control
  }

  # Disk configuration - import cloud image as main disk
  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 30 # GB
    file_format  = "raw"
    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
  }

  # Cloud-init drive
  disk {
    datastore_id = "local-lvm"
    interface    = "ide2"
    size         = 4
    file_id      = "local-lvm:cloudinit"
  }

  # Network configuration
  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  # Operating system
  operating_system {
    type = "l26"
  }

  # SCSI controller
  scsi_hardware = "virtio-scsi-pci"

  # Boot configuration
  boot_order = ["scsi0"]

  # Agent configuration
  agent {
    enabled = false
  }

  # Cloud-init configuration
  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = "your-username-here"
      password = "your-password-here"
      keys     = var.ssh_public_key != "" ? [var.ssh_public_key] : []
    }
  }
}

# Create multiple Ubuntu VMs
resource "proxmox_virtual_environment_vm" "k8s_nodes" {
  count       = var.vm_count
  name        = "k8s-worker-${count.index + 1}"
  description = "Managed by Terraform"
  tags        = ["terraform", "ubuntu", "k8s", "worker"]
  node_name   = var.proxmox_host
  vm_id       = 100 + count.index + 1

  # CPU configuration
  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  # Memory configuration
  memory {
    dedicated = 2048 # 2GB for workers
  }

  # Disk configuration - import cloud image as main disk
  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 30 # GB
    file_format  = "raw"
    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
  }

  # Cloud-init drive
  disk {
    datastore_id = "local-lvm"
    interface    = "ide2"
    size         = 4
    file_id      = "local-lvm:cloudinit"
  }

  # Network configuration
  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  # Operating system
  operating_system {
    type = "l26"
  }

  # SCSI controller
  scsi_hardware = "virtio-scsi-pci"

  # Boot configuration
  boot_order = ["scsi0"]

  # Agent configuration
  agent {
    enabled = false
  }

  # Cloud-init configuration
  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = "your-username-here"
      password = "your-password-here"
      keys     = var.ssh_public_key != "" ? [var.ssh_public_key] : []
    }
  }
}
