# 📝 Variáveis - O que Criar no Azure DevOps

**RM:** 556221

## ❌ NÃO PRECISA CRIAR (já estão no código)

Estas variáveis já estão definidas no `azure-pipeline.yml`, então **NÃO precisa criar** no Azure DevOps:
- `azureServiceConnection` = já está no código
- `azureRG` = já está no código  
- `acrName` = já está no código
- `acrLoginServer` = já está no código
- `location` = já está no código
- `imageName` = já está no código
- `imageTag` = já está no código

## ✅ PRECISA CRIAR no Azure DevOps

**Onde:** Pipelines → [Sua Pipeline] → Edit → Variables → + New variable

### Variáveis Normais (NÃO marcar como secret):
1. `dbPort` = `5432`
2. `dbName` = `ecotask`
3. `dbUser` = `postgres`
4. `rabbitmqHost` = `localhost`
5. `rabbitmqPort` = `5672`
6. `rabbitmqUser` = `guest`
7. `rabbitmqPassword` = `guest`

### Variáveis Secretas (MARQUE como "Keep this value secret"):
1. `acrPassword` = [senha do ACR - você vai obter depois de criar o ACR]
2. `dbHost` = [FQDN do PostgreSQL - você vai obter depois de criar o PostgreSQL]
3. `dbPassword` = [senha do PostgreSQL - a que você definir ao criar]

---

## 🎯 RESUMO

**Você só precisa criar 10 variáveis:**
- 7 normais (dbPort, dbName, dbUser, rabbitmqHost, rabbitmqPort, rabbitmqUser, rabbitmqPassword)
- 3 secretas (acrPassword, dbHost, dbPassword)

**As outras já estão no código e funcionam automaticamente!**

---

**Nota:** Se quiser, pode criar TODAS no Azure DevOps (isso sobrescreve as do código), mas não é necessário.

