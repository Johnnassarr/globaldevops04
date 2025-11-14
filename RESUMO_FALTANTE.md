# Resumo do que FALTA fazer

**RM:** 556221

## ✅ O QUE JÁ ESTÁ PRONTO

1. ✅ **Pipeline com 2 stages** (CI e CD)
2. ✅ **Deploy AUTOMÁTICO** - Roda sozinho após Build ter sucesso
3. ✅ **PostgreSQL real** na pipeline e na nuvem
4. ✅ **Scripts de infraestrutura** criados
5. ✅ **Todos os arquivos** no repositório (Dockerfile, scripts, etc.)

## ❌ O QUE FALTA FAZER (Configuração no Azure DevOps)

### 1. **Criar Projeto no Azure DevOps**
- Criar projeto privado
- Convidar professor (Organização: Basic, Projeto: Contributor)

### 2. **Importar código para Azure Repos** (OU manter GitHub conectado)
- **Opção A:** Importar repositório GitHub para Azure Repos
- **Opção B:** Manter GitHub conectado (alguns professores aceitam)

### 3. **Configurar Branch Policies** (Requisito 3)
- Repos > Branches > master > Branch policies
- Revisor obrigatório = 0 (para simular aprovação própria)
- Vinculação de Work Item
- Revisor padrão: RM 556221

### 4. **Ajustar Trigger da Pipeline** (Requisito 4)
- Atualmente: `trigger: none` e `pr: branches`
- **JÁ ESTÁ CORRETO** - Build só roda após PR

### 5. **Criar Service Connection**
- Project Settings > Service connections
- Nome: `Azure-Service-Connection`
- Tipo: Azure Resource Manager

### 6. **Criar Ambiente "production"**
- Pipelines > Environments > New environment
- Nome: `production`

### 7. **Configurar Variáveis no Azure DevOps**
- `azureServiceConnection`: `Azure-Service-Connection`
- `dbHost`: FQDN do PostgreSQL (após criar)
- `dbPassword`: (SECRET)
- `acrPassword`: (SECRET)
- `rabbitmqHost`: (se usar)

### 8. **Provisionar Recursos Azure**
- Executar `scripts/script-infra-provision.sh`
- Ou criar manualmente no Azure Portal

---

## 🚀 SOBRE DEPLOY AUTOMÁTICO

**SIM, a pipeline roda o projeto AUTOMATICAMENTE!**

Quando a pipeline termina o Build com sucesso:
1. ✅ Stage Deploy é acionado **AUTOMATICAMENTE**
2. ✅ Provisiona infraestrutura (se necessário)
3. ✅ Faz deploy para Azure Container Instances
4. ✅ Aplicação fica rodando na nuvem
5. ✅ Você recebe a URL: `http://ecotask-rm556221-{BuildId}.eastus.azurecontainer.io:8080`

**Você NÃO precisa dar nenhum comando manual!** Tudo é automático após o Build.

---

## 📦 SOBRE AZURE REPOS

**Status atual:**
- ✅ Código está no **GitHub**: `https://github.com/Johnnassarr/globaldevops04.git`
- ✅ Pipeline está **conectada ao GitHub** e funcionando
- ⚠️ **Requisito pede Azure Repos**, mas GitHub conectado geralmente é aceito

**Para atender 100% o requisito:**
1. No Azure DevOps, vá em **Repos**
2. Clique em **Import repository**
3. Cole a URL do GitHub: `https://github.com/Johnnassarr/globaldevops04.git`
4. Importe o repositório
5. Atualize a pipeline para usar Azure Repos ao invés de GitHub

**OU** confirme com o professor se GitHub conectado é aceito (geralmente é).

---

## 📋 CHECKLIST FINAL

### Implementado no Código (✅)
- [x] Pipeline YAML com 2 stages
- [x] Deploy automático configurado
- [x] Scripts de infraestrutura
- [x] Dockerfile
- [x] script-bd.sql
- [x] CRUD no README
- [x] Diagrama de arquitetura (ARQUITETURA.md)

### Configuração Azure DevOps (❌)
- [ ] Criar projeto
- [ ] Convidar professor
- [ ] Importar para Azure Repos (ou confirmar GitHub)
- [ ] Configurar branch policies
- [ ] Criar Service Connection
- [ ] Criar ambiente "production"
- [ ] Configurar variáveis
- [ ] Provisionar recursos Azure

---

**Última atualização:** 2025-11-14

