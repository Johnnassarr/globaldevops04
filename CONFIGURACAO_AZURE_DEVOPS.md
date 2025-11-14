# Guia de Configuração - Azure DevOps

**RM:** 556221  
**Projeto:** EcoTask API

## 📋 Checklist de Configuração

### ✅ 1. Criar Service Connection

1. No Azure DevOps, vá em **Project Settings** (ícone de engrenagem)
2. Clique em **Service connections**
3. Clique em **New service connection**
4. Selecione **Azure Resource Manager**
5. Escolha **Service principal (automatic)**
6. Selecione sua **Subscription** do Azure
7. **Resource group:** Deixe em branco ou selecione um existente
8. **Service connection name:** `Azure-Service-Connection` (IMPORTANTE: use este nome exato)
9. Clique em **Save**

### ✅ 2. Criar Ambiente "production"

1. No Azure DevOps, vá em **Pipelines** > **Environments**
2. Clique em **New environment**
3. **Name:** `production`
4. **Type:** None (ou Kubernetes se preferir)
5. Clique em **Create**

### ✅ 3. Configurar Variáveis da Pipeline

1. No Azure DevOps, vá em **Pipelines** > Selecione sua pipeline
2. Clique em **Edit** > **Variables**
3. Adicione as seguintes variáveis:

#### Variáveis Normais:
- `azureServiceConnection`: `Azure-Service-Connection` (nome da Service Connection criada)
- `azureRG`: `rg-ecotask-rm556221`
- `acrName`: `acrecotaskrm556221`
- `acrLoginServer`: `acrecotaskrm556221.azurecr.io`
- `location`: `eastus`
- `dbHost`: FQDN do PostgreSQL (será obtido após criar o banco)
- `dbPort`: `5432`
- `dbName`: `ecotask`
- `dbUser`: `postgres`
- `rabbitmqHost`: Host do RabbitMQ (se usar)
- `rabbitmqUser`: `guest`
- `rabbitmqPassword`: `guest`

#### Variáveis Secretas (marque como SECRET):
- `acrPassword`: Senha do ACR (obter após criar: `az acr credential show --name acrecotaskrm556221`)
- `dbPassword`: Senha do banco de dados PostgreSQL

### ✅ 4. Criar Recursos Azure (Primeira Vez)

Execute o script de provisionamento:

```bash
# No Azure Cloud Shell ou com Azure CLI instalado
az login

# Executar script
bash scripts/script-infra-provision.sh \
  --resource-group rg-ecotask-rm556221 \
  --location eastus \
  --acr-name acrecotaskrm556221 \
  --db-name ecotask-db \
  --db-user postgres \
  --db-password "SuaSenhaSegura123!"
```

Após executar, anote:
- **ACR Password:** Execute `az acr credential show --name acrecotaskrm556221 --query passwords[0].value -o tsv`
- **DB Host:** Execute `az postgres flexible-server show --resource-group rg-ecotask-rm556221 --name ecotask-db-server --query fullyQualifiedDomainName -o tsv`

### ✅ 5. Configurar Branch Policies (Requisito 3)

1. No Azure DevOps, vá em **Repos** > **Branches**
2. Clique nos **3 pontos** ao lado da branch `master` > **Branch policies**
3. Configure:
   - **Require a minimum number of reviewers:** `0` (para simular aprovação própria)
   - **Check for linked work items:** Habilitado
   - **Check for comment resolution:** Habilitado (opcional)
   - **Build validation:** Adicione a pipeline de Build
   - **Required reviewers:** Adicione seu RM (556221) como revisor padrão

### ✅ 6. Verificar Pool Self-Hosted

1. No Azure DevOps, vá em **Project Settings** > **Agent pools**
2. Verifique se existe um pool chamado `self-hosted-pool`
3. Se não existir:
   - Crie um novo pool OU
   - Altere na pipeline `azure-pipeline.yml` linha 310 de `name: 'self-hosted-pool'` para `vmImage: 'ubuntu-latest'` (requer paralelismo)

## 🚀 Testar Pipeline

1. Crie uma Pull Request de uma branch qualquer para `master`
2. A pipeline deve ser acionada automaticamente
3. Após merge, o Deploy deve executar automaticamente

## ❌ Resolução de Problemas

### Erro: "Service connection not found"
- ✅ Verifique se criou a Service Connection com o nome exato: `Azure-Service-Connection`
- ✅ Verifique se a variável `azureServiceConnection` está configurada na pipeline

### Erro: "Environment not found"
- ✅ Crie o ambiente `production` em Pipelines > Environments

### Erro: "Pool not found"
- ✅ Verifique se o pool `self-hosted-pool` existe
- ✅ Ou altere para `vmImage: 'ubuntu-latest'` (requer paralelismo)

### Erro: "ACR not found"
- ✅ Execute o script de provisionamento primeiro
- ✅ Ou crie o ACR manualmente no Azure Portal

---

**Última atualização:** 2025-11-14

