# Checklist de Requisitos - DevOps Tools & Cloud Computing

**RM:** 556221  
**Projeto:** EcoTask API

## ✅ TAREFAS OBRIGATÓRIAS

### 1) Provisionamento em Nuvem (Azure CLI)
- ✅ **Scripts criados:**
  - `scripts/script-infra-provision.sh` - Cria Resource Group, ACR, PostgreSQL
  - `scripts/script-infra-destroy.sh` - Remove recursos
- ✅ **Recursos provisionados via script:**
  - Resource Group
  - Azure Container Registry (ACR)
  - Azure Database for PostgreSQL
- ✅ **Build e Deploy utilizam recursos criados:** Sim, pipeline configurada

### 2) Projeto no Azure DevOps
- ⚠️ **AÇÃO NECESSÁRIA:**
  - Criar projeto no Azure DevOps (se ainda não criou)
  - Convidar professor com permissões:
    - Organização: Basic
    - Projeto: Contributor
  - Confirmar e-mail do professor

### 3) Código no Azure Repos
- ⚠️ **ATENÇÃO:** Código está no GitHub
- ⚠️ **AÇÃO NECESSÁRIA:**
  - Importar repositório para Azure Repos OU
  - Conectar pipeline ao GitHub (já configurado)
  - Verificar se atende requisito (alguns professores aceitam GitHub conectado)

## ✅ TAREFAS OBRIGATÓRIAS (Continuação)

### 5) Pipeline de Build
- ✅ **Criada no Azure Pipelines (YAML):** `azure-pipeline.yml`
- ⚠️ **Trigger automático:** Configurado, mas precisa ajustar para PR
- ✅ **Publica artefatos:** Sim (target/)
- ✅ **Publica testes JUnit:** Sim (surefire-reports)

### 6) Pipeline de Release
- ✅ **Deploy automático criado:** Stage Deploy configurado
- ✅ **Roda após Build:** `dependsOn: Build`
- ✅ **Deploy na nuvem:** Azure Container Instances (ACI)

## ✅ REQUISITOS DA IMPLEMENTAÇÃO

### 1) Projeto privado e com Git
- ✅ **Git para versionamento:** Sim
- ⚠️ **Projeto privado:** Verificar configuração no Azure DevOps/GitHub

### 3) Branch principal protegida
- ❌ **FALTA CONFIGURAR:**
  - Revisor obrigatório
  - Vinculação de Work Item
  - Revisor padrão (RM 556221)
- ⚠️ **AÇÃO:** Configurar no Azure DevOps: Repos > Branches > master > Branch policies

### 4) Build acionado somente após Merge via PR
- ⚠️ **ATUAL:** Build roda em commit direto na master
- ❌ **FALTA AJUSTAR:**
  - Remover trigger direto na master
  - Manter apenas trigger em PR
- ⚠️ **AÇÃO:** Ajustar `azure-pipeline.yml` - remover trigger de branches, manter apenas PR

### 5) Aluno pode aprovar própria PR (simulação)
- ⚠️ **AÇÃO:** Configurar em Branch policies > Require a minimum number of reviewers = 0

### 6) Release executa automaticamente após novo artefato
- ✅ **Configurado:** `dependsOn: Build` e `condition: succeeded()`

### 7) Deploy por Container (ACI/ACR)
- ✅ **Implementado:** Deploy para Azure Container Instances
- ✅ **Usa ACR:** Imagem é puxada do ACR

### 8) Banco de dados em Serviço PaaS
- ✅ **PostgreSQL PaaS:** Azure Database for PostgreSQL (Flexible Server)
- ✅ **Testes publicados:** JUnit publicado na pipeline
- ✅ **Artefatos publicados:** target/ publicado

### 9) Imagens oficiais
- ✅ **Dockerfile usa imagens oficiais:**
  - `maven:3.9.6-eclipse-temurin-21-alpine` (Maven oficial)
  - `eclipse-temurin:21-jre-alpine` (Eclipse Temurin oficial)
  - `postgres:15-alpine` (PostgreSQL oficial)

### 10) Scripts de infraestrutura no repositório
- ✅ **Scripts presentes:**
  - `scripts/script-infra-provision.sh`
  - `scripts/script-infra-destroy.sh`

### 11) Arquivo script-bd.sql na pasta /scripts
- ✅ **Arquivo existe:** `scripts/script-bd.sql`

### 12) Scripts Azure CLI com prefixo script-infra
- ✅ **Conforme:** 
  - `scripts/script-infra-provision.sh`
  - `scripts/script-infra-destroy.sh`

### 13) Dockerfiles na pasta /dockerfiles
- ✅ **Dockerfile presente:** `dockerfiles/Dockerfile`

### 14) Arquivo azure-pipeline.yml na raiz
- ✅ **Arquivo presente:** `azure-pipeline.yml` na raiz

### 15) CRUD exposto em JSON no README
- ✅ **Implementado:** README.md contém todos os endpoints CRUD em formato JSON

### 16) Variáveis de ambiente e dados sensíveis protegidos
- ✅ **Variáveis configuradas:** Pipeline usa variáveis
- ✅ **Dados sensíveis:** Configurados como SECRET no Azure DevOps
- ✅ **Variáveis de ambiente:** Configuradas no deploy (ACI)

### 17) Desenho macro da arquitetura
- ⚠️ **PARCIAL:** README tem diagrama simples em texto
- ❌ **FALTA:** Diagrama visual mais detalhado
- ⚠️ **AÇÃO:** Criar diagrama usando draw.io, Lucidchart ou similar

---

## 📊 RESUMO

### ✅ IMPLEMENTADO (15/17)
1. ✅ Provisionamento Azure CLI
2. ✅ Pipeline Build
3. ✅ Pipeline Release/Deploy
4. ✅ Deploy ACI/ACR
5. ✅ Banco PaaS (PostgreSQL)
6. ✅ Testes JUnit publicados
7. ✅ Artefatos publicados
8. ✅ Imagens oficiais
9. ✅ Scripts no repositório
10. ✅ script-bd.sql
11. ✅ Scripts com prefixo script-infra
12. ✅ Dockerfiles na pasta
13. ✅ azure-pipeline.yml na raiz
14. ✅ CRUD no README
15. ✅ Variáveis de ambiente protegidas

### ⚠️ AÇÕES NECESSÁRIAS (2/17)
1. ⚠️ **Branch protegida** - Configurar no Azure DevOps
2. ⚠️ **Build apenas após PR** - Ajustar trigger na pipeline
3. ⚠️ **Desenho de arquitetura** - Criar diagrama visual detalhado
4. ⚠️ **Projeto Azure DevOps** - Criar e convidar professor
5. ⚠️ **Azure Repos** - Importar código ou confirmar GitHub

---

## 🔧 PRÓXIMAS AÇÕES PRIORITÁRIAS

1. **Ajustar trigger da pipeline** para rodar apenas após PR
2. **Configurar branch policies** no Azure DevOps
3. **Criar diagrama de arquitetura** visual
4. **Criar projeto Azure DevOps** e convidar professor
5. **Testar pipeline completa** (Build + Deploy)

