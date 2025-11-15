# 🎯 Próximos Passos - Configuração Azure DevOps

**RM:** 556221

## ✅ O QUE VOCÊ JÁ FEZ
- [x] Service Connection criada (`Azure-Service-Connection`)

## 📋 O QUE FALTA FAZER (em ordem)

### 1️⃣ Criar Ambiente "production" (2 minutos)

**Onde:** Azure DevOps → Pipelines → Environments → + New environment

**O que fazer:**
- Name: `production`
- Type: `None`
- Clique em "Create"

---

### 2️⃣ Provisionar Recursos Azure (5-10 minutos)

**Opção A: Via Script (Mais fácil)**

1. Acesse: https://shell.azure.com
2. Faça login
3. Execute:
```bash
az login

# Baixar o script (ou copiar do repositório)
git clone https://github.com/Johnnassarr/globaldevops04.git
cd globaldevops04

# Executar provisionamento
bash scripts/script-infra-provision.sh \
  --resource-group rg-ecotask-rm556221 \
  --location eastus \
  --acr-name acrecotaskrm556221 \
  --db-name ecotask-db \
  --db-user postgres \
  --db-password "SuaSenhaSegura123!"
```

4. **Anotar valores:**
```bash
# ACR Password
az acr credential show --name acrecotaskrm556221 --query passwords[0].value -o tsv

# DB Host (FQDN)
az postgres flexible-server show --resource-group rg-ecotask-rm556221 --name ecotask-db-server --query fullyQualifiedDomainName -o tsv
```

**Opção B: Via Portal (Manual)**
- Veja `GUIA_PASSO_A_PASSO_AZURE_DEVOPS.md` seção 4

---

### 3️⃣ Configurar Variáveis da Pipeline (3 minutos)

**Onde:** Azure DevOps → Pipelines → [Sua Pipeline] → Edit → Variables

**Variáveis para adicionar:**

#### Normais (NÃO marcar como secret):
- `azureServiceConnection` = `Azure-Service-Connection`
- `azureRG` = `rg-ecotask-rm556221`
- `acrName` = `acrecotaskrm556221`
- `acrLoginServer` = `acrecotaskrm556221.azurecr.io`
- `location` = `eastus`
- `dbPort` = `5432`
- `dbName` = `ecotask`
- `dbUser` = `postgres`
- `rabbitmqHost` = `localhost`
- `rabbitmqPort` = `5672`
- `rabbitmqUser` = `guest`
- `rabbitmqPassword` = `guest`

#### Secretas (MARQUE como "Keep this value secret"):
- `acrPassword` = [senha do ACR - do passo 2]
- `dbHost` = [FQDN do PostgreSQL - do passo 2]
- `dbPassword` = `SuaSenhaSegura123!` (ou a senha que você usou)

---

### 4️⃣ Testar Pipeline

**Onde:** Azure DevOps → Pipelines → Run pipeline

OU criar uma PR para acionar automaticamente.

---

## ✅ CHECKLIST RÁPIDO

- [ ] Service Connection criada ✅ (você já fez!)
- [ ] Ambiente "production" criado
- [ ] Recursos Azure provisionados (ACR + PostgreSQL)
- [ ] Variáveis configuradas na pipeline
- [ ] Pipeline testada

---

**Próximo passo agora:** Criar o Ambiente "production" (passo 1 acima)

