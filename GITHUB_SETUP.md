# GitHub Repository Setup

## 🚀 Push to GitHub

### 1. Create GitHub Repository
1. Go to [GitHub](https://github.com) and sign in
2. Click "+" → "New repository"
3. Repository name: `kubernetes-3tier-proxmox`
4. Description: `Complete 3-tier application deployment on Kubernetes with Proxmox infrastructure`
5. Choose: Public or Private
6. Don't initialize with README (we have one)
7. Click "Create repository"

### 2. Add Remote and Push
```bash
# Add GitHub remote (replace with your username)
git remote add origin https://github.com/nivedmahendran/kubernetes-3tier-proxmox.git

# Push to GitHub
git push -u origin master
```

### 3. Repository Structure
Your GitHub repository will contain:

```
kubernetes-3tier-proxmox/
├── 📄 README.md                 # Main documentation
├── 📋 DEPLOYMENT_GUIDE.md       # Step-by-step deployment guide
├── 📄 LICENSE                   # MIT license
├── 📄 .gitignore               # Git ignore rules
├── 🔧 terraform.tfvars.example  # Terraform variables template
├── 🏗️ main.tf                 # VM provisioning
├── ⚙️ providers.tf              # Proxmox provider
├── 📊 variable.tf              # Input variables
├── 📤 outputs.tf               # Output definitions
├── 🎯 inventory.ini             # Ansible inventory
├── ⚙️ ansible.cfg              # Ansible configuration
├── 🎭 playbook.yml             # Kubernetes setup
├── 🔄 join-workers.yml          # Worker join playbook
├── 📜 kubeadm-config.yaml.j2   # Kubeadm template
├── 🏛️ final-3tier.yaml        # 3-tier application
└── 🔐 proxmox_private_key      # SSH key (gitignored)
```

## 📝 Repository Description

Use this for your GitHub repository README:

```markdown
# Kubernetes 3-Tier Application on Proxmox

🚀 **Complete Infrastructure as Code solution for deploying production-ready 3-tier applications on Kubernetes clusters running on Proxmox VMs.**

## 🏗️ Architecture

- **Infrastructure**: Terraform + Proxmox + Ansible
- **Cluster**: 3-node Kubernetes (1 control + 2 workers)
- **Application**: 3-tier (Frontend + Backend + Database)
- **Networking**: Calico CNI + NodePort services

## ✨ Features

- 🔄 **Infrastructure Automation**: Complete VM provisioning with Terraform
- ⚙️ **Configuration Management**: Ansible playbooks for Kubernetes setup
- 🏛️ **Production Ready**: 3-tier application with high availability
- 🔒 **Security Best Practices**: SSH key auth, RBAC, network policies
- 📊 **Monitoring**: Health checks and service discovery
- 📚 **Comprehensive Docs**: Step-by-step deployment guides

## 🚀 Quick Start

```bash
# Clone repository
git clone https://github.com/nivedmahendran/kubernetes-3tier-proxmox.git
cd kubernetes-3tier-proxmox

# Configure variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# Deploy infrastructure
terraform init
terraform apply

# Setup Kubernetes
ansible-playbook -i inventory.ini playbook.yml
ansible-playbook -i inventory.ini join-workers.yml

# Deploy application
kubectl apply -f final-3tier.yaml
```

## 📁 Project Structure

- `main.tf` - Terraform VM definitions
- `playbook.yml` - Kubernetes control node setup
- `final-3tier.yaml` - 3-tier application manifest
- `README.md` - Complete documentation
- `DEPLOYMENT_GUIDE.md` - Detailed deployment instructions

## 🔧 Requirements

- Proxmox server with API access
- Terraform >= 1.0
- Ansible >= 2.0
- kubectl
- SSH key pair

## 🌐 Access

After deployment:
- **Frontend**: `http://<node-ip>:30400`
- **Kubernetes Dashboard**: `kubectl proxy`
- **Cluster Management**: `kubectl get nodes,pods,services`

## 📚 Documentation

- [📖 Full Documentation](./README.md)
- [🚀 Deployment Guide](./DEPLOYMENT_GUIDE.md)
- [📄 License](./LICENSE)

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Make your changes
4. Submit pull request

## 📄 License

MIT License - see [LICENSE](./LICENSE) file for details.

---

**🎯 Result**: Production-ready Kubernetes cluster with automated 3-tier application deployment.
```

## 🔐 Security Notes

⚠️ **Important**: The `proxmox_private_key` file is gitignored for security. Never commit SSH private keys to version control.

Before pushing, ensure:
- [ ] `.gitignore` includes `proxmox_private_key`
- [ ] No sensitive data in `terraform.tfvars`
- [ ] API tokens and passwords are secure

## 🚀 Next Steps

After pushing to GitHub:

1. **Add Topics**: `kubernetes`, `terraform`, `ansible`, `proxmox`, `devops`, `infrastructure-as-code`
2. **Add Labels**: `hacktoberfest`, `good-first-issue`, `help-wanted`
3. **Enable Issues**: For bug reports and feature requests
4. **Enable Actions**: For CI/CD pipelines
5. **Add Wiki**: For additional documentation
6. **Create Releases**: For version management

## 📊 Repository Statistics

Your repository will include:
- **27 files** with complete infrastructure code
- **3,400+ lines** of configuration and documentation
- **Production-ready** deployment automation
- **Comprehensive** documentation and guides

---

**🎉 Ready to push! Your complete Kubernetes 3-tier deployment solution is ready for GitHub.**
