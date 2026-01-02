# Kubernetes 3-Tier Cluster on Proxmox

## 🚀 Quick Start

### 1. Create Infrastructure (Terraform)
```bash
cd terraform
terraform init
terraform apply
```

### 2. Setup Kubernetes (Ansible)
```bash
cd ansible
ansible-playbook -i inventory.ini playbook.yml
ansible-playbook -i inventory.ini join-workers.yml
```

### 3. Verify Cluster
```bash
ssh -i ~/proxmox ubuntu@<control-node-ip> "kubectl get nodes"
```

## 📁 Project Structure
```
├── ansible/           # Kubernetes setup automation
│   ├── inventory.ini          # Node IPs and configuration
│   ├── playbook.yml           # Control node setup
│   ├── join-workers.yml       # Worker node setup
│   └── kubeadm-config.yaml.j2 # Kubeadm configuration
├── terraform/         # Infrastructure as code
│   ├── main.tf               # VM definitions
│   ├── providers.tf          # Proxmox provider
│   ├── outputs.tf            # Output variables
│   ├── variable.tf           # Input variables
│   └── terraform.tfvars      # Variable values
└── README.md          # This file
```

## 📋 Requirements
- Proxmox server with API access
- SSH key pair for VM access
- Ubuntu 22.04 cloud image

## 🔧 Configuration
- Update `terraform/terraform.tfvars` with your Proxmox details
- Update `ansible/inventory.ini` with VM IPs after Terraform creates them

## 🌐 Cluster Access
- Control node: 10.10.10.161
- Worker 1: 10.10.10.162  
- Worker 2: 10.10.10.163

## 📝 Notes
- Uses containerd as container runtime
- Calico for CNI networking
- Kubernetes 1.28.15
- Ubuntu 22.04 VMs
