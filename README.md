# SchoolBus - Sistem de management al transportului școlar

## Descriere

SchoolBus este o platformă completă pentru managementul transportului școlar, construită pe o arhitectură modernă multi-cloud utilizând Google Kubernetes Engine (GKE). Sistemul oferă monitorizare în timp real a autobuzelor, optimizarea rutelor, comunicare cu părinții și elevii, și un set complet de instrumente administrative.

![School Bus Architecture](docs/architecture-diagram.png)

## Arhitectura

Platforma este construită pe o arhitectură de microservicii, deployată pe Google Kubernetes Engine, cu componente adiționale găzduite în cloud-uri private și on-premises pentru reziliență și conformitate cu reglementările privind datele.

### Componente principale

- **Microservicii backend**: Servicii specializate pentru autentificare, rutare, tracking, notificări, management flotă etc.
- **Aplicații frontend**: Interfețe web și mobile pentru administratori, părinți, șoferi și personal de monitorizare
- **Infrastructură CI/CD**: Pipeline-uri automatizate pentru build, testare și deployment
- **Monitorizare**: Sistem de monitorizare și alertare pentru întreaga platformă

## Instrucțiuni de setup

### Cerințe preliminare

- Cont Google Cloud Platform cu acces la GKE
- Terraform (v1.0.0+)
- kubectl configurabil
- GitHub Personal Access Token
- jq (pentru procesarea JSON)

### Pași de instalare

1. **Clonează repository-ul**

```bash
git clone https://github.com/stefantirlea/School-Bus.git
cd School-Bus
```

2. **Configurează Service Account GCP**

```bash
gcloud iam service-accounts create terraform-deployer
gcloud projects add-iam-policy-binding [ID_PROIECT] --member="serviceAccount:terraform-deployer@[ID_PROIECT].iam.gserviceaccount.com" --role="roles/container.admin"
gcloud iam service-accounts keys create terraform-key.json --iam-account=terraform-deployer@[ID_PROIECT].iam.gserviceaccount.com
```

3. **Creează bucket pentru starea Terraform**

```bash
gsutil mb -p [ID_PROIECT] -l europe-west3 gs://schoolbus-terraform-state
gsutil versioning set on gs://schoolbus-terraform-state
```

4. **Configurează secretele GitHub**

```bash
export GITHUB_TOKEN=your_github_token
chmod +x scripts/setup-github-secrets.sh
./scripts/setup-github-secrets.sh stefantirlea School-Bus dev
```

5. **Inițializează și aplică configurația Terraform**

```bash
cd environments/dev
terraform init -backend-config="bucket=schoolbus-terraform-state" -backend-config="prefix=terraform/state/dev"
terraform apply
```

### Pași pentru adăugarea unui nou microserviciu

1. Creează un nou repository în organizația GitHub
2. Configurează workflow-urile GitHub Actions (exemplul se găsește în `examples/workflows/`)
3. Implementează codul microserviciului
4. Adaugă resurse în configurația Terraform (în directorul `environments/dev/`)
5. Aplică configurația actualizată

## Structura repository-urilor

Platforma School-Bus este organizată în mai multe repository-uri:

- **Repository-uri microservicii**: `schoolbus-svc-*`
- **Repository-uri aplicații**: `schoolbus-app-*-web` și `schoolbus-app-*-mobile`
- **Repository-uri infrastructură**: `schoolbus-infra-terraform`, `schoolbus-infra-gke`
- **Repository-uri biblioteci și utilitare**: `schoolbus-lib-*`, `schoolbus-tools-*`

## Pipeline-uri CI/CD

Fiecare repository are propriul său workflow GitHub Actions configurat pentru CI/CD automat:

### Workflows pentru microservicii

- Build și testare automată la push și pull request
- Deployment automat în mediul de dezvoltare la push pe `develop`
- Deployment automat în producție la push pe `main`
- Verificări de securitate pentru codebază și imagini Docker

### Workflows pentru aplicații web

- Linting și testare React/Angular
- Build și optimizare pentru producție
- Deployment automat în Kubernetes

### Workflows pentru aplicații mobile

- Build pentru Android și iOS
- Deployment automat în Firebase App Distribution
- Deployment automat în magazinele de aplicații

## Configurare infrastructură Terraform

Infrastructura este definită ca și cod folosind Terraform, organizată pe medii:

- `environments/dev/`: Configurare pentru mediul de dezvoltare
- `environments/prod/`: Configurare pentru mediul de producție
- `modules/`: Module reutilizabile pentru GKE, baze de date, etc.

## Documentație

- [Arhitectura proiectului](docs/project-architecture.md)
- [Pași de implementare](IMPLEMENTATION_STEPS.md)
- [Bune practici CI/CD](docs/CICD_BEST_PRACTICES.md)
- [Ghid pentru dezvoltatori](docs/developer-guide.md)

## Echipa și colaborare

Proiectul este gestionat folosind metodologia Agile Scrum, cu sprint-uri de două săptămâni și sesiuni de planning și retrospectivă. Contribuțiile se fac prin pull request-uri, conform ghidului de dezvoltare.

### Roluri

- Arhitect/Scrum Master/DevOps: Responsabil pentru infrastructură, CI/CD și coordonare echipă
- Dezvoltatori Full Stack: Implementare microservicii și integrări
- Dezvoltator Frontend: Implementare aplicații web
- Dezvoltator React Native: Implementare aplicații mobile
- Designer: Design UI/UX
- Tester: Testare manuală și automatizată

## Licență

Proprietar: Scope Systems