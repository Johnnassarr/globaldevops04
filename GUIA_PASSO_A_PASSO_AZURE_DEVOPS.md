# 🚀 Guia Passo a Passo - Configuração Azure DevOps

**RM:** 556221  
**Projeto:** EcoTask API

---

## 📍 ONDE IR NO AZURE DEVOPS

### 1️⃣ CRIAR SERVICE CONNECTION

**Caminho:**
```
Azure DevOps → Seu Projeto → Project Settings (⚙️) → Service connections → New service connection
```

**Passo a passo DETALHADO:**

1. No Azure DevOps, clique no **ícone de engrenagem (⚙️)** no canto inferior esquerdo
2. Clique em **"Project settings"**
3. No menu lateral esquerdo, vá em **"Service connections"**
4. Clique no botão **"+ New service connection"** (canto superior direito)

**Tela 1: Selecionar Tipo**
5. Na lista, procure e selecione **"Azure Resource Manager"**
6. Clique em **"Next"** (botão no canto inferior direito)

**Tela 2: Método de Autenticação**
7. Selecione **"Service principal (automatic)"** (primeira opção)
   - ⚠️ NÃO selecione "Workload Identity federation" ou "Managed Identity"
8. Clique em **"Next"**

**Tela 3: Configuração do Azure**
9. **Scope level:** Selecione **"Subscription"**
   - ⚠️ NÃO selecione "Management Group"

10. **Subscription:** 
    - Selecione sua subscription do Azure na lista
    - Se não aparecer, clique em "Authorize" e faça login
    - ⚠️ IMPORTANTE: Anote qual subscription você selecionou

11. **Resource group:** 
    - Deixe em branco (vazio) OU
    - Selecione `rg-ecotask-rm556221` se já existir
    - ⚠️ Deixar em branco é melhor (permite criar recursos em qualquer RG)

12. **Service connection name:** 
    - Digite EXATAMENTE: `Azure-Service-Connection`
    - ⚠️ IMPORTANTE: Use este nome exato (com hífen e maiúsculas)

13. **Security:** 
    - Marque **"Grant access permission to all pipelines"** (recomendado)
    - OU deixe desmarcado e autorize manualmente depois

14. Clique em **"Save"** (botão no canto inferior direito)

**✅ Pronto! Service Connection criada.**

**Verificação:**
- Volte em "Service connections" e verifique se aparece `Azure-Service-Connection`
- Se aparecer, está tudo certo!

---

### 2️⃣ CRIAR AMBIENTE "production"

**Caminho:**
```
Azure DevOps → Seu Projeto → Pipelines → Environments → New environment
```

**Passo a passo:**
1. No Azure DevOps, clique em **"Pipelines"** no menu superior
2. Clique em **"Environments"** (menu lateral esquerdo)
3. Clique no botão **"+ New environment"** (canto superior direito)
4. **Name:** Digite: `production`
5. **Type:** Selecione **"None"**
6. Clique em **"Create"**

**✅ Pronto! Ambiente criado.**

---

### 3️⃣ CONFIGURAR VARIÁVEIS DA PIPELINE

**Caminho:**
```
Azure DevOps → Seu Projeto → Pipelines → Selecione sua pipeline → Edit → Variables
```

**Passo a passo:**
1. No Azure DevOps, clique em **"Pipelines"**
2. Clique na sua pipeline (ou crie uma nova apontando para o `azure-pipeline.yml`)
3. Clique em **"Edit"** (canto superior direito)
4. Clique em **"Variables"** (menu superior)
5. Clique em **"+ New variable"** para cada variável abaixo:

#### Variáveis Normais (NÃO marque como secret):

| Nome | Valor | Descrição |
|------|-------|-----------|
| `azureServiceConnection` | `Azure-Service-Connection` | Nome da Service Connection criada |
| `azureRG` | `rg-ecotask-rm556221` | Nome do Resource Group |
| `acrName` | `acrecotaskrm556221` | Nome do ACR |
| `acrLoginServer` | `acrecotaskrm556221.azurecr.io` | URL do ACR |
| `location` | `eastus` | Região do Azure |
| `dbPort` | `5432` | Porta do PostgreSQL |
| `dbName` | `ecotask` | Nome do banco |
| `dbUser` | `postgres` | Usuário do banco |
| `rabbitmqHost` | `localhost` | Host do RabbitMQ (ou deixe localhost) |
| `rabbitmqPort` | `5672` | Porta do RabbitMQ |
| `rabbitmqUser` | `guest` | Usuário do RabbitMQ |
| `rabbitmqPassword` | `guest` | Senha do RabbitMQ |

#### Variáveis Secretas (MARQUE como "Keep this value secret"):

| Nome | Valor | Como Obter |
|------|-------|------------|
| `acrPassword` | `[senha do ACR]` | Veja seção 4 abaixo |
| `dbHost` | `[FQDN do PostgreSQL]` | Veja seção 4 abaixo |
| `dbPassword` | `[senha do PostgreSQL]` | Veja seção 4 abaixo |

**✅ Pronto! Variáveis configuradas.**

---

### 4️⃣ PROVISIONAR RECURSOS AZURE (PostgreSQL e ACR)

**Você tem 2 opções:**

#### Opção A: Via Script (Recomendado)

**Caminho:**
```
Azure Cloud Shell → Executar script-infra-provision.sh
```

**Passo a passo:**
1. Acesse: https://shell.azure.com
2. Faça login no Azure
3. Execute:
```bash
# Fazer upload do script ou copiar conteúdo
bash scripts/script-infra-provision.sh \
  --resource-group rg-ecotask-rm556221 \
  --location eastus \
  --acr-name acrecotaskrm556221 \
  --db-name ecotask-db \
  --db-user postgres \
  --db-password "SuaSenhaSegura123!"
```

4. **Anotar valores gerados:**
   - **ACR Password:** Execute: `az acr credential show --name acrecotaskrm556221 --query passwords[0].value -o tsv`
   - **DB Host:** Execute: `az postgres flexible-server show --resource-group rg-ecotask-rm556221 --name ecotask-db-server --query fullyQualifiedDomainName -o tsv`
   - **DB Password:** A senha que você passou no comando

5. **Volte ao passo 3** e configure essas variáveis no Azure DevOps

#### Opção B: Via Azure Portal (Manual)

**Criar Resource Group:**
1. Acesse: https://portal.azure.com
2. Busque por "Resource groups"
3. Clique em "+ Create"
4. **Name:** `rg-ecotask-rm556221`
5. **Region:** `East US`
6. Clique em "Review + create" → "Create"

**Criar ACR:**
1. No Azure Portal, busque por "Container registries"
2. Clique em "+ Create"
3. **Resource group:** `rg-ecotask-rm556221`
4. **Registry name:** `acrecotaskrm556221`
5. **SKU:** `Basic`
6. Clique em "Review + create" → "Create"
7. Após criar, vá em "Access keys" e anote a senha

**Criar PostgreSQL:**
1. No Azure Portal, busque por "Azure Database for PostgreSQL flexible servers"
2. Clique em "+ Create"
3. **Resource group:** `rg-ecotask-rm556221`
4. **Server name:** `ecotask-db-server`
5. **Region:** `East US`
6. **PostgreSQL version:** `15`
7. **Compute + storage:** `Burstable B1ms` (mais barato)
8. **Admin username:** `postgres`
9. **Password:** Crie uma senha forte
10. Clique em "Review + create" → "Create"
11. Após criar, vá em "Overview" e anote o **FQDN** (fully qualified domain name)

**✅ Pronto! Recursos criados.**

---

## 🔄 RESUMO DO FLUXO COMPLETO

### Passo 1: Criar Service Connection
- ⚙️ Project Settings → Service connections → New → Azure Resource Manager
- Nome: `Azure-Service-Connection`

### Passo 2: Criar Ambiente
- Pipelines → Environments → New environment
- Nome: `production`

### Passo 3: Provisionar Recursos
- Azure Cloud Shell → Executar `script-infra-provision.sh`
- OU Azure Portal → Criar Resource Group, ACR e PostgreSQL manualmente

### Passo 4: Configurar Variáveis
- Pipelines → Sua Pipeline → Edit → Variables
- Adicionar todas as variáveis (normais e secretas)

### Passo 5: Testar Pipeline
- Pipelines → Run pipeline
- Ou criar uma PR para acionar automaticamente

---

## ✅ CHECKLIST FINAL

- [ ] Service Connection criada (`Azure-Service-Connection`)
- [ ] Ambiente `production` criado
- [ ] Resource Group criado (`rg-ecotask-rm556221`)
- [ ] ACR criado (`acrecotaskrm556221`)
- [ ] PostgreSQL criado (`ecotask-db-server`)
- [ ] Variável `acrPassword` configurada (SECRET)
- [ ] Variável `dbHost` configurada (FQDN do PostgreSQL)
- [ ] Variável `dbPassword` configurada (SECRET)
- [ ] Todas as outras variáveis configuradas
- [ ] Pipeline testada e funcionando

---

## 🆘 TROUBLESHOOTING

### Erro: "Service connection not found"
→ Verifique se criou com o nome exato: `Azure-Service-Connection`

### Erro: "Environment not found"
→ Verifique se criou o ambiente com nome: `production`

### Erro: "ACR not found"
→ Execute o script de provisionamento ou crie o ACR manualmente

### Erro: "Database connection refused"
→ Verifique se o PostgreSQL está criado e se `dbHost` está correto

---

**Última atualização:** 2025-11-14

