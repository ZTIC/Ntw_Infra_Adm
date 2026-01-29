#!/bin/bash
set -e

ENVIRONMENT=${1:-dev}

echo "=== Deploying Azure Infrastructure for $ENVIRONMENT ==="

cd environments/$ENVIRONMENT

# Inicializar Terraform
echo "Initializing Terraform..."
terraform init

# Validar configuração
echo "Validating configuration..."
terraform validate

# Mostrar plano
echo "Showing execution plan..."
terraform plan

# Confirmar deploy
read -p "Apply changes? (yes/no): " confirm
if [ "$confirm" = "yes" ]; then
    echo "Applying infrastructure..."
    terraform apply -auto-approve
    
    # Salvar outputs
    terraform output -json > ../../terraform-outputs.json
    echo "Outputs saved to terraform-outputs.json"
    
    # Extrair connection strings para .env
    echo "Extracting connection strings..."
    terraform output -raw eventhub_send_connection_string > ../../.env.eventhub
    terraform output -raw storage_account_key > ../../.env.storage
    
    echo "Infrastructure deployed successfully!"
else
    echo "Deployment cancelled."
fi