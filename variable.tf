variable "proxmox_host" {
  description = "Proxmox node hostname"
  type        = string
  default     = "pve" # Default Proxmox node name
}

variable "proxmox_ssh_password" {
  description = "SSH password for Proxmox root user"
  type        = string
  sensitive   = true
}

variable "vm_ids" {
  description = "Starting VM ID"
  type        = number
  default     = 900
}

variable "ssh_public_key" {
  description = "SSH public key for cloud-init"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDqYTxwkRFKBOIFLxOMarmwNZUw901hLLwab+0ghIY+7oxkEQqaxby3KsblAMx7rtirAm9Ib6JKoSW85rEA9vcbGG9vKx0Vna3AeWU5duo8u+A0grS4yS1QddI9lG4AbrWTAFTjFe+dGogyWtT+dida29bWOaM10ZAcK+BG608zdNs0AW5TuVgeo/452v4b4bkR3JngbWBgjmUa6uz/YepsEQ9uoSkJkHYyouZf+pqQ7I0d7+Lf4f750On3g06NML0sGTOe0BJgJzeAsnThu7dDgIcwxyWPFbHWSAukpWERI3DjZQPNsE0Aq5wlZ2rk57hpV1hVhF4u7GSBMgEZ7FziFvrBmmsF8hwXkNV3oPfWaiwhBjMWx96cmpQtjclb9HwTYMqEkmoq+kTWsQKMrJYkrWkYW54kLosY0Hb0fYg6b27syq3VPEIypj1NwacNlsBLwHnoNnxLxROBWGYbPZwZKea0MdqzxUqF6Gy8REmhXCRtq83D8teO3QcCBUwpszQN0eiIB5CN4wm+ZyOIhZUoePA99McCfoJDV4u0nLAd1wpbtaRaqlLFHHiStTOwdZ/laWBTKTMFenZ1e1FbTPpcwidADEceaG4scheKiC5vgApy6ZMXlHdDSqVvAb9ZdshcD4EREs61GexQFf7jGx9m7ZwIED1XG8s8MOJ2TRoWzQ== proxmox@example.com"
}

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 1
}
