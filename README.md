# Kubernetes 3-Tier Application on Proxmox

This project demonstrates the complete deployment of a production-ready 3-tier application on a Kubernetes cluster running on Proxmox VMs.

## 🏗️ Architecture Overview

### Infrastructure Layer
- **Proxmox**: Virtualization platform
- **Terraform**: Infrastructure as Code (IaC)
- **Ansible**: Configuration management and automation

### Kubernetes Cluster
- **Control Plane**: 1 node (k8s-control)
- **Worker Nodes**: 2 nodes (k8s-worker-1, k8s-worker-2)
- **CNI**: Calico for networking
- **Container Runtime**: containerd

### Application Tiers
1. **Frontend Tier**: HTTPD web server with responsive UI
2. **Backend Tier**: HTTPD with JSON API endpoints
3. **Database Tier**: PostgreSQL 15

## 📋 Prerequisites

### Infrastructure Requirements
- Proxmox server with API access
- Ubuntu 22.04 cloud image template
- SSH key pair for authentication
- Network connectivity between VMs

### Software Requirements
- Terraform >= 1.0
- Ansible >= 2.0
- kubectl
- SSH client

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone <repository-url>
cd kubernetes-3tier-proxmox
```

### 2. Configure Variables
Edit `terraform.tfvars`:
```hcl
proxmox_ssh_password = "your-proxmox-ssh-password"
vm_count = 2  # Number of worker nodes
```

Update `variable.tf` with your SSH public key:
```hcl
variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDqYTxwkRFKBOIFLxOMarmwNZUw901hLLwab+0ghIY+7oxkEQ..."
}
```

### 3. Deploy Infrastructure
```bash
# Initialize Terraform
terraform init

# Plan and apply
terraform plan
terraform apply
```

### 4. Get VM IP Addresses
After Terraform completes, get the IP addresses from:
- Proxmox web interface
- Or: `terraform output vm_info`

### 5. Update Ansible Inventory
Edit `inventory.ini` with the actual VM IP addresses:
```ini
[k8s_control]
<control-node-ip> ansible_user=reon ansible_ssh_private_key_file=./proxmox_private_key

[k8s_workers]
<worker1-ip> ansible_user=reon ansible_ssh_private_key_file=./proxmox_private_key
<worker2-ip> ansible_user=reon ansible_ssh_private_key_file=./proxmox_private_key
```

### 6. Deploy Kubernetes
```bash
# Setup control node
ansible-playbook -i inventory.ini playbook.yml --limit k8s_control

# Join worker nodes
ansible-playbook -i inventory.ini join-workers.yml
```

### 7. Deploy 3-Tier Application
```bash
# Deploy the application
kubectl apply -f final-3tier.yaml
```

## 📁 Project Structure

```
kubernetes-3tier-proxmox/
├── main.tf                    # Terraform VM definitions
├── providers.tf               # Proxmox provider configuration
├── variable.tf                # Input variables
├── terraform.tfvars          # Variable values
├── outputs.tf                 # Output definitions
├── inventory.ini              # Ansible inventory
├── ansible.cfg               # Ansible configuration
├── playbook.yml              # Kubernetes setup playbook
├── join-workers.yml          # Worker node join playbook
├── final-3tier.yaml        # 3-tier application manifest
├── proxmox_private_key      # SSH private key (secure)
├── kubeadm-config.yaml.j2   # Kubeadm configuration template
└── README.md                 # This file
```

## 🔧 Configuration Details

### Terraform Configuration
- **VM Specs**: 2 CPU cores, 2-4GB RAM, 30GB disk
- **Networking**: DHCP with static node discovery
- **Authentication**: SSH key-based access
- **Cloud-init**: User and SSH key configuration

### Ansible Playbooks
- **playbook.yml**: Complete Kubernetes setup on control node
- **join-workers.yml**: Worker node configuration and cluster join
- **install-qemu-agent.yml**: QEMU agent installation (optional)

### Kubernetes Application
- **Database**: PostgreSQL 15 with persistent storage
- **Backend**: HTTPD serving JSON API endpoints
- **Frontend**: HTTPD serving responsive web UI
- **Services**: NodePort for external access, ClusterIP for internal communication

## 🌐 Access Information

### Kubernetes Cluster
- **Control Node**: k8s-control (IP from inventory)
- **Worker Nodes**: k8s-worker-1, k8s-worker-2
- **Dashboard**: `kubectl proxy` or install dashboard

### Application Access
- **Frontend**: `http://<any-node-ip>:30400`
- **Backend API**: Internal service only
- **Database**: Internal service only

### Management Commands
```bash
# Check cluster status
kubectl get nodes
kubectl get pods -A

# Check application status
kubectl get services
kubectl get pods

# Access application
curl http://<node-ip>:30400
```

## 🔒 Security Considerations

### SSH Keys
- Private key stored locally (`proxmox_private_key`)
- Public key configured in Terraform variables
- Key-based authentication only

### Kubernetes Security
- Calico network policies
- Pod security contexts
- Service account management
- RBAC configured for applications

### Network Security
- Internal services use ClusterIP
- External access via NodePort only
- Database not exposed externally

## 📊 Monitoring and Troubleshooting

### Health Checks
```bash
# Node status
kubectl get nodes -o wide

# Pod status
kubectl get pods -o wide

# Service status
kubectl get services

# Application logs
kubectl logs -f deployment/frontend
kubectl logs -f deployment/backend
kubectl logs -f deployment/database
```

### Common Issues
1. **VM Creation Fails**: Check Proxmox API and SSH credentials
2. **Pods Not Ready**: Verify networking and image pulls
3. **Service Access**: Check NodePort configuration and firewall rules
4. **Database Connection**: Verify service discovery and credentials

## 🚀 Scaling and Maintenance

### Horizontal Scaling
```bash
# Scale frontend
kubectl scale deployment frontend --replicas=3

# Scale backend
kubectl scale deployment backend --replicas=3

# Scale database (requires manual intervention)
kubectl scale deployment database --replicas=1
```

### Updates and Maintenance
```bash
# Update application
kubectl apply -f final-3tier.yaml

# Rolling restart
kubectl rollout restart deployment/frontend
kubectl rollout restart deployment/backend

# Check rollout status
kubectl rollout status deployment/frontend
```

## 📚 Additional Resources

### Documentation
- [Terraform Proxmox Provider](https://registry.terraform.io/providers/telmate/proxmox/latest/docs)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Calico CNI](https://docs.projectcalico.org/)

### Best Practices
- Use Git for infrastructure version control
- Implement CI/CD pipelines
- Monitor resource usage and costs
- Regular security updates and patches
- Backup strategies for persistent data

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Support

For issues and questions:
- Create an issue in the repository
- Check the troubleshooting section
- Review the logs and configuration

---

**🎯 Result**: A production-ready, scalable 3-tier application running on Kubernetes with full infrastructure automation.
