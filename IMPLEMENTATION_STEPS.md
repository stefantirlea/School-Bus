# Pași de Implementare - Infrastructura SchoolBus

## Progres Actual

- [x] Structura repository-ului de infrastructură
- [x] main.tf pentru mediul dev
- [x] variables.tf pentru mediul dev
- [x] outputs.tf pentru mediul dev
- [x] terraform.tfvars.example
- [x] Workflow GitHub Actions pentru Terraform CI/CD
- [x] Workflow pentru deployment microservicii
- [x] Script pentru configurarea secretelor GitHub
- [x] Exemple workflow-uri microservicii
- [x] Documentație arhitectură completă
- [x] Creare repository-uri pentru microservicii și aplicații

## Repository-uri Existente

Repository-urile pentru întregul proiect au fost deja create, inclusiv:

### Microservicii:
- [x] schoolbus-svc-auth - Autentificare și autorizare
- [x] schoolbus-svc-routing - Rutare și optimizare trasee
- [x] schoolbus-svc-tracking - Tracking în timp real
- [x] schoolbus-svc-fleet - Management flotă
- [x] schoolbus-svc-notifications - Notificări
- [x] schoolbus-svc-analytics - Analiză și raportare
- [x] schoolbus-svc-geo - Geolocalizare
- [x] schoolbus-svc-users - Management utilizatori
- [x] schoolbus-svc-scheduling - Programare și planificare

### Aplicații:
- [x] schoolbus-app-admin-web - Aplicație web pentru administratori
- [x] schoolbus-app-parent-web - Aplicație web pentru părinți
- [x] schoolbus-app-fleet-web - Aplicație web pentru managementul flotei
- [x] schoolbus-app-dispatch-web - Aplicație web pentru dispeceri
- [x] schoolbus-app-parent-mobile - Aplicație mobilă pentru părinți
- [x] schoolbus-app-driver-mobile - Aplicație mobilă pentru șoferi
- [x] schoolbus-app-monitor-mobile - Aplicație mobilă pentru monitorizare

### Infrastructură:
- [x] schoolbus-platform - Repository central 
- [x] schoolbus-infra-terraform - Configurații Terraform
- [x] schoolbus-infra-gke - Configurații GKE
- [x] schoolbus-devops-monitoring - Monitoring și observabilitate

### Biblioteci și utilitare:
- [x] schoolbus-lib-common - Biblioteci comune
- [x] schoolbus-lib-ui-components - Componente UI
- [x] schoolbus-lib-api-specs - Specificații API
- [x] schoolbus-tools-data-migration - Migrare date
- [x] schoolbus-tools-dev-environment - Medii de dezvoltare

## Faza 1: Infrastructura GKE

### 1. Service Accounts în GCP
- [ ] Creare terraform-deployer
```bash
gcloud iam service-accounts create terraform-deployer
```
- [ ] Asignare roluri
```bash
gcloud projects add-iam-policy-binding [ID_PROIECT] --member="serviceAccount:terraform-deployer@[ID_PROIECT].iam.gserviceaccount.com" --role="roles/container.admin"
```
- [ ] Generare cheie JSON
```bash
gcloud iam service-accounts keys create terraform-key.json --iam-account=terraform-deployer@[ID_PROIECT].iam.gserviceaccount.com
```

### 2. Bucket pentru starea Terraform
- [ ] Creare bucket
```bash
gsutil mb -p [ID_PROIECT] -l europe-west3 gs://schoolbus-terraform-state
```
- [ ] Activare versionare
```bash
gsutil versioning set on gs://schoolbus-terraform-state
```

### 3. Secrete GitHub
- [ ] Executare script configurare pentru repository-ul principal
```bash
./scripts/setup-github-secrets.sh stefantirlea School-Bus dev
```

### 4. Configurare terraform.tfvars
- [ ] Copiere și editare fișier
```bash
cp environments/dev/terraform.tfvars.example environments/dev/terraform.tfvars
```

### 5. Aplicare configurație Terraform
- [ ] Inițializare
```bash
terraform init -backend-config="bucket=schoolbus-terraform-state" -backend-config="prefix=terraform/state/dev"
```
- [ ] Aplicare
```bash
terraform apply
```
- [ ] Alternativ: GitHub Actions workflow

### 6. Verificare infrastructură
- [ ] Verificare cluster și resurse
```bash
kubectl get pods -n schoolbus-dev
```

## Faza 2: Implementare CI/CD pentru Microservicii

### 1. Configurare workflow-uri în repository-urile microserviciilor
- [ ] Adăugare workflow CI/CD pentru schoolbus-svc-auth
- [ ] Adăugare workflow CI/CD pentru schoolbus-svc-fleet
- [ ] Adăugare workflow CI/CD pentru schoolbus-svc-routing
- [ ] Adăugare workflow CI/CD pentru schoolbus-svc-tracking
- [ ] Adăugare workflow CI/CD pentru schoolbus-svc-notifications
- [ ] Adăugare workflow CI/CD pentru schoolbus-svc-analytics

### 2. Implementare și configurare Dockerfile-uri
- [ ] Crearea Dockerfile pentru fiecare microserviciu
- [ ] Configurare health checks și porturi
- [ ] Optimizare imagini Docker

### 3. Implementare strategii de deployment
- [ ] Configurare strategie rolling update
- [ ] Configurare health checks pentru Kubernetes
- [ ] Implementare backup și restore

## Faza 3: Configurare Monitoring & Logging

### 1. Prometheus & Grafana
- [ ] Deployment Prometheus în GKE
- [ ] Configurare Grafana
- [ ] Creare dashboards specifice

### 2. Google Cloud Monitoring & Logging
- [ ] Configurare exporters pentru Cloud Monitoring
- [ ] Configurare alerte și notificări
- [ ] Integrare cu Slack/Email

## Faza 4: Arhitectura Multi-cloud

### 1. Modul pentru federație multi-cloud
- [ ] Creare modul conform arhitecturii documentate

### 2. Configurație pentru VPS Kubernetes
- [ ] Creare configurații VPS

### 3. Configurație pentru On-Premises Kubernetes
- [ ] Creare configurații on-premises

### 4. Traffic Director și Load Balancing
- [ ] Implementare Traffic Director

### 5. Modul Envoy Proxy
- [ ] Configurare Envoy pentru toate clusterele

## Alocarea Responsabilităților

- **Arhitect/Scrum Master/DevOps (2h/zi)**: Responsabil pentru infrastructură, CI/CD, arhitectură și coordonare echipă
- **Dezvoltator Full Stack (1) (8h/zi)**: Implementare microservicii de bază și integrare cu API-uri
- **Dezvoltator Full Stack (2) (6h/zi)**: Implementare microservicii secundare și suport pentru frontend
- **Dezvoltator Frontend (6h/zi)**: Implementare aplicații web 
- **Dezvoltator React Native (8h/zi)**: Implementare aplicații mobile
- **Designer (4h/zi)**: Design UI/UX pentru toate aplicațiile
- **Tester (8h/zi)**: Testare manuală și automatizată