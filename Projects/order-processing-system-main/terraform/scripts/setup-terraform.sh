#!/bin/bash

echo "=== Configurando Terraform ==="

# Verificar se Azure CLI está instalado
if ! command -v az &> /dev/null; then
    echo "Azure CLI não encontrado. Instalando..."
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
fi

# Verificar se Terraform está instalado
if ! command -v terraform &> /dev/null; then
    echo "Terraform não encontrado. Instalando..."
    wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
    unzip terraform_1.5.0_linux_amd64.zip
    sudo mv terraform /usr/local/bin/
    rm terraform_1.5.0_linux_amd64.zip
fi

# Login no Azure
echo "Fazendo login no Azure..."
az login

# Selecionar subscription
echo "Selecionando subscription..."
subscriptions=$(az account list --query "[].name" -o tsv)
if [ $(echo "$subscriptions" | wc -l) -gt 1 ]; then
    echo "Múltiplas subscriptions encontradas:"
    echo "$subscriptions"
    read -p "Digite o nome da subscription: " sub_name
    az account set --subscription "$sub_name"
fi

echo "Terraform configurado!"