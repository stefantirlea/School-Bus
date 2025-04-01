# Diagrama de Arhitectură SchoolBus

## Descriere

Diagrama de arhitectură a sistemului SchoolBus ilustrează componentele principale ale platformei multi-cloud, folosind Google Kubernetes Engine (GKE) ca mediu principal de deployment, complementat de clustere Kubernetes în VPS și medii on-premises.

## Componente Principale

### Google Cloud Platform (GCP)
- **Google Kubernetes Engine (GKE)**
  - Microservicii:
    - Auth Service - Autentificare și autorizare
    - Routing Service - Optimizare trasee 
    - Tracking Service - Monitorizare în timp real
    - Fleet Service - Management flotă
    - Notification Service - Notificări
    - Analytics Service - Analiză și rapoarte
  
  - Aplicații Frontend:
    - Admin Web App
    - Parent Web App
    - Fleet Web App
    - Dispatch Web App
    - API Gateway
  
  - Stocare Date:
    - Cloud SQL (PostgreSQL)
    - MongoDB
    - Redis Cache
    - Cloud Storage
    - BigQuery
    - Firebase Realtime DB

- **Monitoring & Logging**
  - Cloud Monitoring
  - Cloud Logging
  - Prometheus & Grafana

### VPS Kubernetes Cluster
- **Servicii**
  - Geo Service - Servicii de geolocalizare
  - Users Service - Management utilizatori
  - PostgreSQL - Stocare date

- **Networking**
  - Envoy Proxy
  - Traffic Director
  - Cloud Interconnect

### On-Premises Kubernetes Cluster
- **Servicii**
  - Scheduling Service - Programare și planificare
  - MongoDB - Stocare date
  - Backup Service - Serviciu de backup

- **Securitate**
  - IAM
  - Data Encryption
  - Secure Gateway

### Aplicații Mobile
- Parent Mobile App
- Driver Mobile App
- Monitor Mobile App
- Firebase Services

## Pipeline CI/CD
- GitHub Actions
- Terraform
- Docker Registry
- Cloud Build
- Kubernetes Deployment

## Notă
Diagrama completă este disponibilă în format SVG la `docs/architecture-diagram.svg`, dar poate fi vizualizată mai bine descărcând fișierul local sau vizitând [link-ul direct la raw](https://raw.githubusercontent.com/stefantirlea/School-Bus/main/docs/architecture-diagram.svg).