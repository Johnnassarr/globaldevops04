#!/bin/bash
# =============================================================================
# Script de Destruição de Infraestrutura Azure - EcoTask
# =============================================================================
# Este script remove todos os recursos criados no Azure
# ATENÇÃO: Esta ação é irreversível!
# RM: 556221
# =============================================================================

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

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

while [[ $# -gt 0 ]]; do
    case $1 in
        --resource-group)
            RESOURCE_GROUP="$2"
            shift 2
            ;;
        *)
            print_error "Opção desconhecida: $1"
            echo "Uso: $0 --resource-group <rg-name>"
            exit 1
            ;;
    esac
done

if [ -z "$RESOURCE_GROUP" ]; then
    print_error "Resource Group é obrigatório!"
    exit 1
fi

print_warn "=========================================="
print_warn "DESTRUINDO INFRAESTRUTURA AZURE"
print_warn "=========================================="
print_warn "Resource Group: $RESOURCE_GROUP"
print_warn "ATENÇÃO: Esta ação é irreversível!"
print_warn "=========================================="

read -p "Tem certeza que deseja continuar? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    print_info "Operação cancelada."
    exit 0
fi

# Verificar se está logado no Azure
if ! az account show &> /dev/null; then
    print_error "Não está logado no Azure. Execute: az login"
    exit 1
fi

# Deletar Resource Group (remove todos os recursos)
print_info "Deletando Resource Group: $RESOURCE_GROUP"
if az group show --name "$RESOURCE_GROUP" &> /dev/null; then
    az group delete --name "$RESOURCE_GROUP" --yes --no-wait
    print_info "✓ Resource Group marcado para exclusão (pode levar alguns minutos)"
else
    print_warn "Resource Group não encontrado: $RESOURCE_GROUP"
fi

print_info "=========================================="
print_info "DESTRUIÇÃO INICIADA"
print_info "=========================================="

