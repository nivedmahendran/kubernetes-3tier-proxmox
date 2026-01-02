terraform {
  required_version = ">= 1.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.53.0"
    }
  }
}

provider "proxmox" {
  # Using your Proxmox IP
  endpoint = "https://10.10.10.113:8006/"
  # API Token authentication (use the token you generated)
  api_token = "terraform@pve!terraform-token=05519c34-c457-488a-bfd2-d93204d57415"
  # Skip TLS verification (self-signed cert)
  insecure = true
  
  # SSH configuration for disk operations
  ssh {
    agent    = false
    username = "root"
    private_key = file("~/proxmox")
  }
}
