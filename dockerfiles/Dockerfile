# =============================================================================
# Dockerfile para Aplicação Java Spring Boot - EcoTask API
# =============================================================================
# Este Dockerfile cria uma imagem otimizada usando multi-stage build
# e executa a aplicação como usuário não-root
# =============================================================================

# -----------------------------------------------------------------------------
# STAGE 1: BUILD
# -----------------------------------------------------------------------------
# Usa imagem oficial do Maven com Java 21 para compilar a aplicação
FROM maven:3.9.6-eclipse-temurin-21-alpine AS builder

# Define diretório de trabalho
WORKDIR /app

# Copia os arquivos de configuração do Maven
COPY pom.xml .

# Baixa as dependências (camada cacheável)
RUN mvn dependency:go-offline -B

# Copia o código fonte
COPY src ./src

# Compila a aplicação (pula os testes para build mais rápido no Docker)
RUN mvn clean package -DskipTests -B

# -----------------------------------------------------------------------------
# STAGE 2: RUNTIME
# -----------------------------------------------------------------------------
# Usa imagem oficial JRE minimalista para executar a aplicação
FROM eclipse-temurin:21-jre-alpine

# Metadados da imagem
LABEL maintainer="DevOps Tools & Cloud Computing - RM556221"
LABEL description="EcoTask API - Sistema de Gerenciamento de Tarefas Sustentáveis"
LABEL version="1.0"

# Cria usuário não-root para executar a aplicação
RUN addgroup -S spring && adduser -S spring -G spring

# Define diretório de trabalho
WORKDIR /app

# Copia o JAR compilado do stage anterior
COPY --from=builder /app/target/*.jar app.jar

# Define permissões para o usuário spring
RUN chown -R spring:spring /app

# Muda para o usuário não-root
USER spring

# Expõe a porta da aplicação
EXPOSE 8080

# Variáveis de ambiente (podem ser sobrescritas no deploy)
ENV SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/ecotask
ENV SPRING_DATASOURCE_USERNAME=postgres
ENV SPRING_DATASOURCE_PASSWORD=1234
ENV SPRING_RABBITMQ_HOST=localhost
ENV SPRING_RABBITMQ_PORT=5672
ENV SPRING_RABBITMQ_USERNAME=guest
ENV SPRING_RABBITMQ_PASSWORD=guest
ENV JAVA_OPTS="-Xms512m -Xmx1024m"

# Healthcheck para verificar se a aplicação está rodando
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# Comando para iniciar a aplicação
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]

