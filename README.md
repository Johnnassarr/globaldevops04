# EcoTask API

Sistema de Gerenciamento de Tarefas Sustentáveis - API REST desenvolvida em Java Spring Boot.

**RM:** 556221  
**Disciplina:** DevOps Tools & Cloud Computing

## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Tecnologias](#tecnologias)
- [Arquitetura](#arquitetura)
- [Pré-requisitos](#pré-requisitos)
- [Instalação e Execução](#instalação-e-execução)
- [API Endpoints (CRUD)](#api-endpoints-crud)
- [Pipeline CI/CD](#pipeline-cicd)
- [Infraestrutura Azure](#infraestrutura-azure)

## 🎯 Sobre o Projeto

EcoTask é uma API REST para gerenciamento de tarefas sustentáveis, permitindo que usuários criem, gerenciem e completem tarefas relacionadas à sustentabilidade, ganhando pontos e recompensas.

## 🛠 Tecnologias

- **Java 21**
- **Spring Boot 3.5.7**
- **PostgreSQL 15**
- **RabbitMQ**
- **Docker & Docker Compose**
- **Azure DevOps Pipelines**
- **Azure Container Registry (ACR)**
- **Azure Container Instances (ACI)**

## 🏗 Arquitetura

```
┌─────────────────┐
│   Azure ACI     │
│  (EcoTask API)  │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
┌───▼───┐ ┌──▼────┐
│PostgreSQL│ │RabbitMQ│
│ (Azure)  │ │ (Azure)│
└─────────┘ └────────┘
```

## 📦 Pré-requisitos

- Java 21
- Maven 3.9+
- Docker & Docker Compose
- Azure CLI (para deploy)
- Azure DevOps (para CI/CD)

## 🚀 Instalação e Execução

### Local com Docker Compose

```bash
# Clonar repositório
git clone <repository-url>
cd ecotask-java-main

# Executar com Docker Compose
docker-compose up -d

# A API estará disponível em http://localhost:8080
```

### Local sem Docker

```bash
# Configurar banco de dados PostgreSQL local
# Editar application.properties com suas credenciais

# Executar aplicação
./mvnw spring-boot:run
```

## 📡 API Endpoints (CRUD)

### Base URL
```
http://localhost:8080
```

### Autenticação

#### 1. Login
```json
POST /auth/login
Content-Type: application/json

{
  "email": "admin@tarefasustentavel.com",
  "password": "123456"
}

Response:
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### 2. Registro
```json
POST /auth/register
Content-Type: application/json

{
  "username": "usuario",
  "email": "usuario@example.com",
  "password": "senha123",
  "role": "USER"
}

Response:
{
  "status": 200,
  "message": "Usuário registrado com sucesso",
  "timestamp": "2025-11-13T14:23:00"
}
```

### Usuários

#### Listar Todos
```json
GET /usuarios
Authorization: Bearer {token}

Response:
[
  {
    "id": 1,
    "username": "admin",
    "email": "admin@tarefasustentavel.com",
    "role": "ADMIN"
  }
]
```

#### Buscar por ID
```json
GET /usuarios/{id}
Authorization: Bearer {token}

Response:
{
  "id": 1,
  "username": "admin",
  "email": "admin@tarefasustentavel.com",
  "role": "ADMIN"
}
```

#### Atualizar
```json
PUT /usuarios/{id}
Authorization: Bearer {token}
Content-Type: application/json

{
  "username": "admin_updated",
  "email": "admin@tarefasustentavel.com",
  "role": "ADMIN"
}

Response:
{
  "id": 1,
  "username": "admin_updated",
  "email": "admin@tarefasustentavel.com",
  "role": "ADMIN"
}
```

#### Deletar
```json
DELETE /usuarios/{id}
Authorization: Bearer {token}

Response: 204 No Content
```

### Tarefas

#### Listar Todas
```json
GET /tarefas
Authorization: Bearer {token}

Response:
[
  {
    "id": 1,
    "titulo": "Separar o lixo reciclável",
    "descricao": "Organize os resíduos recicláveis corretamente.",
    "completado": false,
    "dataCriacao": "2025-11-13",
    "points": 10,
    "missao": {...},
    "categoria": {...},
    "usuario": {...}
  }
]
```

#### Listar com Paginação
```json
GET /tarefas/paginated?page=0&size=10
Authorization: Bearer {token}

Response:
{
  "content": [...],
  "page": 0,
  "size": 10,
  "totalElements": 50,
  "totalPages": 5
}
```

#### Buscar por ID
```json
GET /tarefas/{id}
Authorization: Bearer {token}

Response:
{
  "id": 1,
  "titulo": "Separar o lixo reciclável",
  "descricao": "Organize os resíduos recicláveis corretamente.",
  "completado": false,
  "dataCriacao": "2025-11-13",
  "points": 10
}
```

#### Criar
```json
POST /tarefas
Authorization: Bearer {token}
Content-Type: application/json

{
  "titulo": "Nova tarefa sustentável",
  "descricao": "Descrição da tarefa",
  "dataCriacao": "2025-11-13",
  "points": 15,
  "missaoId": 1,
  "categoriaId": 1,
  "usuarioId": 2
}

Response:
{
  "id": 6,
  "titulo": "Nova tarefa sustentável",
  "descricao": "Descrição da tarefa",
  "completado": false,
  "dataCriacao": "2025-11-13",
  "points": 15
}
```

#### Atualizar
```json
PUT /tarefas/{id}
Authorization: Bearer {token}
Content-Type: application/json

{
  "titulo": "Tarefa atualizada",
  "descricao": "Nova descrição",
  "completado": true,
  "points": 20
}

Response:
{
  "id": 1,
  "titulo": "Tarefa atualizada",
  "descricao": "Nova descrição",
  "completado": true,
  "points": 20
}
```

#### Deletar
```json
DELETE /tarefas/{id}
Authorization: Bearer {token}

Response: 204 No Content
```

### Categorias de Sustentabilidade

#### Listar Todas
```json
GET /categorias
Authorization: Bearer {token}

Response:
[
  {
    "id": 1,
    "nome": "Reciclagem",
    "descricao": "Categoria voltada à separação e reaproveitamento de materiais recicláveis.",
    "nivelImpacto": "ALTO"
  }
]
```

#### Criar
```json
POST /categorias
Authorization: Bearer {token}
Content-Type: application/json

{
  "nome": "Energia Solar",
  "descricao": "Categoria relacionada ao uso de energia solar",
  "nivelImpacto": "ALTO"
}

Response:
{
  "id": 4,
  "nome": "Energia Solar",
  "descricao": "Categoria relacionada ao uso de energia solar",
  "nivelImpacto": "ALTO"
}
```

#### Atualizar
```json
PUT /categorias/{id}
Authorization: Bearer {token}
Content-Type: application/json

{
  "nome": "Reciclagem Atualizada",
  "descricao": "Nova descrição",
  "nivelImpacto": "MEDIO"
}

Response:
{
  "id": 1,
  "nome": "Reciclagem Atualizada",
  "descricao": "Nova descrição",
  "nivelImpacto": "MEDIO"
}
```

#### Deletar
```json
DELETE /categorias/{id}
Authorization: Bearer {token}

Response: 204 No Content
```

### Missões Sustentáveis

#### Listar Todas
```json
GET /missoes
Authorization: Bearer {token}

Response:
[
  {
    "id": 1,
    "nome": "Missão Verde Semanal",
    "descricao": "Complete tarefas de reciclagem e consumo consciente durante a semana.",
    "dataInicio": "2025-11-13",
    "dataFim": "2025-11-20",
    "ativa": true
  }
]
```

#### Criar
```json
POST /missoes
Authorization: Bearer {token}
Content-Type: application/json

{
  "nome": "Nova Missão",
  "descricao": "Descrição da missão",
  "dataInicio": "2025-11-13",
  "dataFim": "2025-11-20",
  "ativa": true
}

Response:
{
  "id": 4,
  "nome": "Nova Missão",
  "descricao": "Descrição da missão",
  "dataInicio": "2025-11-13",
  "dataFim": "2025-11-20",
  "ativa": true
}
```

#### Atualizar
```json
PUT /missoes/{id}
Authorization: Bearer {token}
Content-Type: application/json

{
  "nome": "Missão Atualizada",
  "descricao": "Nova descrição",
  "dataInicio": "2025-11-13",
  "dataFim": "2025-11-25",
  "ativa": false
}

Response:
{
  "id": 1,
  "nome": "Missão Atualizada",
  "descricao": "Nova descrição",
  "dataInicio": "2025-11-13",
  "dataFim": "2025-11-25",
  "ativa": false
}
```

#### Deletar
```json
DELETE /missoes/{id}
Authorization: Bearer {token}

Response: 204 No Content
```

### Recompensas

#### Listar Todas
```json
GET /recompensas
Authorization: Bearer {token}

Response:
[
  {
    "id": 1,
    "nome": "Certificado Verde",
    "descricao": "Reconhecimento simbólico por práticas sustentáveis consistentes.",
    "pontosRequiridos": 50,
    "ativado": true
  }
]
```

#### Criar
```json
POST /recompensas
Authorization: Bearer {token}
Content-Type: application/json

{
  "nome": "Nova Recompensa",
  "descricao": "Descrição da recompensa",
  "pontosRequiridos": 75,
  "ativado": true
}

Response:
{
  "id": 5,
  "nome": "Nova Recompensa",
  "descricao": "Descrição da recompensa",
  "pontosRequiridos": 75,
  "ativado": true
}
```

#### Atualizar
```json
PUT /recompensas/{id}
Authorization: Bearer {token}
Content-Type: application/json

{
  "nome": "Recompensa Atualizada",
  "descricao": "Nova descrição",
  "pontosRequiridos": 100,
  "ativado": false
}

Response:
{
  "id": 1,
  "nome": "Recompensa Atualizada",
  "descricao": "Nova descrição",
  "pontosRequiridos": 100,
  "ativado": false
}
```

#### Deletar
```json
DELETE /recompensas/{id}
Authorization: Bearer {token}

Response: 204 No Content
```

## 🔄 Pipeline CI/CD

A pipeline está configurada no arquivo `azure-pipeline.yml` e possui dois estágios:

### Stage 1: Build (CI)
- ✅ Checkout do código
- ✅ Instalação/verificação do Java 21
- ✅ Build com Maven (executa testes)
- ✅ Publicação de resultados de testes (JUnit)
- ✅ Publicação de artefatos
- ✅ Build da imagem Docker
- ✅ Push para Azure Container Registry (ACR)

### Stage 2: Deploy (CD)
- ✅ Provisionamento de infraestrutura (se necessário)
- ✅ Deploy para Azure Container Instances (ACI)
- ✅ Configuração de variáveis de ambiente

### Variáveis Necessárias no Azure DevOps

Configure as seguintes variáveis no Azure DevOps (Project Settings > Pipelines > Variables):

**Variáveis Normais:**
- `azureServiceConnection`: ID da Service Connection do Azure
- `azureRG`: `rg-ecotask-rm556221`
- `acrName`: `acrecotaskrm556221`
- `acrLoginServer`: `acrecotaskrm556221.azurecr.io`
- `location`: `eastus`
- `dbHost`: FQDN do servidor PostgreSQL
- `dbPort`: `5432`
- `dbName`: `ecotask`
- `dbUser`: `postgres`
- `rabbitmqHost`: Host do RabbitMQ
- `rabbitmqUser`: `guest`
- `rabbitmqPassword`: `guest`

**Variáveis Secretas:**
- `acrPassword`: Senha do ACR
- `dbPassword`: Senha do banco de dados PostgreSQL

## ☁️ Infraestrutura Azure

### Scripts de Provisionamento

Os scripts estão localizados em `/scripts`:

- **`script-infra-provision.sh`**: Cria todos os recursos Azure necessários
- **`script-infra-destroy.sh`**: Remove todos os recursos (destruição)

### Recursos Criados

1. **Resource Group**: `rg-ecotask-rm556221`
2. **Azure Container Registry (ACR)**: `acrecotaskrm556221`
3. **Azure Database for PostgreSQL**: Flexible Server
4. **Azure Container Instances (ACI)**: Para deploy da aplicação

### Executar Provisionamento

```bash
# Fazer login no Azure
az login

# Executar script de provisionamento
bash scripts/script-infra-provision.sh \
  --resource-group rg-ecotask-rm556221 \
  --location eastus \
  --acr-name acrecotaskrm556221 \
  --db-name ecotask-db \
  --db-user postgres \
  --db-password <senha-segura>
```

## 📝 Estrutura de Arquivos

```
ecotask-java-main/
├── azure-pipeline.yml          # Pipeline CI/CD
├── docker-compose.yml           # Docker Compose para ambiente local
├── pom.xml                      # Configuração Maven
├── dockerfiles/
│   └── Dockerfile              # Dockerfile da aplicação
├── scripts/
│   ├── script-bd.sql           # Script SQL consolidado
│   ├── script-infra-provision.sh  # Provisionamento Azure
│   └── script-infra-destroy.sh    # Destruição de recursos
└── src/
    └── main/
        ├── java/               # Código fonte Java
        └── resources/
            ├── application.properties
            └── db/migration/   # Migrações Flyway
```

## 🔐 Segurança

- Autenticação JWT
- Senhas criptografadas com BCrypt
- Variáveis sensíveis protegidas no Azure DevOps
- Usuário não-root no container Docker

## 📄 Licença

Este projeto foi desenvolvido para fins acadêmicos.

## 👤 Autor

**RM:** 556221  
**Disciplina:** DevOps Tools & Cloud Computing

