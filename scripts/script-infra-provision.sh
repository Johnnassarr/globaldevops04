#!/bin/bash
# =============================================================================
# Script de Provisionamento de Infraestrutura Azure - EcoTask
# =============================================================================
# Este script cria todos os recursos necessários no Azure:
# - Resource Group
# - Azure Container Registry (ACR)
# - Azure Database for PostgreSQL
# - Azure Container Instances (opcional)
# RM: 556221
# =============================================================================

set -e  # Para na primeira erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para imprimir mensagens
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Parse de argumentos
RESOURCE_GROUP=""
LOCATION=""
ACR_NAME=""
DB_NAME=""
DB_USER=""
DB_PASSWORD=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --resource-group)
            RESOURCE_GROUP="$2"
            shift 2
            ;;
        --location)
            LOCATION="$2"
            shift 2
            ;;
        --acr-name)
            ACR_NAME="$2"
            shift 2
            ;;
        --db-name)
            DB_NAME="$2"
            shift 2
            ;;
        --db-user)
            DB_USER="$2"
            shift 2
            ;;
        --db-password)
            DB_PASSWORD="$2"
            shift 2
            ;;
        *)
            print_error "Opção desconhecida: $1"
            exit 1
            ;;
    esac
done

# Validação de parâmetros obrigatórios
if [ -z "$RESOURCE_GROUP" ] || [ -z "$LOCATION" ] || [ -z "$ACR_NAME" ]; then
    print_error "Parâmetros obrigatórios faltando!"
    echo "Uso: $0 --resource-group <rg-name> --location <location> --acr-name <acr-name> [--db-name <db-name>] [--db-user <user>] [--db-password <password>]"
    exit 1
fi

# Valores padrão
DB_NAME=${DB_NAME:-"ecotask-db"}
DB_USER=${DB_USER:-"postgres"}
DB_PASSWORD=${DB_PASSWORD:-""}

print_info "=========================================="
print_info "Provisionamento de Infraestrutura Azure"
print_info "=========================================="
print_info "Resource Group: $RESOURCE_GROUP"
print_info "Location: $LOCATION"
print_info "ACR Name: $ACR_NAME"
print_info "DB Name: $DB_NAME"
print_info "=========================================="

# Verificar se está logado no Azure
print_info "Verificando login no Azure..."
if ! az account show &> /dev/null; then
    print_error "Não está logado no Azure. Execute: az login"
    exit 1
fi

ACCOUNT=$(az account show --query name -o tsv)
print_info "Conta Azure: $ACCOUNT"

# =============================================================================
# 1. CRIAR RESOURCE GROUP
# =============================================================================
print_info "Criando Resource Group: $RESOURCE_GROUP"
if az group show --name "$RESOURCE_GROUP" &> /dev/null; then
    print_warn "Resource Group já existe: $RESOURCE_GROUP"
else
    az group create \
        --name "$RESOURCE_GROUP" \
        --location "$LOCATION" \
        --output none
    print_info "✓ Resource Group criado com sucesso!"
fi

# =============================================================================
# 2. CRIAR AZURE CONTAINER REGISTRY (ACR)
# =============================================================================
print_info "Criando Azure Container Registry: $ACR_NAME"
if az acr show --name "$ACR_NAME" --resource-group "$RESOURCE_GROUP" &> /dev/null; then
    print_warn "ACR já existe: $ACR_NAME"
else
    az acr create \
        --resource-group "$RESOURCE_GROUP" \
        --name "$ACR_NAME" \
        --sku Basic \
        --admin-enabled true \
        --output none
    print_info "✓ ACR criado com sucesso!"
fi

# Obter credenciais do ACR
print_info "Obtendo credenciais do ACR..."
ACR_USERNAME=$(az acr credential show --name "$ACR_NAME" --query username -o tsv)
ACR_PASSWORD=$(az acr credential show --name "$ACR_NAME" --query passwords[0].value -o tsv)
ACR_LOGIN_SERVER=$(az acr show --name "$ACR_NAME" --query loginServer -o tsv)

print_info "ACR Login Server: $ACR_LOGIN_SERVER"
print_info "ACR Username: $ACR_USERNAME"
print_warn "ACR Password: (configure como variável secreta no Azure DevOps)"

# =============================================================================
# 3. CRIAR AZURE DATABASE FOR POSTGRESQL (FLEXIBLE SERVER)
# =============================================================================
DB_SERVER_NAME="${DB_NAME}-server"
print_info "Criando Azure Database for PostgreSQL: $DB_SERVER_NAME"

if az postgres flexible-server show --resource-group "$RESOURCE_GROUP" --name "$DB_SERVER_NAME" &> /dev/null; then
    print_warn "PostgreSQL Server já existe: $DB_SERVER_NAME"
else
    if [ -z "$DB_PASSWORD" ]; then
        print_warn "Senha do banco não fornecida. Gerando senha aleatória..."
        DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
    fi
    
    az postgres flexible-server create \
        --resource-group "$RESOURCE_GROUP" \
        --name "$DB_SERVER_NAME" \
        --location "$LOCATION" \
        --admin-user "$DB_USER" \
        --admin-password "$DB_PASSWORD" \
        --sku-name Standard_B1ms \
        --tier Burstable \
        --version 15 \
        --storage-size 32 \
        --public-access 0.0.0.0 \
        --output none
    
    print_info "✓ PostgreSQL Server criado com sucesso!"
    print_warn "DB Password: $DB_PASSWORD (configure como variável secreta no Azure DevOps)"
fi

# Obter informações do banco
DB_FQDN=$(az postgres flexible-server show \
    --resource-group "$RESOURCE_GROUP" \
    --name "$DB_SERVER_NAME" \
    --query fullyQualifiedDomainName -o tsv)

print_info "DB FQDN: $DB_FQDN"

# Criar banco de dados
print_info "Criando banco de dados: ecotask"
az postgres flexible-server db create \
    --resource-group "$RESOURCE_GROUP" \
    --server-name "$DB_SERVER_NAME" \
    --database-name ecotask \
    --output none || print_warn "Banco de dados pode já existir"

# =============================================================================
# RESUMO
# =============================================================================
print_info ""
print_info "=========================================="
print_info "PROVISIONAMENTO CONCLUÍDO!"
print_info "=========================================="
print_info "Resource Group: $RESOURCE_GROUP"
print_info "Location: $LOCATION"
print_info ""
print_info "ACR:"
print_info "  Name: $ACR_NAME"
print_info "  Login Server: $ACR_LOGIN_SERVER"
print_info "  Username: $ACR_USERNAME"
print_info "  Password: (configure no Azure DevOps)"
print_info ""
print_info "PostgreSQL:"
print_info "  Server: $DB_SERVER_NAME"
print_info "  FQDN: $DB_FQDN"
print_info "  Database: ecotask"
print_info "  User: $DB_USER"
print_info "  Password: (configure no Azure DevOps)"
print_info ""
print_info "=========================================="
print_warn "IMPORTANTE: Configure as seguintes variáveis no Azure DevOps:"
print_warn "  - acrPassword (SECRET)"
print_warn "  - dbHost = $DB_FQDN"
print_warn "  - dbPassword (SECRET)"
print_info "=========================================="

