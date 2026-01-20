# Kubernetes 3-Tier Todo Application on Proxmox

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

### 3. Deploy Todo Application
```bash
cd todo-app
./deploy-all.sh
```

### 4. Access the Application
```bash
# Get the NodePort
kubectl get service todo-frontend-service -n todo-app

# Access via browser
http://<any-node-ip>:<nodeport>
```

## 📁 Project Structure
```
├── ansible/           # Kubernetes setup automation
│   ├── inventory.ini          # Node IPs and configuration
│   ├── playbook.yml           # Control node setup
│   ├── join-workers.yml       # Worker node setup
│   └── templates/kubeadm-config.yaml.j2 # Kubeadm configuration
├── terraform/         # Infrastructure as code
│   ├── main.tf               # VM definitions
│   ├── providers.tf          # Proxmox provider
│   ├── outputs.tf            # Output variables
│   ├── variable.tf           # Input variables
│   └── terraform.tfvars      # Variable values
├── todo-app/          # Todo application manifests
│   ├── namespace.yaml         # Application namespace
│   ├── postgres-secret.yaml  # Database credentials
│   ├── postgres-pvc.yaml     # Persistent storage
│   ├── postgres-deployment.yaml # Database deployment
│   ├── postgres-service.yaml # Database service
│   ├── backend-configmap.yaml # Backend application code
│   ├── backend-deployment.yaml # Backend deployment
│   ├── backend-service.yaml  # Backend service
│   ├── frontend-configmap.yaml # Frontend code and nginx config
│   ├── frontend-deployment.yaml # Frontend deployment
│   ├── frontend-service.yaml # Frontend NodePort service
│   └── deploy-all.sh         # Automated deployment script
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
- Control node: 10.10.8.25
- Worker 1: 10.10.8.24  
- Worker 2: 10.10.8.23

## 🎯 Todo Application Features
- **3-Tier Architecture:** Frontend (Nginx) → Backend (Python Flask) → Database (PostgreSQL)
- **Complete CRUD Operations:** Create, Read, Delete todos
- **Persistent Storage:** PostgreSQL with PVC
- **High Availability:** 2 replicas each for frontend and backend
- **Load Balancing:** Kubernetes services
- **External Access:** NodePort service for frontend

## 🐛 Troubleshooting & Error Resolution

### 1. SSH Connection Issues
**Error:** `No route to host` or `Host key verification failed`
**Solution:** 
- Update `ansible/inventory.ini` with correct IP addresses
- Use `ANSIBLE_HOST_KEY_CHECKING=False` for initial setup
- Ensure SSH key path is correct: `/home/nived/.ssh/proxmox_key`

### 2. GPG Key Installation Issues
**Error:** Ansible hanging on "Add Kubernetes GPG key" task
**Solution:** Modified `playbook.yml` to use more robust GPG key installation:
```yaml
- name: Create apt keyrings directory
  file:
    path: /etc/apt/keyrings
    state: directory
    mode: '0755'

- name: Download Kubernetes GPG key
  get_url:
    url: https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key
    dest: /tmp/kubernetes-release.key
    mode: '0644'

- name: Convert GPG key to dearmor format
  shell: gpg --dearmor < /tmp/kubernetes-release.key > /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  args:
    creates: /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

### 3. Kubernetes Version Issues
**Error:** `ImagePull` errors for incorrect Kubernetes images
**Solution:** Changed `kubernetes_version` from `1.28.4-1.1` to `1.28.4` in `playbook.yml`

### 4. Template File Not Found
**Error:** `Could not find or access 'kubeadm-config.yaml.j2'`
**Solution:** Created `templates/` subdirectory and moved `kubeadm-config.yaml.j2` into it

### 5. PostgreSQL PVC Pending
**Error:** PVC stuck in `Pending` state
**Solution:** 
- Installed `local-path-provisioner` for dynamic provisioning
- Created `local-path` StorageClass with `provisioner: rancher.io/local-path`
- Deleted and recreated PVC to trigger provisioning

### 6. Backend Pod Crashing
**Error:** Complex shell commands with heredoc causing syntax errors
**Solution:** 
- Switched from Node.js to Python Flask backend
- Used ConfigMaps for application code instead of complex shell commands
- Simplified deployment with proper dependency management

### 7. Frontend 502 Bad Gateway
**Error:** Nginx returning 502 when accessing `/api` endpoints
**Solution:** Fixed nginx configuration in ConfigMap:
```nginx
location /api/ {
    proxy_pass http://todo-backend-service:3000/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

### 8. Backend Installation Timeout
**Error:** Backend pods taking too long to install dependencies
**Solution:** 
- Initially tried in-memory storage for faster startup
- Finally implemented proper PostgreSQL integration with persistent storage
- Used Python slim images with optimized dependency installation

### 9. Multiple Backend Pods Data Inconsistency
**Error:** Different backend pods showing different todo lists
**Solution:** 
- Identified load balancer hitting different pods with different in-memory states
- Restarted deployment to ensure consistent state
- Implemented proper database integration for data persistence

### 10. Frontend Not Refreshing After Delete
**Error:** Todo list not updating after delete operations
**Solution:** Fixed JavaScript to check response success before refreshing:
```javascript
async function deleteTodo(todoId) {
    if (!confirm('Are you sure you want to delete this todo?')) return;
    
    try {
        const response = await fetch(API_URL + '/todos/' + todoId, {
            method: 'DELETE'
        });
        if (response.ok) {
            loadTodos();
        }
    } catch (error) {
        console.error('Error deleting todo:', error);
    }
}
```

## 📝 Final Architecture Notes
- **Container Runtime:** containerd
- **CNI:** Calico
- **Kubernetes Version:** 1.28.4
- **VM OS:** Ubuntu 22.04
- **Database:** PostgreSQL with persistent storage
- **Backend:** Python Flask with psycopg2
- **Frontend:** Nginx serving static HTML/JS
- **Storage:** local-path provisioner for PVCs
- **Load Balancing:** Kubernetes services with NodePort

## 🎉 Success Criteria Met
✅ 3-tier Kubernetes cluster deployed
✅ Todo application with complete CRUD functionality
✅ Persistent database storage
✅ High availability with multiple replicas
✅ External access via NodePort
✅ Clean, maintainable configuration
✅ All errors resolved and documented
