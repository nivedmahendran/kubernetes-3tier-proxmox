# Deployment Guide: Kubernetes 3-Tier Application

## 🎯 Objective
Deploy a complete 3-tier application on Kubernetes cluster running on Proxmox VMs using Infrastructure as Code.

## 📋 Pre-Deployment Checklist

### Prerequisites
- [ ] Proxmox server with API access
- [ ] SSH key pair generated
- [ ] Terraform installed locally
- [ ] Ansible installed locally
- [ ] kubectl installed locally
- [ ] Ubuntu 22.04 cloud image in Proxmox

### Network Requirements
- [ ] DHCP available for VMs
- [ ] Firewall allows ports 6443, 30400
- [ ] Internet access for container image pulls

### Security Setup
- [ ] Proxmox API token created
- [ ] SSH keys secured
- [ ] Passwords prepared

## 🚀 Step-by-Step Deployment

### Phase 1: Infrastructure Setup

#### 1.1 Configure Terraform
```bash
# Clone repository
git clone <repository-url>
cd kubernetes-3tier-proxmox

# Update variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

#### 1.2 Deploy VMs
```bash
# Initialize Terraform
terraform init

# Review plan
terraform plan

# Apply configuration
terraform apply -auto-approve
```

#### 1.3 Verify VM Creation
```bash
# Check Terraform outputs
terraform output

# Verify VMs in Proxmox UI
# Note the IP addresses of all VMs
```

### Phase 2: Kubernetes Installation

#### 2.1 Update Ansible Inventory
```bash
# Edit inventory.ini with actual VM IPs
nano inventory.ini
```

Example:
```ini
[k8s_control]
10.10.9.143 ansible_user=reon ansible_ssh_private_key_file=./proxmox_private_key

[k8s_workers]
10.10.9.141 ansible_user=reon ansible_ssh_private_key_file=./proxmox_private_key
10.10.9.142 ansible_user=reon ansible_ssh_private_key_file=./proxmox_private_key
```

#### 2.2 Setup Control Node
```bash
# Test SSH connectivity
ansible all -i inventory.ini -m ping

# Deploy Kubernetes on control node
ansible-playbook -i inventory.ini playbook.yml --limit k8s_control
```

#### 2.3 Join Worker Nodes
```bash
# Note the join command from control node output
# Deploy workers
ansible-playbook -i inventory.ini join-workers.yml
```

#### 2.4 Verify Cluster
```bash
# SSH to control node
ssh -i ./proxmox_private_key reon@<control-ip>

# Check cluster status
kubectl get nodes
kubectl get pods -A
```

### Phase 3: Application Deployment

#### 3.1 Deploy 3-Tier Application
```bash
# From control node or with kubectl configured
kubectl apply -f final-3tier.yaml

# Monitor deployment
kubectl get pods -w
```

#### 3.2 Verify Services
```bash
# Check services
kubectl get services

# Test application
curl http://<any-node-ip>:30400
```

## 🔧 Configuration Details

### Terraform Variables
```hcl
# terraform.tfvars
proxmox_host = "10.10.10.113"
proxmox_ssh_password = "your-password"
vm_count = 2
ssh_public_key = "your-ssh-public-key"
```

### Ansible Configuration
```ini
# ansible.cfg
[defaults]
host_key_checking = False
ask_pass = False
```

### Kubernetes Application
- **Frontend**: 2 replicas, HTTPD, NodePort 30400
- **Backend**: 2 replicas, HTTPD + JSON, ClusterIP
- **Database**: 1 replica, PostgreSQL 15, ClusterIP

## 🧪 Testing and Validation

### Infrastructure Tests
```bash
# Test VM connectivity
ping <vm-ip>
ssh -i ./proxmox_private_key reon@<vm-ip>

# Test Terraform state
terraform show
terraform validate
```

### Kubernetes Tests
```bash
# Test cluster health
kubectl get nodes -o wide
kubectl get pods -A

# Test DNS resolution
kubectl run test-pod --image=busybox --rm -it -- nslookup kubernetes.default.svc.cluster.local
```

### Application Tests
```bash
# Test frontend
curl -I http://<node-ip>:30400

# Test backend health
curl http://<node-ip>:30400/api.json

# Test database connectivity (from pod)
kubectl exec -it deployment/backend -- curl database-service:5432
```

## 🔍 Troubleshooting

### Common Issues

#### VM Creation Fails
**Symptoms**: Terraform apply fails
**Solutions**:
1. Verify Proxmox API credentials
2. Check SSH password in terraform.tfvars
3. Ensure cloud image exists in Proxmox
4. Check storage availability

#### SSH Connection Issues
**Symptoms**: Ansible SSH failures
**Solutions**:
1. Verify SSH key permissions: `chmod 600 proxmox_private_key`
2. Check SSH agent: `ssh-add ./proxmox_private_key`
3. Verify user credentials in inventory.ini
4. Test manual SSH: `ssh -i ./proxmox_private_key reon@<vm-ip>`

#### Kubernetes Installation Fails
**Symptoms**: Ansible playbook errors
**Solutions**:
1. Check internet connectivity for package downloads
2. Verify system resources (CPU, RAM, disk)
3. Check swap is disabled: `free -h`
4. Verify kernel modules: `lsmod | grep overlay`

#### Pod Issues
**Symptoms**: Pods stuck in ContainerCreating/Pending
**Solutions**:
1. Check image pull: `kubectl describe pod <pod-name>`
2. Verify networking: `kubectl get pods -o wide`
3. Check resources: `kubectl top nodes`
4. Review events: `kubectl get events`

#### Application Access Issues
**Symptoms**: Cannot access application via NodePort
**Solutions**:
1. Check service: `kubectl get svc`
2. Verify NodePort: `kubectl describe svc frontend-service`
3. Check firewall rules on nodes
4. Test from different nodes

### Debug Commands
```bash
# Terraform debug
terraform apply -auto-approve -detailed-exitcode

# Ansible debug
ansible-playbook -i inventory.ini playbook.yml -vvv

# Kubernetes debug
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl describe pod <pod-name>
kubectl logs <pod-name> --previous
```

## 📊 Performance Tuning

### Resource Optimization
```yaml
# Example resource limits in final-3tier.yaml
resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "256Mi"
    cpu: "200m"
```

### Scaling Strategies
```bash
# Horizontal scaling
kubectl scale deployment frontend --replicas=3
kubectl autoscale deployment frontend --min=2 --max=5 --cpu-percent=70

# Vertical scaling (edit resources)
kubectl edit deployment frontend
```

## 🔄 Maintenance Operations

### Updates
```bash
# Update application
kubectl apply -f final-3tier.yaml

# Rolling restart
kubectl rollout restart deployment/frontend
kubectl rollout status deployment/frontend
```

### Backup
```bash
# Backup etcd (control node)
sudo ETCDCTL_API=3 etcdctl snapshot save /backup/etcd-snapshot.db

# Backup application data
kubectl exec deployment/database -- pg_dump appdb > backup.sql
```

### Cleanup
```bash
# Remove application
kubectl delete -f final-3tier.yaml

# Remove cluster
ansible-playbook -i inventory.ini reset-cluster.yml

# Destroy infrastructure
terraform destroy -auto-approve
```

## 📈 Monitoring

### Resource Monitoring
```bash
# Node resources
kubectl top nodes

# Pod resources
kubectl top pods

# Detailed metrics
kubectl describe nodes
```

### Application Monitoring
```bash
# Service endpoints
kubectl get endpoints

# Network policies
kubectl get networkpolicies

# Events
kubectl get events --field-selector type=Warning
```

## 🎯 Success Criteria

Deployment is successful when:
- [ ] All 3 VMs are running and accessible via SSH
- [ ] Kubernetes cluster shows 3 Ready nodes
- [ ] All system pods are Running
- [ ] 3-tier application pods are Running
- [ ] Frontend accessible via NodePort 30400
- [ ] Backend API responds with JSON
- [ ] Database connectivity established
- [ ] Load balancing working across nodes

## 📞 Support

For deployment issues:
1. Check this guide's troubleshooting section
2. Review logs from each phase
3. Verify configuration files
4. Create GitHub issue with details

---

**🚀 Result**: Production-ready 3-tier application with automated infrastructure provisioning.
