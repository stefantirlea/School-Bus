#!/bin/bash

# Script pentru configurarea secretelor GitHub pentru CI/CD
# Utilizare: ./setup-github-secrets.sh <owner> <repo> <environment>

set -e

if [ "$#" -lt 3 ]; then
    echo "Utilizare: $0 <owner> <repo> <environment>"
    echo "Exemplu: $0 stefantirlea School-Bus dev"
    exit 1
fi

OWNER=$1
REPO=$2
ENV=$3
GITHUB_TOKEN=${GITHUB_TOKEN:-""}

if [ -z "$GITHUB_TOKEN" ]; then
    echo "GITHUB_TOKEN nu este setat. Vă rugăm să furnizați un token de acces GitHub."
    echo "Exemplu: export GITHUB_TOKEN=ghp_your_token"
    exit 1
fi

# Verificare dacă avem cheia service account
if [ ! -f "terraform-key.json" ]; then
    echo "Fișierul terraform-key.json nu a fost găsit."
    echo "Vă rugăm să generați o cheie pentru service account-ul Terraform folosind:"
    echo "gcloud iam service-accounts keys create terraform-key.json --iam-account=terraform-deployer@[PROJECT_ID].iam.gserviceaccount.com"
    exit 1
fi

# Funcție pentru adăugarea unui secret
add_secret() {
    local name=$1
    local value=$2
    
    # Codificarea valorii în base64
    encoded_value=$(echo -n "$value" | base64)
    
    echo "Adăugare secret: $name"
    
    # Folosirea GitHub API pentru a crea secretul
    curl -X PUT \
         -H "Authorization: token $GITHUB_TOKEN" \
         -H "Accept: application/vnd.github.v3+json" \
         "https://api.github.com/repos/$OWNER/$REPO/actions/secrets/$name" \
         -d "{\"encrypted_value\":\"$encoded_value\",\"key_id\":\"\"}"
    
    echo ""
}

# Adăugare secret pentru mediul specific
add_environment_secret() {
    local name=$1
    local value=$2
    local env_id
    
    # Obținere ID mediu
    env_id=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
                  -H "Accept: application/vnd.github.v3+json" \
                  "https://api.github.com/repos/$OWNER/$REPO/environments/$ENV" | jq -r '.id')
    
    if [ "$env_id" == "null" ]; then
        echo "Mediul $ENV nu există. Se creează..."
        curl -X PUT \
             -H "Authorization: token $GITHUB_TOKEN" \
             -H "Accept: application/vnd.github.v3+json" \
             "https://api.github.com/repos/$OWNER/$REPO/environments/$ENV" \
             -d "{\"wait_timer\":0}"
        
        env_id=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
                      -H "Accept: application/vnd.github.v3+json" \
                      "https://api.github.com/repos/$OWNER/$REPO/environments/$ENV" | jq -r '.id')
    fi
    
    echo "Adăugare secret de mediu: $name pentru $ENV (ID: $env_id)"
    
    # Folosirea GitHub API pentru a crea secretul de mediu
    curl -X PUT \
         -H "Authorization: token $GITHUB_TOKEN" \
         -H "Accept: application/vnd.github.v3+json" \
         "https://api.github.com/repositories/$(curl -s -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/$OWNER/$REPO" | jq -r '.id')/environments/$ENV/secrets/$name" \
         -d "{\"encrypted_value\":\"$encoded_value\",\"key_id\":\"\"}"
    
    echo ""
}

echo "Configurare secrete pentru $OWNER/$REPO - mediul $ENV"

# Adăugare GCP Service Account JSON
GCP_SA_KEY=$(cat terraform-key.json)
add_secret "GCP_SA_KEY" "$GCP_SA_KEY"

# ID-ul proiectului GCP (extragem din fișierul JSON)
GCP_PROJECT_ID=$(cat terraform-key.json | jq -r '.project_id')
add_secret "GCP_PROJECT_ID" "$GCP_PROJECT_ID"

# Regiunea GCP (setată la europe-west3 implicit)
GCP_REGION="europe-west3"
add_secret "GCP_REGION" "$GCP_REGION"

# Numele bucket-ului Terraform state
TERRAFORM_STATE_BUCKET="schoolbus-terraform-state"
add_secret "TERRAFORM_STATE_BUCKET" "$TERRAFORM_STATE_BUCKET"

# Prefix pentru state (diferit pentru fiecare mediu)
TERRAFORM_STATE_PREFIX="terraform/state/$ENV"
add_secret "TERRAFORM_STATE_PREFIX" "$TERRAFORM_STATE_PREFIX"

# Nume cluster GKE
GKE_CLUSTER_NAME="schoolbus-$ENV"
add_secret "GKE_CLUSTER_NAME" "$GKE_CLUSTER_NAME"

echo "Configurarea secretelor s-a finalizat cu succes!"
echo "Următorii pași:"
echo "1. Verificați secretele în GitHub la: https://github.com/$OWNER/$REPO/settings/secrets/actions"
echo "2. Executați workflow-ul de Terraform pentru a crea infrastructura"